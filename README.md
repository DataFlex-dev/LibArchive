# LibArchive for DataFlex

DataFlex 26 wrapper for [libarchive](https://github.com/libarchive/libarchive), with a 64-bit Windows demo and native binary set. The library can create several archive formats and provides a security-focused ZIP reader for inspecting and extracting untrusted uploads.

## Safe ZIP inspection and extraction

`cArchiveReader` also exposes two ZIP operations:

- `InspectZipArchive` validates the ZIP end record and bounded central directory, then reads entry metadata without extracting entry bodies.
- `ExtractZipArchive` always performs that preflight first, then reopens the ZIP and streams every regular file through application-enforced byte limits.

Before libarchive opens the file, the reader bounds the compressed archive and central-directory byte sizes, parses every central and local header, verifies the real record count, and bounds each compressed-data extent plus their aggregate. It then rejects encrypted or encryption-indeterminate entries, links and special files, non-empty directory bodies, unsafe paths, duplicate/colliding paths, excessive path-component work, and declared or actual uncompressed sizes above the configured limits. Extraction uses libarchive's platform-native disk writer with secure path and no-overwrite options. A failed extraction removes the files and directories it created; cleanup failure is reported separately.

```dataflex
Use cArchiveReader.pkg

Object oPackageArchiveReader is a cArchiveReader
    // Match this to the package server's upload policy.
    Set piMaxArchiveBytes to 104857600
    Set piMaxEntryUncompressedBytes to 104857600
    Set piMaxTotalUncompressedBytes to 104857600
    Set piMaxCentralDirectoryBytes to 8388608
    Set piMaxEntries to 10000
    Set piMaxPathComponents to 100000
    // Optional compatibility for a controlled producer that pads output blocks.
    Set pbAllowTrailingZeroPadding to True
End_Object

tArchiveOperationResult Result

// ExtractZipArchive runs preflight before it creates sNewDestination.
Get ExtractZipArchive of oPackageArchiveReader sUploadedZip sNewDestination to Result
If (not(Result.bSuccess)) Begin
    // Log Result.iErrorCode and Result.sErrorMessage internally. Do not expose
    // archive details to an unauthenticated package-manager client.
    Send AbortPackagePush "Package push failed."
End
```

All limits must be positive. `piMaxArchiveBytes` bounds the uploaded ZIP itself; `piMaxTotalUncompressedBytes` is the sum of regular-file sizes, while `piMaxEntryUncompressedBytes` bounds each file. `piMaxCentralDirectoryBytes` limits metadata allocation before libarchive runs, and `piMaxPathComponents` conservatively bounds implicit directory creation work across the archive. `pbAllowTrailingZeroPadding` defaults to `False`; when enabled it accepts only zero-filled bytes after a complete ZIP end record, and those bytes still count toward the archive-size limit.

## Security boundary

The package manager must still enforce its HTTP/request upload-size limit before persisting the upload. Set `piMaxArchiveBytes` to the same value so direct library callers get a second check. The server should also apply its normal request timeout and resource controls.

Keep the uploaded source file immutable for the whole operation. The extraction destination must not exist, and its parent must be an application-owned physical directory, not a symbolic link or junction, that untrusted users cannot modify. These requirements prevent another local process from swapping the source or redirecting an intermediate path between checks.

Only unfiltered, single-volume, non-ZIP64 seekable ZIP input with stored or deflated entries is accepted by this reader. The local and central headers must agree on the compression method, and encryption markers in either header are rejected. With the default 100 MiB policy, ZIP64 adds no useful package capacity and would require a more complex metadata gate. The existing archive writer retains its broader format support.

## Tests

The DFUnit suite `Demo\AppSrc\LibArchiveTests.src` holds the wrapper tests and the `ZipReader` fixture (the ZIP security checks, listed below). `Demo\Tests\RunArchiveReaderTests.ps1` generates the adversarial ZIP fixtures under `Demo\Programs\TestTemp\ArchiveReaderTests`, builds `LibArchiveTests.src`, runs the whole suite and deletes the fixtures:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Demo\Tests\RunArchiveReaderTests.ps1
```

The suite covers compressed and uncompressed ZIP bombs, overlapping compressed-data amplification, forged central counts, central-directory and path-component budgets, local/central-header disagreement, mixed-separator traversal, rooted/ADS/device paths, links, encryption, duplicate and file-parent collisions, ZIP64 rejection, malformed/corrupt input, binary output, no-overwrite behavior, failure cleanup, and portable nested-folder enumeration by `cFilesArchiver`.

## Platform and native dependencies

`cFilesArchiver`, `ArchivePath.pkg` and the ZIP inspection/extraction methods of `cArchiveReader` call no Windows API: they use DataFlex filesystem operations, libarchive's disk reader for timestamps and libarchive's disk writer for extraction, so the Windows-only `DateAndTime` submodule is no longer needed. The wrapper classes still declare `kernel32.dll` functions (`cArchiveEntry`, `cArchiveWriter`, and `cArchiveReader.DataToFile`/`OpenFiles`).

Native libarchive itself is still an external platform dependency. `Archive.h.pkg` currently names it `archive.dll`, and this repository only includes and tests the Windows x64 binary set. A non-Windows deployment must supply a compatible native libarchive build and adapt that library-name binding to the target DataFlex runtime's shared-library convention.

The seven 64-bit DLLs in `Demo\Programs` must be deployed beside the application executable. They are native libraries, not COM components, and must not be registered with `regsvr32`.

The bundled `archive.dll` currently reports libarchive 3.7.7. Treat native DLL updates as part of normal security maintenance: this DataFlex wrapper limits untrusted extraction, but it cannot patch vulnerabilities inside an old native parser.

| Component | Bundled version |
| --- | --- |
| archive.dll | 3.7.7 |
| libcrypto-3-x64.dll | 3.4.0.0 |
| liblzma.dll | 5.6.3 |
| zlib1.dll | 1.3.1.0 |
| zstd.dll | 1.5.6.0 |
| bz2.dll, lz4.dll | not recorded |

## Requirements

- DataFlex 26.0, x64
- The native DLL set from `Demo\Programs`
