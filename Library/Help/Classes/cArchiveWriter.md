# cArchiveWriter

Wrapper around the archive writer of libarchive (`archive_write_*`). It creates archives in a file, in memory, on a C runtime file descriptor or on a C runtime `FILE` pointer: zip, 7zip, tar (ustar, pax, GNU, v7), cpio, ar, ISO 9660, mtree, shar, WARC and raw output, optionally through compression filters (gzip, bzip2, xz, zstd, lz4, lzma, lzip, compress, uuencode, base64 or an external program).

Package: `Library/AppSrc/cArchiveWriter.pkg` (`Use cArchiveWriter.pkg`)

Superclass: [`cArchiveBase`](cArchiveBase.md) (handle property `ppArchive`, result/error handling, version information).

Related: [`cArchiveEntry`](cArchiveEntry.md) (entry metadata for `WriteHeader`), [`cArchiveDiskWriter`](cArchiveDiskWriter.md) (creates files on disk).

## Contents

- [Overview](#overview)
- [Usage](#usage)
- [Properties](#properties)
- [Methods](#methods)
- [Compression, encryption and options](#compression-encryption-and-options)
- [Unicode names](#unicode-names)
- [Callbacks are not available](#callbacks-are-not-available)
- [Error handling](#error-handling)
- [Functions of ArchiveWrite.h.pkg that are not reachable](#functions-of-archivewriteh-pkg-that-are-not-reachable)

## Overview

The life cycle of a writer is always the same:

1. `CreateWriter` - allocates the libarchive handle (`archive_write_new`).
2. Select the **format** (`SetFormatZip`, `SetFormatPax`, `SetFormat`, `SetFormatByName`, `SetFormatFilterByExtension`, ...) and the **filters** (`AddFilterGzip`, ...). Set options (`SetOption`, `SetPassphrase`, `peZipCompression`, `piBytesPerBlock`, ...).
3. **Open** the output: `OpenFile`, `OpenMemory`, `OpenFd` or `OpenFilePtr`. Format, filters and options must be set before.
4. Write the **entries**: the convenience methods `AddFile`, `AddData`, `AddText`, `AddDirectory`, `AddSymlink`, `AddFolderTree`, or the low level `WriteHeader` + `WriteData` / `WriteString` / `WriteDataPointer` + `FinishEntry`.
5. `CloseWriter` - writes the end of the archive and closes the output.
6. `FreeWriter` - releases the handle. (`FreeWriter` also closes the archive when you did not call `CloseWriter`, but then a failure of the final write is not reported. The object destructor frees the writer as well.)

For the common case there is the one call helper `CreateArchive`.

All methods return the libarchive result code (`ARCHIVE_OK` = 0, `ARCHIVE_WARN` = -20, `ARCHIVE_FAILED` = -25, `ARCHIVE_FATAL` = -30) unless the table says otherwise. They are functions, call them with `Get`.

## Usage

### A zip file with text, a file from disk and a folder

```
Use cArchiveWriter.pkg

Object oWriter is a cArchiveWriter
End_Object

Procedure CreateZip
    Integer iResult

    Send CreateWriter of oWriter
    Get SetFormatZip of oWriter to iResult
    Get OpenFile of oWriter "C:\Temp\backup.zip" to iResult
    Get AddText of oWriter "readme.txt" "Backup of the order data" to iResult
    Get AddFile of oWriter "C:\Data\orders.csv" "data\orders.csv" to iResult
    Get AddFolderTree of oWriter "C:\Data\Images" "images" to iResult
    Get CloseWriter of oWriter to iResult
    Send FreeWriter of oWriter
End_Procedure
```

### tar.gz (the format and the compression from the file extension)

```
Send CreateWriter of oWriter
Get SetFormatFilterByExtension of oWriter "C:\Temp\backup.tar.gz" to iResult    // pax or ustar tar + gzip
Get OpenFile of oWriter "C:\Temp\backup.tar.gz" to iResult
Get AddFolderTree of oWriter "C:\Data" "data" to iResult
Get CloseWriter of oWriter to iResult
Send FreeWriter of oWriter
```

or explicitly, here a tar.xz:

```
Send CreateWriter of oWriter
Get SetFormatPax of oWriter to iResult
Get AddFilterXz of oWriter to iResult
Get SetFilterOption of oWriter "xz" "compression-level" "9" to iResult
Get OpenFile of oWriter "C:\Temp\backup.tar.xz" to iResult
...
```

### 7-Zip

```
Send CreateWriter of oWriter
Get SetFormat7zip of oWriter to iResult
Get OpenFile of oWriter "C:\Temp\backup.7z" to iResult
Get AddFile of oWriter "C:\Data\orders.csv" "" to iResult        // archive name = file name without path
Get CloseWriter of oWriter to iResult
Send FreeWriter of oWriter
```

### Archive in memory

```
UChar[] ucArchive

Send CreateWriter of oWriter
Get SetFormatZip of oWriter to iResult
Get OpenMemory of oWriter 1048576 to iResult                    // 1 MB output buffer
Get AddText of oWriter "hello.txt" "Hello" to iResult
Get CloseWriter of oWriter to iResult
Get GetOutput of oWriter (&ucArchive) to iSize                  // ucArchive holds the zip, iSize its length
Send FreeWriter of oWriter                                      // the output stays available after FreeWriter
```

The buffer of `OpenMemory` has a fixed size: libarchive fails when the archive does not fit. Allocate more than the sum of the data plus the format overhead (tar output is a multiple of 512 bytes, and of `piBytesInLastBlock` when that is set).

### One call

```
String[] sFiles
Integer iResult

Move "C:\Data\orders.csv" to sFiles[0]
Move "C:\Data\Images" to sFiles[1]                              // a folder is added recursively
Get CreateArchive of oWriter "C:\Temp\backup.tar.gz" sFiles ARCHIVE_FORMAT_TAR_PAX_RESTRICTED ARCHIVE_FILTER_GZIP to iResult
```

### Entries with all metadata

```
Handle hoEntry
Pointer pEntry
Void_Type iVoid

Get Create (RefClass (cArchiveEntry)) to hoEntry
Send CreateEntry of hoEntry
Set psPathname of hoEntry to "docs/report.txt"
Get ppEntry of hoEntry to pEntry
Move (archive_entry_set_filetype (pEntry, AE_IFREG)) to iVoid
Move (archive_entry_set_perm (pEntry, 420)) to iVoid
Move (archive_entry_set_size (pEntry, SizeOfString (sText))) to iVoid
Move (archive_entry_set_mtime (pEntry, 1700000000, 0)) to iVoid
Get WriteHeader of oWriter hoEntry to iResult
Get WriteString of oWriter sText to iWritten
Get FinishEntry of oWriter to iResult
Send Destroy of hoEntry
```

### Encrypted zip

```
Send CreateWriter of oWriter
Get SetFormatZip of oWriter to iResult
Get SetOption of oWriter "zip" "encryption" "aes256" to iResult
Get SetPassphrase of oWriter "secret" to iResult
Get OpenFile of oWriter "C:\Temp\secret.zip" to iResult
Get AddText of oWriter "secret.txt" "Top secret" to iResult
Get CloseWriter of oWriter to iResult
Send FreeWriter of oWriter
```

## Properties

Properties of the class itself. Properties of the base class (`ppArchive`, `pbRaiseErrors`, `piLastResult`, `psLastError`, `piErrorNumber`, `psErrorString`, `peFormat`, `psFormatName`, `piFileCount`, `piFilterCount`, `psVersionString`, ...) are described in [`cArchiveBase`](cArchiveBase.md).

| Property | Type | R/W | libarchive function | Description |
|---|---|---|---|---|
| `piBytesPerBlock` | Integer | r/w | `archive_write_get_bytes_per_block` / `archive_write_set_bytes_per_block` | Block size of the output, default 10240. Set it before the archive is opened. 0 without a writer. |
| `piBytesInLastBlock` | Integer | r/w | `archive_write_get_bytes_in_last_block` / `archive_write_set_bytes_in_last_block` | Size the last block is padded to; 1 switches the padding off. The default is -1 (not set, the format decides: ustar/pax do not pad). Set it before the archive is opened. |
| `peZipCompression` | Integer | r/w | `archive_write_zip_set_compression_deflate` / `archive_write_zip_set_compression_store` | `ARCHIVE_ZIP_COMPRESSION_DEFLATE` (0, default) or `ARCHIVE_ZIP_COMPRESSION_STORE` (1). Setting it needs the zip format to be selected (otherwise `ARCHIVE_FATAL` is reported and the value stays). |
| `piFilePermission` | Integer | r/w | - | Permission bits (decimal, 420 = octal 0644) of the files the `Add...` methods create. Default 420. |
| `piDirectoryPermission` | Integer | r/w | - | Permission bits of the directories `AddDirectory` / `AddFolderTree` create. Default 493 (octal 0755). |
| `pbUtf8HeaderCharset` | Boolean | r/w | `archive_write_set_format_option` (`hdrcharset=UTF-8`) | Default True: the option `hdrcharset=UTF-8` is set for every format right after the format is chosen (formats that do not know it ignore it). Set it to False **before** choosing the format to keep libarchive's ANSI code page handling. See [Unicode names](#unicode-names). |
| `pucOutput` | UChar[] | r | - | The archive bytes written with `OpenMemory`, filled when the writer is freed. Use `OutputBytes` / `GetOutput`, which also work before. |
| `ppMemoryBuffer`, `ppMemoryUsed`, `piZipCompressionValue` | Pointer, Pointer, Integer | internal | - | Native memory of `OpenMemory` and the remembered zip compression. |

Constants defined by the package:

| Constant | Value |
|---|---|
| `ARCHIVE_ZIP_COMPRESSION_DEFLATE` | 0 |
| `ARCHIVE_ZIP_COMPRESSION_STORE` | 1 |

## Methods

### Writer

| Signature | Description | libarchive function |
|---|---|---|
| `Procedure CreateWriter` | Creates a new writer; a previous writer is freed first. | `archive_write_new` |
| `Function CloseWriter Returns Integer` | Finishes the archive and closes the output. | `archive_write_close` |
| `Procedure FreeWriter` | Frees the writer (closes it when needed). Safe without a writer. | `archive_write_free` (through `archive_free`) |
| `Procedure FreeHandle` | Override of the `cArchiveBase` method that `FreeWriter`, `CreateWriter` and the destructor call: frees the handle, then copies the `OpenMemory` output into `pucOutput` and releases the native buffer. Normally use `FreeWriter`. | `archive_free` |
| `Function FailWriter Returns Integer` | Marks the archive as failed so that `FreeWriter` does not finish it cleanly; use it to abandon a partial archive (with a file output libarchive then keeps the file open until the process ends, prefer `OpenMemory` or close normally). Always returns `ARCHIVE_FATAL` (`archive_write_fail` itself returns the internal state value 32768). | `archive_write_fail` |
| `Function SetSkipFile BigInt iDevice BigInt iInode Returns Integer` | Device and inode of a file that must not be archived (the archive itself); `WriteHeader` refuses an entry with these numbers (`ARCHIVE_FAILED`). | `archive_write_set_skip_file` |
| `Function RequireHandle Returns Pointer` | The handle; raises an error and returns 0 when there is no writer. Used by all methods. | - |
| `Function SetZipCompressionDeflate Returns Integer` | Entries are deflated (default). Zip format only. | `archive_write_zip_set_compression_deflate` |
| `Function SetZipCompressionStore Returns Integer` | Entries are stored without compression. Zip format only. | `archive_write_zip_set_compression_store` |

### Format

Select exactly one format before opening the archive. All return `ARCHIVE_OK` or `ARCHIVE_FATAL`.

| Signature | Format | libarchive function |
|---|---|---|
| `Function SetFormat Integer eFormatCode Returns Integer` | By code, an `ARCHIVE_FORMAT_*` constant (tested: `ARCHIVE_FORMAT_ZIP`, `_7ZIP`, `_TAR_USTAR`, `_TAR_GNUTAR`, `_TAR_PAX_RESTRICTED`, `_CPIO`, `_ISO9660`). `ARCHIVE_FORMAT_TAR` selects ustar. Not every constant is accepted (the `AR` codes and `ARCHIVE_FORMAT_CPIO_SVR4_CRC` give `ARCHIVE_FATAL`: use `SetFormatArBsd` / `SetFormatArSvr4` / `SetFormatCpioNewc`). | `archive_write_set_format` |
| `Function SetFormatByName String sName Returns Integer` | By name: `7zip`, `ar`, `arbsd`, `argnu`, `arsvr4`, `cd9660`, `cpio`, `gnutar`, `iso9660`, `mtree`, `mtree-classic`, `newc`, `odc`, `pax`, `paxr`, `posix`, `pwb`, `raw`, `rpax`, `shar`, `shardump`, `ustar`, `v7tar`, `warc`, `xar`, `zip`. | `archive_write_set_format_by_name` |
| `Function SetFormatFilterByExtension String sFileName Returns Integer` | Format and filter from the extension of a file name: `.zip`, `.jar`, `.7z`, `.tar`, `.tgz`, `.tar.gz`, `.tar.bz2`, `.tar.xz`, `.cpio`, `.iso`, `.a`, `.ar`. `ARCHIVE_FATAL` for other extensions. | `archive_write_set_format_filter_by_ext` |
| `Function SetFormatFilterByExtensionDefault String sFileName String sDefaultExt Returns Integer` | Like above; `sDefaultExt` (for example `.tar.gz`) is used when `sFileName` has no known extension. | `archive_write_set_format_filter_by_ext_def` |
| `Function SetFormat7zip Returns Integer` | 7-Zip | `archive_write_set_format_7zip` |
| `Function SetFormatArBsd Returns Integer` | ar, BSD variant | `archive_write_set_format_ar_bsd` |
| `Function SetFormatArSvr4 Returns Integer` | ar, SVR4/GNU variant | `archive_write_set_format_ar_svr4` |
| `Function SetFormatCpio Returns Integer` | cpio (POSIX, same as odc) | `archive_write_set_format_cpio` |
| `Function SetFormatCpioBin Returns Integer` | old binary cpio | `archive_write_set_format_cpio_bin` |
| `Function SetFormatCpioNewc Returns Integer` | SVR4 "newc" cpio | `archive_write_set_format_cpio_newc` |
| `Function SetFormatCpioOdc Returns Integer` | old character cpio | `archive_write_set_format_cpio_odc` |
| `Function SetFormatCpioPwb Returns Integer` | PWB cpio | `archive_write_set_format_cpio_pwb` |
| `Function SetFormatGnuTar Returns Integer` | GNU tar | `archive_write_set_format_gnutar` |
| `Function SetFormatIso9660 Returns Integer` | ISO 9660 image (Rock Ridge names by default) | `archive_write_set_format_iso9660` |
| `Function SetFormatMtree Returns Integer` | mtree manifest | `archive_write_set_format_mtree` |
| `Function SetFormatMtreeClassic Returns Integer` | classic mtree manifest | `archive_write_set_format_mtree_classic` |
| `Function SetFormatPax Returns Integer` | pax (POSIX.1-2001 tar with extended headers; the best tar format for Unicode names and large files) | `archive_write_set_format_pax` |
| `Function SetFormatPaxRestricted Returns Integer` | pax that only uses extended headers when needed | `archive_write_set_format_pax_restricted` |
| `Function SetFormatRaw Returns Integer` | raw data of a single entry, no archive structure | `archive_write_set_format_raw` |
| `Function SetFormatShar Returns Integer` | shell archive | `archive_write_set_format_shar` |
| `Function SetFormatSharDump Returns Integer` | shell archive, uuencoded data | `archive_write_set_format_shar_dump` |
| `Function SetFormatUstar Returns Integer` | POSIX.1-1988 ustar tar | `archive_write_set_format_ustar` |
| `Function SetFormatV7Tar Returns Integer` | old Version 7 tar | `archive_write_set_format_v7tar` |
| `Function SetFormatWarc Returns Integer` | Web ARChive (WARC) | `archive_write_set_format_warc` |
| `Function SetFormatXar Returns Integer` | XAR. **The archive.dll 3.7.7 used for the tests is built without XAR support**: the function returns `ARCHIVE_WARN` ("Xar not supported on this platform") and every further write fails. | `archive_write_set_format_xar` |
| `Function SetFormatZip Returns Integer` | ZIP (see [Unicode names](#unicode-names)) | `archive_write_set_format_zip` |

The raw format holds a single entry only (a second `WriteHeader` returns `ARCHIVE_FATAL`), mtree stores metadata only, `shar` and `raw` cannot be read back by libarchive.

### Filters

Filters are applied in the order in which they are added; add them before the archive is opened. All return `ARCHIVE_OK` (or a failure code).

| Signature | Description | libarchive function |
|---|---|---|
| `Function AddFilter Integer eFilterCode Returns Integer` | By code, an `ARCHIVE_FILTER_*` constant. | `archive_write_add_filter` |
| `Function AddFilterByName String sName Returns Integer` | By name: `gzip`, `bzip2`, `xz`, `zstd`, `lz4`, `lzma`, `lzip`, `compress`, `uuencode`, `b64encode`, `lzop`, `lrzip`, `grzip`. `ARCHIVE_FATAL` for unknown names and for `none` (use `AddFilterNone`). | `archive_write_add_filter_by_name` |
| `Function AddFilterGzip Returns Integer` | gzip | `archive_write_add_filter_gzip` |
| `Function AddFilterBzip2 Returns Integer` | bzip2 | `archive_write_add_filter_bzip2` |
| `Function AddFilterXz Returns Integer` | xz | `archive_write_add_filter_xz` |
| `Function AddFilterZstd Returns Integer` | Zstandard | `archive_write_add_filter_zstd` |
| `Function AddFilterLz4 Returns Integer` | lz4 | `archive_write_add_filter_lz4` |
| `Function AddFilterLzma Returns Integer` | lzma | `archive_write_add_filter_lzma` |
| `Function AddFilterLzip Returns Integer` | lzip | `archive_write_add_filter_lzip` |
| `Function AddFilterCompress Returns Integer` | Unix compress (.Z) | `archive_write_add_filter_compress` |
| `Function AddFilterUuencode Returns Integer` | uuencode | `archive_write_add_filter_uuencode` |
| `Function AddFilterB64Encode Returns Integer` | base64 | `archive_write_add_filter_b64encode` |
| `Function AddFilterLzop Returns Integer` | lzop, needs the external `lzop` program when the archive is opened | `archive_write_add_filter_lzop` |
| `Function AddFilterLrzip Returns Integer` | lrzip, needs the external `lrzip` program | `archive_write_add_filter_lrzip` |
| `Function AddFilterGrzip Returns Integer` | grzip, needs the external `grzip` program | `archive_write_add_filter_grzip` |
| `Function AddFilterNone Returns Integer` | pass-through, adds nothing to the pipeline | `archive_write_add_filter_none` |
| `Function AddFilterProgram String sCommand Returns Integer` | An external program as filter: it reads the data on its standard input and writes the result to its standard output, for example `AddFilterProgram 'findstr "^"'`. | `archive_write_add_filter_program` |

### Options and encryption

`sModule` is the name of the format or filter the option belongs to (`zip`, `7zip`, `gzip`, `xz`, ...); an empty `sModule` matches any module. An empty `sValue` passes NULL, which switches a boolean option off. Unknown options and invalid values give `ARCHIVE_FAILED`. See [Compression, encryption and options](#compression-encryption-and-options).

| Signature | Description | libarchive function |
|---|---|---|
| `Function SetOption String sModule String sOption String sValue Returns Integer` | Option for the format and the filters. | `archive_write_set_option` |
| `Function SetFormatOption String sModule String sOption String sValue Returns Integer` | Option for the format only. | `archive_write_set_format_option` |
| `Function SetFilterOption String sModule String sOption String sValue Returns Integer` | Option for the filters only. | `archive_write_set_filter_option` |
| `Function SetOptions String sOptions Returns Integer` | Several options in one string, `"zip:compression=store,gzip:compression-level=9"`. | `archive_write_set_options` |
| `Function SetPassphrase String sPassphrase Returns Integer` | Passphrase for encryption; select the encryption with `SetOption "zip" "encryption" ...` first. An empty passphrase is refused. | `archive_write_set_passphrase` |

### Open

Open the archive exactly once per writer, after format, filters and options are set.

| Signature | Description | libarchive function |
|---|---|---|
| `Function OpenFile String sFileName Returns Integer` | Creates the file; the name may contain any Unicode character (passed as wide string). | `archive_write_open_filename_w` |
| `Function OpenFileAnsi String sFileName Returns Integer` | Creates the file with the narrow function: the name is interpreted in the ANSI code page of the system. Prefer `OpenFile`. | `archive_write_open_filename` |
| `Function OpenMemory Integer iBufferSize Returns Integer` | Writes into an internal native memory buffer of `iBufferSize` bytes. A second call for the same writer and a size of 0 give `ARCHIVE_FAILED`. | `archive_write_open_memory` |
| `Function OpenFd Integer iFileDescriptor Returns Integer` | Writes to an open C runtime file descriptor (`_open`/`_wopen` of the same UCRT as archive.dll). You close it after `FreeWriter`. | `archive_write_open_fd` |
| `Function OpenFilePtr Pointer pFile Returns Integer` | Writes to an open C runtime `FILE *` (`_wfopen`/`fopen` of the same UCRT). You close it after `FreeWriter`. | `archive_write_open_FILE` (DataFlex name `archive_write_open_FILE_Ptr`) |

### Output of OpenMemory

| Signature | Description |
|---|---|
| `Function OutputBytes Returns UChar[]` | The bytes written so far; after `CloseWriter` the complete archive. Also valid after `FreeWriter` (and then the final archive, also when `CloseWriter` was not sent). Empty when `OpenMemory` was not used. |
| `Function GetOutput UChar[] ByRef ucOutput Returns BigInt` | Like `OutputBytes`: `ucOutput` receives the bytes, the result is their number. |
| `Function OutputSize Returns BigInt` | Number of bytes (the `size_t` counter of `archive_write_open_memory`). |

### Entries and data

| Signature | Description | libarchive function |
|---|---|---|
| `Function WriteHeader Handle hoEntry Returns Integer` | Writes the header of the entry of a `cArchiveEntry` object (`ppEntry of hoEntry`). The entry is not changed or freed. `ARCHIVE_FAILED` when the object has no entry. | `archive_write_header` |
| `Function WriteHeaderPointer Pointer pEntry Returns Integer` | Same for a raw `archive_entry *`. | `archive_write_header` |
| `Function WriteData UChar[] ucData Returns BigInt` | Data of the current entry. Returns the bytes written; a negative result is an error code. libarchive writes no more than the size in the header, a shorter write than requested is reported as `ARCHIVE_FAILED`. | `archive_write_data` |
| `Function WriteString String sData Returns BigInt` | The bytes of a string (UTF-8) as data; the number of bytes is `SizeOfString (sData)`. | `archive_write_data` |
| `Function WriteDataPointer Pointer pData BigInt iSize Returns BigInt` | `iSize` bytes at `pData` as data. | `archive_write_data` |
| `Function FinishEntry Returns Integer` | Finishes the entry (pads with zero bytes when less data than the header size was written). Done automatically by the next header and by `CloseWriter`. | `archive_write_finish_entry` |

### Convenience methods

They write header, data and finish the entry. Path names are UTF-8; `\` is converted to `/`. They return `ARCHIVE_OK` or the first failure.

| Signature | Description |
|---|---|
| `Function AddFile String sDiskFileName String sArchivePathName Returns Integer` | Adds a file from disk: size and last write time (with nanoseconds) come from the file, permission `piFilePermission`, type regular file. The content is read in chunks of 1 MB through a binary channel. An empty `sArchivePathName` uses the file name without path. `ARCHIVE_FAILED` ("The file does not exist") for a missing file. |
| `Function AddData String sArchivePathName UChar[] ucData Returns Integer` | A file with the bytes of `ucData`, time stamp now, permission `piFilePermission`. |
| `Function AddText String sArchivePathName String sText Returns Integer` | A file with the text as UTF-8, time stamp now. |
| `Function AddDirectory String sArchivePathName Returns Integer` | A directory entry (permission `piDirectoryPermission`, time stamp now); the trailing `/` is added when missing. |
| `Function AddSymlink String sArchivePathName String sTarget Returns Integer` | A symbolic link entry pointing to `sTarget` (permission 0777). |
| `Function AddFolderTree String sFolder String sPrefix Returns Integer` | Adds a folder recursively: a directory entry for every sub folder (also empty ones) and `AddFile` for every file. The path names are `sPrefix/relative path`; a non empty `sPrefix` also gets a directory entry of its own; an empty `sPrefix` adds the content at the top level. Directory symbolic links and junctions are not followed. Stops at the first failure. |
| `Function CreateArchive String sArchiveFile String[] sFiles Integer eFormat Integer eFilter Returns Integer` | One call helper: creates the writer, selects format (`SetFormat`) and filter (`AddFilter`, skipped for `ARCHIVE_FILTER_NONE`), opens `sArchiveFile`, adds every element of `sFiles` (a file under its file name, a folder with `AddFolderTree` under the folder name), closes and frees the writer. After a failure the writer is freed without `FailWriter`, so the output file is closed; the partial archive stays on disk (delete it yourself). The writer of the object is replaced; it is freed when the call returns. |

## Compression, encryption and options

- **zip**: `peZipCompression` / `SetZipCompressionStore` / `SetZipCompressionDeflate` or the options `zip:compression=store|deflate`, `zip:encryption=zipcrypt|aes128|aes256`, `zip:hdrcharset`, `zip:fakecrc32`.
- **gzip / bzip2 / xz / zstd / lz4 / lzma / lzip**: the option `compression-level` (for example `SetFilterOption "gzip" "compression-level" "9"`).
- **Encryption** is available for zip: `SetOption "zip" "encryption" "zipcrypt"` (traditional PKWARE, weak), `"aes128"` or `"aes256"` (WinZip AES, needs `libcrypto-3-x64.dll`) and `SetPassphrase`. The entries are marked as encrypted (`archive_entry_is_data_encrypted`) and are only readable with the passphrase. The passphrase is passed as UTF-8.
- The 7zip writer of libarchive does not support encryption.
- **Block size**: `piBytesPerBlock` / `piBytesInLastBlock` matter for tar and cpio output to tapes and some tools. The default of 10240 bytes per block is fine for files.
- The names of the options of every format and filter are documented in libarchive's `archive_write_set_options(3)`.

## Unicode names

Names with characters outside of the ANSI code page of the system (Japanese on a Western Windows) and even the euro sign need the option `hdrcharset=UTF-8`: without it archive.dll 3.7.7 corrupts its heap in the zip writer, cpio refuses the entry (`ARCHIVE_FAILED`) and the tar formats lose or garble the name.

- With `pbUtf8HeaderCharset` True (default) the class sets the option right after the format is selected (`SetFormatZip`, `SetFormat`, `SetFormatByName`, `SetFormatFilterByExtension...` and every named `SetFormat...` method). `SetOption "" "hdrcharset" ...` overrides it. Formats that do not know the option (7zip, ar, iso9660, ...) answer with a failure that is ignored.
- Set `pbUtf8HeaderCharset` to False before choosing the format when you want libarchive's default (names converted to the ANSI code page).
- A reader of zip, tar or cpio archives written this way has to use the same option (`archive_read_set_options (pArchive, "hdrcharset=UTF-8")`), otherwise tar/cpio names are interpreted in the ANSI code page. Zip marks UTF-8 names with a flag and needs nothing.
- pax and 7zip store any Unicode name correctly.
- The convenience methods set the path name with `archive_entry_update_pathname_utf8`. Its result is 0 for names that are not representable in the ANSI code page; the entry keeps the name nevertheless, so the wrapper ignores the result. (`archive_entry_set_pathname_utf8` is not used because the 7zip writer then stores a wrong name.)
- `OpenFile` passes the archive file name as wide string, so any name works. `AddFile` reads the file through the DataFlex binary channel, which also supports Unicode names.

## Callbacks are not available

DataFlex cannot create native C callback function pointers. The following functions are declared in `ArchiveWrite.h.pkg` but **not exposed** by the class; use the alternatives:

| Function | Alternative |
|---|---|
| `archive_write_open`, `archive_write_open2` (open, write, close, free callbacks) | `OpenFile`, `OpenMemory`, `OpenFd`, `OpenFilePtr` |
| `archive_write_set_passphrase_callback` | `SetPassphrase` |

For output that must go to your own code (for example a socket), write to memory with `OpenMemory` and hand the bytes over, or write to a file.

## Error handling

The class inherits the error handling of [`cArchiveBase`](cArchiveBase.md):

- Every result of `ARCHIVE_FAILED` or worse is stored in `piLastResult` and `psLastError` (the text of `archive_error_string`) and passed to `OnError`.
- With `pbRaiseErrors` True (default) `OnError` raises a DataFlex error (`Error DFERR_PROGRAM`) that names the failed libarchive function. Set `pbRaiseErrors` to False to inspect the returned codes yourself, or override `OnError`.
- Problems the wrapper finds itself (missing file for `AddFile`, empty path name, entry object without entry, a second `OpenMemory`, a write that was shorter than requested) are reported the same way as `ARCHIVE_FAILED`.
- Calling a method without a writer (`CreateWriter` not sent) is a programming error: it always raises `DFERR_PROGRAM` and returns `ARCHIVE_FATAL`, whatever `pbRaiseErrors` says.
- A failed `WriteHeader` with `ARCHIVE_FAILED` only refuses that entry; `ARCHIVE_FATAL` ends the archive (the writer is dead; `FreeWriter`).
- `ARCHIVE_WARN` is returned as is and does not raise an error.

```
Set pbRaiseErrors of oWriter to False
Get OpenFile of oWriter "X:\no\such\folder\a.zip" to iResult
If (iResult < ARCHIVE_OK) Begin
    Get psLastError of oWriter to sError          // for example "Failed to open ... Cannot find the path"
End
```

## Functions of ArchiveWrite.h.pkg that are not reachable

| Function | Why |
|---|---|
| `archive_write_open`, `archive_write_open2`, `archive_write_set_passphrase_callback` | Callbacks, see above. |
| `archive_write_open_file` | Deprecated synonym of `archive_write_open_filename` (`OpenFileAnsi`). |
| `archive_write_finish` | Deprecated synonym of `archive_write_free` (`FreeWriter`). |
| `archive_write_set_compression_bzip2`, `_compress`, `_gzip`, `_lzip`, `_lzma`, `_none`, `_program`, `_xz` | Deprecated synonyms of the `archive_write_add_filter_*` functions (`AddFilter...`). |
| `archive_write_data_block` | Works only for `archive_write_disk` handles; it is `WriteDataBlock` of [`cArchiveDiskWriter`](cArchiveDiskWriter.md). |
| `archive_write_disk_*` | The write to disk family belongs to [`cArchiveDiskWriter`](cArchiveDiskWriter.md); its two callback functions are not exposed either. |
