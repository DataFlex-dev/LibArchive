[CmdletBinding()]
param(
    [string] $DfCli = 'df-cli',
    [string] $Toolchain = '26.0.0+windows-64',
    [switch] $KeepFixtures
)

$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$libraryRoot = Join-Path $repoRoot 'Library'
$workspace = Join-Path $libraryRoot 'LibArchive.sws'
$fixtureRoot = Join-Path $libraryRoot 'Data\ArchiveReaderTests'
$testExe = Join-Path $libraryRoot 'Programs\ArchiveReaderTests64.exe'
$nativeRoot = Join-Path $repoRoot 'Demo\Programs'
$resultsFile = Join-Path $fixtureRoot 'results.xml'

Add-Type -AssemblyName System.IO.Compression

function New-TestZip {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [AllowEmptyCollection()] [hashtable[]] $Entries
    )

    $stream = [IO.File]::Open($Path, [IO.FileMode]::Create, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
    try {
        $archive = [IO.Compression.ZipArchive]::new(
            $stream,
            [IO.Compression.ZipArchiveMode]::Create,
            $false
        )
        try {
            foreach ($spec in $Entries) {
                $compression = if ($spec.ContainsKey('Compression')) {
                    $spec.Compression
                } else {
                    [IO.Compression.CompressionLevel]::Optimal
                }
                $entry = $archive.CreateEntry([string] $spec.Name, $compression)
                $entryStream = $entry.Open()
                try {
                    [byte[]] $bytes = $spec.Bytes
                    if ($bytes.Length -gt 0) {
                        $entryStream.Write($bytes, 0, $bytes.Length)
                    }
                } finally {
                    $entryStream.Dispose()
                }
            }
        } finally {
            $archive.Dispose()
        }
    } finally {
        $stream.Dispose()
    }
}

function Find-ZipSignature {
    param(
        [Parameter(Mandatory)] [byte[]] $Bytes,
        [Parameter(Mandatory)] [uint32] $Signature,
        [int] $Start = 0
    )

    [byte[]] $needle = [BitConverter]::GetBytes($Signature)
    for ($offset = $Start; $offset -le $Bytes.Length - $needle.Length; $offset++) {
        if ($Bytes[$offset] -eq $needle[0] -and
            $Bytes[$offset + 1] -eq $needle[1] -and
            $Bytes[$offset + 2] -eq $needle[2] -and
            $Bytes[$offset + 3] -eq $needle[3]) {
            return $offset
        }
    }
    throw ('ZIP signature 0x{0:X8} was not found.' -f $Signature)
}

