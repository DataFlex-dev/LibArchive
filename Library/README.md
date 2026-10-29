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
    Integer iEntry iResult

    Get ListEntries of oReader "C:\Temp\backup.zip" to Entries
    For iEntry from 0 to (SizeOfArray (Entries) - 1)
        Showln Entries[iEntry].sPathname Entries[iEntry].iSize
    Loop
    Get ExtractAll of oReader "C:\Temp\backup.zip" "C:\Temp\restored" ARCHIVE_EXTRACT_TIME to iResult
End_Procedure
```

**Save your source files as UTF-8 with BOM** when they contain non-ASCII string literals: libarchive receives strings as UTF-8.

## What is in the package

| Layer | Contents |
|---|---|
| Classes | `cArchiveBase`, `cArchiveEntry`, `cArchiveReader`, `cArchiveDiskReader`, `cArchiveWriter`, `cArchiveDiskWriter`, `cArchiveMatch`, `cArchiveLinkResolver`, and the original `cFilesArchiver` |
| External functions | All 432 functions of `archive.dll`, each documented, in `Archive*.h.pkg` |
| Constants | `ARCHIVE_*` and `AE_*` in `Archive.h.pkg` |

Callbacks (custom I/O, passphrase and lookup callbacks) cannot be used from DataFlex, because DataFlex cannot create native function pointers; use the file, memory and descriptor variants.

## Documentation

Full documentation of every class, method, external function and constant, notes on libarchive behavior on Windows, and the unit tests: [Help](https://github.com/DataFlex-dev/LibArchive/tree/HEAD/Help).

## Requirements

| Product | Version |
|---|---|
| DataFlex | 26.0 (64 bit) |
| libarchive | 3.7.7 (included) |
