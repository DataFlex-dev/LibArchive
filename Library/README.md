# LibArchive for DataFlex

![LibArchive](libarchive.png)

DataFlex wrapper for [libarchive](https://www.libarchive.org) (`archive.dll`, 64 bit, libarchive 3.7.7): read and write zip, 7zip, tar (ustar, pax, GNU), cpio, ar, ISO 9660, mtree and WARC archives, read RAR, CAB and LHA, with gzip, bzip2, xz, lzma, lzip, zstd, lz4 and compress filters, zip encryption, ACLs, extended attributes and sparse files.

## Install

```
df-cli package install "<your workspace>.sws" DataFlex-dev/LibArchive
```

The package contains the DataFlex sources and the 64 bit DLLs (`archive.dll`, `zlib1.dll`, `bz2.dll`, `liblzma.dll`, `lz4.dll`, `zstd.dll`, `libcrypto-3-x64.dll`). They are plain DLLs (no COM, no `regsvr32`): copy them to the `Programs` folder of your workspace, next to your 64 bit program. See `THIRD-PARTY-NOTICES.md` for their licenses.

## Use

```
Use cArchiveWriter.pkg      // create archives
Use cArchiveReader.pkg      // list, read and extract archives
Use cArchiveEntry.pkg       // entry metadata
```

Create a zip file:

```
Object oWriter is a cArchiveWriter
End_Object

Procedure CreateZip
    Integer iResult
    Send CreateWriter of oWriter
    Get SetFormatZip of oWriter to iResult
    Get OpenFile of oWriter "C:\Temp\backup.zip" to iResult
    Get AddText of oWriter "readme.txt" "Backup of the order data" to iResult
    Get AddFile of oWriter "C:\Data\orders.csv" "data\orders.csv" to iResult
    Get CloseWriter of oWriter to iResult
    Send FreeWriter of oWriter
End_Procedure
```

List and extract it:

```
Object oReader is a cArchiveReader
End_Object

Procedure ShowAndExtract
    tArchiveEntryInfo[] Entries
    tArchiveOperationResult Result
    Integer iEntry

    Get ListEntries of oReader "C:\Temp\backup.zip" (&Entries) to Result
    If (not (Result.bSuccess)) Begin
        Showln Result.sErrorMessage
        Procedure_Return
    End
    For iEntry from 0 to (SizeOfArray (Entries) - 1)
        Showln Entries[iEntry].sPathname Entries[iEntry].iSize
    Loop
    Get ExtractZipArchive of oReader "C:\Temp\backup.zip" "C:\Temp\restored" to Result
    If (not (Result.bSuccess)) Begin
        Showln Result.iErrorCode Result.sErrorMessage
    End
End_Procedure
```

**Save your source files as UTF-8 with BOM** when they contain non-ASCII string literals: libarchive receives strings as UTF-8.

## Error handling

There are two conventions, depending on the kind of method:

- **One-call operations** (`ListEntries`, `ReadEntryData`, `InspectZipArchive`, `ExtractZipArchive`) return a `tArchiveOperationResult`: `bSuccess`, a stable `iErrorCode` (`C_ARCHIVE_RESULT_*`), `sErrorMessage` and counters. They never raise a DataFlex error and keep no state in the object, so the outcome of one call cannot be mixed up with another (relevant in a pooled WebApp).
- **Methods that mirror a libarchive function** return the libarchive code (`ARCHIVE_OK`, `ARCHIVE_WARN`, `ARCHIVE_FAILED`, ...). With `pbRaiseErrors` (default `True`) a failure raises a DataFlex error; set it to `False` to check the code yourself, and read `piLastResult` / `psLastError` or override `OnError` for the details.

## Safe ZIP inspection and extraction

### Reader API

`cArchiveReader` has two public functions:

- `InspectZipArchive String sArchivePath Returns tArchiveOperationResult`
- `ExtractZipArchive String sArchivePath String sDestination Returns tArchiveOperationResult`

`ExtractZipArchive` includes the inspection pass; callers do not need to invoke both. The result contains success, a stable application result code, an internal diagnostic, archive/central-directory byte sizes, entry/path-component counts, declared uncompressed bytes, and bytes actually written.

Configure positive values for:

- `piMaxEntryUncompressedBytes`
- `piMaxTotalUncompressedBytes`
- `piMaxArchiveBytes`
- `piMaxCentralDirectoryBytes` (up to 64 MiB)
- `piMaxEntries` (up to 65,534)
- `piMaxPathLength` (1-259)
- `piMaxPathComponents`
- `piReadBlockSize` (4 KiB-1 MiB)
- `pbAllowTrailingZeroPadding` (default `False`)

Defaults are 100 MiB for the archive, each entry, and the extracted total; 8 MiB of central-directory metadata; 10,000 entries; 240 relative-path characters; 100,000 aggregate path components; and 64 KiB read blocks.

The detailed result message is intended for trusted logs. Server endpoints should map every failure to the same generic push error.

### Required caller guarantees

- Enforce the compressed upload limit before parsing.
- Keep the source file immutable until extraction finishes.
- Supply a destination that does not exist.
- Use an existing, application-owned physical destination parent, not a symbolic link or junction, that untrusted processes cannot modify.
- Keep the native libarchive DLL and its dependencies current.

The reader accepts only plain, single-volume, non-ZIP64 seekable ZIP files whose entries use stored or deflate compression. It requires matching local and central compression metadata, rejects encryption markers in either header, and validates the end record, every bounded central-directory record, and each compressed-data extent before libarchive can allocate or rescan seekable data. End-record validation requires physical EOF by default. Callers that control their ZIP producer may set `pbAllowTrailingZeroPadding` to accept only zero-filled writer block padding; arbitrary trailing content remains invalid and still counts toward `piMaxArchiveBytes`. The reader deliberately avoids `archive_read_extract`; application-owned block reads allow actual decompressed bytes to be checked before libarchive's platform-native disk writer receives them.

## What is in the package

| Layer | Contents |
|---|---|
| Classes | `cArchiveBase`, `cArchiveEntry`, `cArchiveReader`, `cArchiveDiskReader`, `cArchiveWriter`, `cArchiveDiskWriter`, `cArchiveMatch`, `cArchiveLinkResolver`, `cArchivePath` (file system helpers) and the original `cFilesArchiver` |
| External functions | All 432 functions of `archive.dll`, each documented, in `Archive*.h.pkg` |
| Constants | `ARCHIVE_*` and `AE_*` in `Archive.h.pkg` |

Callbacks (custom I/O, passphrase and lookup callbacks) cannot be used from DataFlex, because DataFlex cannot create native function pointers; use the file, memory and descriptor variants.

## Documentation

Full documentation of every class, method, external function and constant, notes on libarchive behavior on Windows, and the unit tests: [Help](https://github.com/DataFlex-dev/LibArchive/tree/HEAD/Help).

## Platform boundary

No library source declares a Windows API function. File and folder handling uses DataFlex file I/O (`DIR:` listing, binary channels, `EraseFile`), libarchive's disk reader (file type, size, time stamps) and disk writer (folders, extraction, `DataToFile`); the current time also comes from libarchive and the path separator from `SysConf (SYSCONF_DIR_SEPARATOR)`. The Windows-only `DateAndTime` submodule is not needed. The test suite still declares `kernel32.dll` and `ucrtbase.dll` functions and is Windows-only.

What still ties the library to Windows (not verified on another operating system):

- `Archive.h.pkg` names the native library `archive.dll`; a build for another operating system needs the library name that DataFlex runtime expects.
- The `*_w` libarchive functions (file names, patterns, wide entry names) are passed UTF-16 `WString` values. On Linux `wchar_t` has 4 bytes, so a Linux port needs a different way to pass them: the narrow variants are obsolete in this library and are not wrapped.
- `cArchiveEntry.AnsiPointerText` (ACL user and group names) uses `AnsiToUtf8` of DataFlex's `CharTranslate.pkg`, which declares `kernel32.dll` itself.
- File descriptors and `FILE` pointers (`OpenFd`, `OpenFilePtr`) and the layout behind `cArchiveEntry.StatPointer` come from the C runtime of the process.
- `IsSafeArchivePath` treats `\` as a path separator and rejects `:`, and `cArchiveWriter` converts `\` in archive path names to `/`. Both are right for Windows archives but change valid names on Linux.

## Requirements

| Product | Version |
|---|---|
| DataFlex | 26.0 (64 bit) |
| libarchive | 3.7.7 (included) |