function Set-EncryptedFlag {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $localHeader = Find-ZipSignature $bytes 0x04034b50
    $centralHeader = Find-ZipSignature $bytes 0x02014b50
    # General-purpose bit zero is the ZIP encryption marker. The payload does
    # not need secrets; this fixture exercises fail-closed metadata handling.
    $bytes[$localHeader + 6] = [byte] ($bytes[$localHeader + 6] -bor 1)
    $bytes[$centralHeader + 8] = [byte] ($bytes[$centralHeader + 8] -bor 1)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Set-LocalEncryptedFlag {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $localHeader = Find-ZipSignature $bytes 0x04034b50
    # The local header is parsed independently because libarchive can treat it
    # as authoritative once extraction starts.
    $bytes[$localHeader + 6] = [byte] ($bytes[$localHeader + 6] -bor 1)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Set-ZipCompressionMethods {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [uint16] $LocalMethod,
        [Parameter(Mandatory)] [uint16] $CentralMethod
    )

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $localHeader = Find-ZipSignature $bytes 0x04034b50
    $centralHeader = Find-ZipSignature $bytes 0x02014b50
    [byte[]] $encodedLocal = [BitConverter]::GetBytes($LocalMethod)
    [byte[]] $encodedCentral = [BitConverter]::GetBytes($CentralMethod)
    [Array]::Copy($encodedLocal, 0, $bytes, $localHeader + 8, 2)
    [Array]::Copy($encodedCentral, 0, $bytes, $centralHeader + 10, 2)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Set-OversizedCompressedExtent {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $eocd = Find-ZipSignature $bytes 0x06054b50
    $centralHeader = Find-ZipSignature $bytes 0x02014b50
    $localHeader = Find-ZipSignature $bytes 0x04034b50
    $centralOffset = [BitConverter]::ToUInt32($bytes, $eocd + 16)
    $nameLength = [BitConverter]::ToUInt16($bytes, $localHeader + 26)
    $extraLength = [BitConverter]::ToUInt16($bytes, $localHeader + 28)
    $dataOffset = $localHeader + 30 + $nameLength + $extraLength
    [uint32] $forgedSize = $centralOffset - $dataOffset + 1
    [byte[]] $encoded = [BitConverter]::GetBytes($forgedSize)
    # The claimed body crosses one byte into the already-bounded directory.
    [Array]::Copy($encoded, 0, $bytes, $centralHeader + 20, 4)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Set-OverlappingCompressedExtents {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $eocd = Find-ZipSignature $bytes 0x06054b50
    $centralOffset = [int] [BitConverter]::ToUInt32($bytes, $eocd + 16)
    $position = $centralOffset
    $entryCount = 0

    while ($position -lt $eocd) {
        if ([BitConverter]::ToUInt32($bytes, $position) -ne 0x02014b50) {
            throw 'Generated overlap fixture has an invalid central-directory record.'
        }

        $localOffset = [int] [BitConverter]::ToUInt32($bytes, $position + 42)
        $localNameLength = [BitConverter]::ToUInt16($bytes, $localOffset + 26)
        $localExtraLength = [BitConverter]::ToUInt16($bytes, $localOffset + 28)
        $dataOffset = $localOffset + 30 + $localNameLength + $localExtraLength
        [uint32] $forgedSize = $centralOffset - $dataOffset
        [byte[]] $encoded = [BitConverter]::GetBytes($forgedSize)
        # Every individual extent ends exactly at the directory, but the
        # overlapping aggregate exceeds the physical data region.
        [Array]::Copy($encoded, 0, $bytes, $position + 20, 4)

        $nameLength = [BitConverter]::ToUInt16($bytes, $position + 28)
        $extraLength = [BitConverter]::ToUInt16($bytes, $position + 30)
        $commentLength = [BitConverter]::ToUInt16($bytes, $position + 32)
        $position += 46 + $nameLength + $extraLength + $commentLength
        $entryCount++
    }

    if ($entryCount -lt 4) {
        throw 'Overlap fixture needs at least four central-directory entries.'
    }
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Set-EocdEntryCount {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [uint16] $Count
    )

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $eocd = Find-ZipSignature $bytes 0x06054b50
    [byte[]] $encoded = [BitConverter]::GetBytes($Count)
    # Entries on this disk and total entries must agree for a single-volume ZIP.
    $bytes[$eocd + 8] = $encoded[0]
    $bytes[$eocd + 9] = $encoded[1]
    $bytes[$eocd + 10] = $encoded[0]
    $bytes[$eocd + 11] = $encoded[1]
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Insert-Zip64Locator {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $eocd = Find-ZipSignature $bytes 0x06054b50
    [byte[]] $locator = New-Object byte[] 20
    [byte[]] $signature = [BitConverter]::GetBytes([uint32] 0x07064b50)
    [Array]::Copy($signature, 0, $locator, 0, 4)
    # A syntactically recognizable locator is enough to exercise the bypass:
    # libarchive consults it even when the ordinary EOCD has no ZIP64 sentinels.
    $locator[16] = 1

    [byte[]] $withLocator = New-Object byte[] ($bytes.Length + $locator.Length)
    [Array]::Copy($bytes, 0, $withLocator, 0, $eocd)
    [Array]::Copy($locator, 0, $withLocator, $eocd, $locator.Length)
    [Array]::Copy($bytes, $eocd, $withLocator, $eocd + $locator.Length, $bytes.Length - $eocd)
    [IO.File]::WriteAllBytes($Path, $withLocator)
}

function Insert-EocdGap {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $eocd = Find-ZipSignature $bytes 0x06054b50
    [byte[]] $withGap = New-Object byte[] ($bytes.Length + 4)
    [Array]::Copy($bytes, 0, $withGap, 0, $eocd)
    [Array]::Copy($bytes, $eocd, $withGap, $eocd + 4, $bytes.Length - $eocd)
    [IO.File]::WriteAllBytes($Path, $withGap)
}

function Add-FakeEocdComment {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $eocd = Find-ZipSignature $bytes 0x06054b50
    [byte[]] $comment = New-Object byte[] 30
    [byte[]] $signature = [BitConverter]::GetBytes([uint32] 0x06054b50)
    [Array]::Copy($signature, 0, $comment, 0, 4)
    [byte[]] $commentLength = [BitConverter]::GetBytes([uint16] $comment.Length)
    $bytes[$eocd + 20] = $commentLength[0]
    $bytes[$eocd + 21] = $commentLength[1]

    [byte[]] $withComment = New-Object byte[] ($bytes.Length + $comment.Length)
    [Array]::Copy($bytes, 0, $withComment, 0, $bytes.Length)
    [Array]::Copy($comment, 0, $withComment, $bytes.Length, $comment.Length)
    [IO.File]::WriteAllBytes($Path, $withComment)
}

function Set-CentralZip64SizeSentinel {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $centralHeader = Find-ZipSignature $bytes 0x02014b50
    for ($offset = 24; $offset -lt 28; $offset++) {
        $bytes[$centralHeader + $offset] = 0xFF
    }
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Set-UnderdeclaredUncompressedSize {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [uint32] $Size
    )

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $localHeader = Find-ZipSignature $bytes 0x04034b50
    $centralHeader = Find-ZipSignature $bytes 0x02014b50
    [byte[]] $encoded = [BitConverter]::GetBytes($Size)
    [Array]::Copy($encoded, 0, $bytes, $localHeader + 22, 4)
    [Array]::Copy($encoded, 0, $bytes, $centralHeader + 24, 4)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Set-UnixSymlinkMetadata {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $centralHeader = Find-ZipSignature $bytes 0x02014b50
    # Mark "made by Unix" and place 0120777 in the high word of the external
    # attributes. Libarchive then exposes this entry as AE_IFLNK.
    $bytes[$centralHeader + 4] = 20
    $bytes[$centralHeader + 5] = 3
    $bytes[$centralHeader + 38] = 0
    $bytes[$centralHeader + 39] = 0
    $bytes[$centralHeader + 40] = 0xFF
    $bytes[$centralHeader + 41] = 0xA1
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Corrupt-CompressedPayload {
    param([Parameter(Mandatory)] [string] $Path)

    [byte[]] $bytes = [IO.File]::ReadAllBytes($Path)
    $centralHeader = Find-ZipSignature $bytes 0x02014b50
    $compressedSize = [BitConverter]::ToUInt32($bytes, $centralHeader + 20)
    $localOffset = [BitConverter]::ToUInt32($bytes, $centralHeader + 42)
    $nameLength = [BitConverter]::ToUInt16($bytes, $localOffset + 26)
    $extraLength = [BitConverter]::ToUInt16($bytes, $localOffset + 28)
    $dataOffset = [int] ($localOffset + 30 + $nameLength + $extraLength)
    $corruptOffset = $dataOffset + [int] ($compressedSize / 2)
    $bytes[$corruptOffset] = [byte] ($bytes[$corruptOffset] -bxor 0xFF)
    [IO.File]::WriteAllBytes($Path, $bytes)
}

# Keep all generated and extracted data under one verified, disposable root.
$expectedFixtureRoot = [IO.Path]::GetFullPath((Join-Path $libraryRoot 'Data\ArchiveReaderTests'))
if ([IO.Path]::GetFullPath($fixtureRoot) -ne $expectedFixtureRoot) {
    throw 'Refusing to clean an unexpected fixture path.'
}

try {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
    New-Item -ItemType Directory -Path $fixtureRoot | Out-Null

    [byte[]] $hello = [Text.Encoding]::UTF8.GetBytes('hello')
    [byte[]] $binary = 0, 1, 2, 127, 128, 255
    [byte[]] $empty = @()
    New-TestZip (Join-Path $fixtureRoot 'valid.zip') @(
        @{ Name = 'folder/'; Bytes = $empty },
        @{ Name = 'hello.txt'; Bytes = $hello },
        @{ Name = 'folder/binary.bin'; Bytes = $binary; Compression = [IO.Compression.CompressionLevel]::NoCompression }
    )

    [byte[]] $bomb = [Text.Encoding]::ASCII.GetBytes(('A' * 1048576))
    New-TestZip (Join-Path $fixtureRoot 'bomb.zip') @(
        @{ Name = 'bomb.bin'; Bytes = $bomb }
    )
    New-TestZip (Join-Path $fixtureRoot 'component-bomb.zip') @(
        @{ Name = 'one/a/b/c/file.bin'; Bytes = $empty },
        @{ Name = 'two/a/b/c/file.bin'; Bytes = $empty },
        @{ Name = 'three/a/b/c/file.bin'; Bytes = $empty }
    )
    New-TestZip (Join-Path $fixtureRoot 'traversal.zip') @(
        @{ Name = 'a/../../escape.bin'; Bytes = $hello }
    )
    New-TestZip (Join-Path $fixtureRoot 'absolute.zip') @(
        @{ Name = '/absolute.txt'; Bytes = $hello }
    )
    New-TestZip (Join-Path $fixtureRoot 'ads.zip') @(
        @{ Name = 'file.txt:stream'; Bytes = $hello }
    )
    New-TestZip (Join-Path $fixtureRoot 'reserved.zip') @(
        @{ Name = 'folder/CON.txt'; Bytes = $hello }
    )
    New-TestZip (Join-Path $fixtureRoot 'directory-data.zip') @(
        @{ Name = 'not-empty/'; Bytes = $hello }
    )
    New-TestZip (Join-Path $fixtureRoot 'duplicate.zip') @(
        @{ Name = 'same.txt'; Bytes = $hello },
        @{ Name = 'same.txt'; Bytes = $binary }
    )
    New-TestZip (Join-Path $fixtureRoot 'case-duplicate.zip') @(
        @{ Name = 'Readme.txt'; Bytes = $hello },
        @{ Name = 'README.TXT'; Bytes = $binary }
    )
    New-TestZip (Join-Path $fixtureRoot 'file-parent.zip') @(
        @{ Name = 'node'; Bytes = $hello },
        @{ Name = 'node/child.txt'; Bytes = $binary }
    )
    New-TestZip (Join-Path $fixtureRoot 'file-parent-shadowed.zip') @(
        @{ Name = 'a'; Bytes = $hello },
        @{ Name = 'a!x'; Bytes = $hello },
        @{ Name = 'a/child.txt'; Bytes = $binary }
    )

    $symlinkPath = Join-Path $fixtureRoot 'symlink.zip'
    New-TestZip $symlinkPath @(
        @{ Name = 'link'; Bytes = [Text.Encoding]::UTF8.GetBytes('target.txt') }
    )
    Set-UnixSymlinkMetadata $symlinkPath

    $encryptedPath = Join-Path $fixtureRoot 'encrypted.zip'
    New-TestZip $encryptedPath @(
        @{ Name = 'secret.txt'; Bytes = $hello }
    )
    Set-EncryptedFlag $encryptedPath

    $localEncryptedPath = Join-Path $fixtureRoot 'local-encrypted.zip'
    New-TestZip $localEncryptedPath @(
        @{ Name = 'local-secret.txt'; Bytes = $hello }
    )
    Set-LocalEncryptedFlag $localEncryptedPath

    $unsupportedCompressionPath = Join-Path $fixtureRoot 'unsupported-compression.zip'
    New-TestZip $unsupportedCompressionPath @(
        @{ Name = 'unsupported.bin'; Bytes = $hello; Compression = [IO.Compression.CompressionLevel]::NoCompression }
    )
    # Method 12 (bzip2) is deliberately outside the bounded reader's small
    # stored/deflated allow-list; the payload is never opened.
    Set-ZipCompressionMethods $unsupportedCompressionPath 12 12

    $methodMismatchPath = Join-Path $fixtureRoot 'local-method-mismatch.zip'
    New-TestZip $methodMismatchPath @(
        @{ Name = 'mismatch.bin'; Bytes = $hello; Compression = [IO.Compression.CompressionLevel]::NoCompression }
    )
    # Both methods are individually supported, but disagreement between the
    # local and central headers must fail before libarchive sees the archive.
    Set-ZipCompressionMethods $methodMismatchPath 8 0

    $oversizedExtentPath = Join-Path $fixtureRoot 'oversized-compressed-extent.zip'
    New-TestZip $oversizedExtentPath @(
        @{ Name = 'extent.bin'; Bytes = $empty; Compression = [IO.Compression.CompressionLevel]::NoCompression }
    )
    Set-OversizedCompressedExtent $oversizedExtentPath

    $overlappingExtentsPath = Join-Path $fixtureRoot 'overlapping-compressed-extents.zip'
    New-TestZip $overlappingExtentsPath @(
        @{ Name = 'one.bin'; Bytes = $empty; Compression = [IO.Compression.CompressionLevel]::NoCompression },
        @{ Name = 'two.bin'; Bytes = $empty; Compression = [IO.Compression.CompressionLevel]::NoCompression },
        @{ Name = 'three.bin'; Bytes = $empty; Compression = [IO.Compression.CompressionLevel]::NoCompression },
        @{ Name = 'four.bin'; Bytes = $empty; Compression = [IO.Compression.CompressionLevel]::NoCompression }
    )
    Set-OverlappingCompressedExtents $overlappingExtentsPath

    New-TestZip (Join-Path $fixtureRoot 'empty.zip') @()
    $countMismatchPath = Join-Path $fixtureRoot 'central-count-mismatch.zip'
    New-TestZip $countMismatchPath @(
        @{ Name = 'only.txt'; Bytes = $hello }
    )
    Set-EocdEntryCount $countMismatchPath 2

    $zip64MarkerPath = Join-Path $fixtureRoot 'zip64-marker.zip'
    New-TestZip $zip64MarkerPath @(
        @{ Name = 'small.txt'; Bytes = $hello }
    )
    Set-EocdEntryCount $zip64MarkerPath 65535

    $zip64LocatorPath = Join-Path $fixtureRoot 'zip64-locator.zip'
    New-TestZip $zip64LocatorPath @(
        @{ Name = 'ordinary-fields.txt'; Bytes = $hello }
    )
    Insert-Zip64Locator $zip64LocatorPath

    $eocdGapPath = Join-Path $fixtureRoot 'eocd-gap.zip'
    New-TestZip $eocdGapPath @(
        @{ Name = 'decoy.txt'; Bytes = $hello }
    )
    Insert-EocdGap $eocdGapPath

    $fakeEocdCommentPath = Join-Path $fixtureRoot 'fake-eocd-comment.zip'
    New-TestZip $fakeEocdCommentPath @(
        @{ Name = 'real.txt'; Bytes = $hello }
    )
    Add-FakeEocdComment $fakeEocdCommentPath

    $zip64EntryPath = Join-Path $fixtureRoot 'zip64-entry.zip'
    New-TestZip $zip64EntryPath @(
        @{ Name = 'entry.txt'; Bytes = $hello }
    )
    Set-CentralZip64SizeSentinel $zip64EntryPath

    $underdeclaredPath = Join-Path $fixtureRoot 'underdeclared-size.zip'
    New-TestZip $underdeclaredPath @(
        @{ Name = 'larger-than-declared.txt'; Bytes = $hello }
    )
    Set-UnderdeclaredUncompressedSize $underdeclaredPath 1

    [IO.File]::WriteAllBytes(
        (Join-Path $fixtureRoot 'malformed.zip'),
        [byte[]] (0x50, 0x4B, 0x03, 0x04, 0x00, 0x01, 0x02)
    )

    [byte[]] $corruptBytes = New-Object byte[] 8192
    for ($index = 0; $index -lt $corruptBytes.Length; $index++) {
        $corruptBytes[$index] = [byte] ($index % 251)
    }
    $corruptPath = Join-Path $fixtureRoot 'corrupt-data.zip'
    New-TestZip $corruptPath @(
        @{ Name = 'bad.bin'; Bytes = $corruptBytes }
    )
    Corrupt-CompressedPayload $corruptPath

    # If traversal ever regresses, the crafted path still lands inside this
    # disposable fixture root rather than beside it in Library\Data.
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'sandbox') | Out-Null

    & $DfCli build $workspace --project 'ArchiveReaderTests.src' --toolchain $Toolchain --rebuild
    if ($LASTEXITCODE -ne 0) {
        throw "DataFlex build failed with exit code $LASTEXITCODE."
    }

    $savedPath = $env:PATH
    try {
        $env:PATH = $nativeRoot + [IO.Path]::PathSeparator + $savedPath
        $process = Start-Process -FilePath $testExe -WorkingDirectory $libraryRoot -Wait -PassThru `
            -NoNewWindow -ArgumentList @('--console', '--output', $resultsFile)
    } finally {
        $env:PATH = $savedPath
    }

    if (-not (Test-Path -LiteralPath $resultsFile)) {
        throw 'DFUnit did not produce its XML result file.'
    }

    [xml] $results = Get-Content -Raw -LiteralPath $resultsFile
    $testCases = @($results.SelectNodes('//testcase'))
    if ($testCases.Count -eq 0) {
        throw 'DFUnit did not discover any archive-reader tests.'
    }
    $assertionCount = ($testCases | Measure-Object -Property assertions -Sum).Sum
    $failureCount = @($results.SelectNodes('//failure')).Count
    $errorCount = @($results.SelectNodes('//error')).Count
    Write-Output ("DFUnit: {0} tests, {1} assertions, {2} failures, {3} errors." -f `
        $testCases.Count, $assertionCount, $failureCount, $errorCount)

    if ($process.ExitCode -ne 0) {
        throw "Archive reader tests failed with exit code $($process.ExitCode)."
    }
} finally {
    if (-not $KeepFixtures -and (Test-Path -LiteralPath $fixtureRoot)) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}
