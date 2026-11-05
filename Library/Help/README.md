# LibArchive for DataFlex - Documentation

DataFlex wrapper for the [libarchive](https://www.libarchive.org) DLL (`archive.dll`, 64 bit, libarchive 3.7.7). Read and write zip, 7zip, tar, cpio, ar, ISO 9660, mtree, WARC, RAR (read), CAB (read), LHA (read) and more, with gzip, bzip2, xz, lzma, lzip, zstd, lz4 and compress filters, encryption (writing and reading zip, reading encrypted 7zip and RAR), ACLs, extended attributes and sparse files.

There are three layers; use the one that fits:

| Layer | What | Where |
|---|---|---|
| Wrapper classes | Objects with properties and methods for everything the DLL offers (except callbacks) | [Classes](#classes) |
| External functions | All 432 exported functions of `archive.dll` as DataFlex `External_Function`, each documented | [External functions](#external-functions) |
| Constants | `ARCHIVE_*`, `AE_*` values | [Constants](Constants.md) |

## Getting started

1. Put `archive.dll` and the DLLs it needs (`zlib1.dll`, `bz2.dll`, `liblzma.dll`, `lz4.dll`, `zstd.dll`, `libcrypto-3-x64.dll`) in the `Programs` folder of your workspace. They are plain DLLs (no COM, no `regsvr32`). Only 64 bit DLLs are provided, build your program as 64 bit.
2. Add the library workspace (`Library/LibArchive.sws`) as a dependency of your workspace.
3. `Use` the classes you need:

```
Use cArchiveWriter.pkg      // create archives
Use cArchiveReader.pkg      // list / read / extract archives
Use cArchiveDiskReader.pkg  // read files and folders from disk as entries
Use cArchiveDiskWriter.pkg  // create files and folders from entries
Use cArchiveEntry.pkg       // entry metadata
Use cArchiveMatch.pkg       // include / exclude entries by pattern, time, owner
Use cFilesArchiver.pkg      // the original "files in, archive out" helper
```

4. **Save your source files as UTF-8 with BOM** when they contain non-ASCII string literals. libarchive receives strings as UTF-8; without the BOM the strings are not UTF-8 and libarchive can crash.

### Create a zip file

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

### List and extract an archive

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

### Errors

There are two conventions, depending on the kind of method:

- **One-call operations** (`ListEntries`, `ReadEntryData`, `InspectZipArchive`, `ExtractZipArchive` of `cArchiveReader`) return a `tArchiveOperationResult`: `bSuccess`, a stable `iErrorCode` (`C_ARCHIVE_RESULT_*`), `sErrorMessage` and counters. They never raise a DataFlex error and keep no state in the object.
- **Methods that mirror a libarchive function** return the libarchive result code (`ARCHIVE_OK`, `ARCHIVE_EOF`, `ARCHIVE_WARN`, `ARCHIVE_FAILED`, `ARCHIVE_FATAL`). `ARCHIVE_FAILED` and `ARCHIVE_FATAL` raise a DataFlex error by default; set `pbRaiseErrors` to False to handle the result codes yourself. See [cArchiveBase](Classes/cArchiveBase.md).

## Classes

| Class | Purpose | libarchive family |
|---|---|---|
| [cArchiveBase](Classes/cArchiveBase.md) | Base class: handle, error handling, archive and library information | `archive_*` |
| [cArchiveEntry](Classes/cArchiveEntry.md) | Metadata of one entry: names, times, mode, owner, links, file flags, ACLs, extended attributes, sparse map, digests | `archive_entry_*` |
| [cArchiveReader](Classes/cArchiveReader.md) | Read archives from file, memory, descriptor or `FILE`: formats, filters, options, passphrases, header iteration, data, extraction, list/extract helpers | `archive_read_*` |
| [cArchiveDiskReader](Classes/cArchiveDiskReader.md) | Walk files and folders on disk and read them as entries | `archive_read_disk_*` |
| [cArchiveWriter](Classes/cArchiveWriter.md) | Create archives in file, memory, descriptor or `FILE`: formats, filters, options, encryption, add helpers | `archive_write_*` |
| [cArchiveDiskWriter](Classes/cArchiveDiskWriter.md) | Create files, folders and links on disk from entries | `archive_write_disk_*` |
| [cArchiveMatch](Classes/cArchiveMatch.md) | Select entries by path pattern, time and owner | `archive_match_*` |
| [cArchiveLinkResolver](Classes/cArchiveLinkResolver.md) | Resolve hard links when writing | `archive_entry_linkresolver_*` |
| [cArchivePath](Classes/cArchivePath.md) | File system helpers (folder checks, listing, time stamps, absolute paths) as methods, no global functions | |
| [cFilesArchiver](Classes/cFilesArchiver.md) | The original helper: pack a list of files and folders into one archive | |

Callbacks (custom I/O, passphrase and lookup callbacks) are not available in the classes: DataFlex cannot create native function pointers. Use the file, memory and descriptor variants.

## External functions

All functions of `archive.dll`, declared in `Library/AppSrc/`. `Archive.h.pkg` holds the constants and includes the declaration files.

| File | Functions | Documentation |
|---|---|---|
| `ArchiveCommon.h.pkg` | version, error, format and filter information | [ArchiveCommon](ExternalFunctions/ArchiveCommon.md) |
| `ArchiveRead.h.pkg` | `archive_read_*` (formats, filters, open, header, data, options, extract) | [ArchiveRead](ExternalFunctions/ArchiveRead.md) |
| `ArchiveReadDisk.h.pkg` | `archive_read_disk_*` | [ArchiveReadDisk](ExternalFunctions/ArchiveReadDisk.md) |
| `ArchiveWrite.h.pkg` | `archive_write_*`, `archive_write_disk_*` | [ArchiveWrite](ExternalFunctions/ArchiveWrite.md) |
| `ArchiveEntry.h.pkg` | `archive_entry_*` | [ArchiveEntry](ExternalFunctions/ArchiveEntry.md) |
| `ArchiveMatch.h.pkg` | `archive_match_*`, `archive_utility_string_sort` | [ArchiveMatch](ExternalFunctions/ArchiveMatch.md) |

Every declaration has a comment with its meaning. Notes for DataFlex: names are not case sensitive, therefore `archive_read_open_FILE` and `archive_write_open_FILE` are declared as `archive_read_open_FILE_Ptr` and `archive_write_open_FILE_Ptr` (the DLL export names are unchanged); functions that need native callbacks are declared with `Pointer` parameters and can only be called with 0.

## More

- [Constants](Constants.md)
- [Notes: libarchive behavior on Windows](Notes.md) - things that differ from the libarchive documentation
- [Unit tests](Tests.md) - the DFUnit test application that tests every external function and every class
