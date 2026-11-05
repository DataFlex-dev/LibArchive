# cArchiveReader

`Use cArchiveReader.pkg` — `Class cArchiveReader is a cArchiveReaderBase` (which is a [cArchiveBase](cArchiveBase.md))

Reads archives with libarchive: zip, tar, 7zip, cpio, ar, iso9660, rar/rar5, cab, lha, xar, warc, mtree, raw and empty archives, optionally through compression filters (gzip, bzip2, xz, lzma, lzip, lz4, zstd, compress, uu, rpm). The archive can come from a file, several volume files, a memory buffer, a C runtime file descriptor or a C `FILE` pointer.

`cArchiveReaderBase` (same package) is the part that [cArchiveDiskReader](cArchiveDiskReader.md) shares: the current entry object `phoEntry`, `NextHeader`, `EntryInfo` and reading the entry data. `cArchiveReader.pkg` also defines the struct `tArchiveEntryInfo` and the constants `ARCHIVE_SEEK_SET`, `ARCHIVE_SEEK_CUR`, `ARCHIVE_SEEK_END` (the values of the C `SEEK_*` constants).

## Workflow

1. `CreateReader` (or `CreateReaderAll`) creates the handle.
2. Enable the formats and filters you want to read (`SupportFormat*`, `SupportFilter*`), **before opening**. `CreateReaderAll` enables all of them.
3. Open: `OpenFile`, `OpenFiles`, `OpenMemory`, `OpenFd`, `OpenFilePtr`. A handle can be opened **once**.
4. `NextHeader` returns the next entry (`ARCHIVE_OK`), `ARCHIVE_EOF` at the end. The entry is available through `phoEntry` (a [cArchiveEntry](cArchiveEntry.md) that borrows the entry; it is only valid until the next `NextHeader`). Read its data with `ReadData`, `ReadAllData`, `ReadDataToString`, `ReadDataBlock` or `DataToFile`, skip it with `SkipData` or extract it with `ExtractCurrent`.
5. `FreeReader` (also done when the object is destroyed).

For the common tasks there are one-call methods that return a `tArchiveOperationResult` and never raise an error: `ListEntries` and `ReadEntryData` for every format, and `InspectZipArchive` / `ExtractZipArchive` for bounded, safe ZIP extraction. To extract other formats, loop over `NextHeader` and call `ExtractCurrent`.

## Notes

- **No callbacks.** DataFlex cannot create native C function pointers. The functions that need callbacks (`archive_read_open`, `archive_read_open2`, `archive_read_set_open/read/seek/skip/close/switch_callback`, `archive_read_set_callback_data*`, `archive_read_add/append/prepend_callback_data`, `archive_read_set_passphrase_callback`, `archive_read_extract_set_progress_callback`) are declared in `ArchiveRead.h.pkg` but not exposed by the class. Use the `Open*` methods and `AddPassphrase` instead. `Open1` is exposed for completeness but fails with `ARCHIVE_FATAL` because no callbacks can be set.
- **Not exposed either:** the ANSI code page variants `archive_read_open_filename` and `archive_read_open_filenames` (the wide variants are used) and the deprecated synonyms (`archive_read_open_file`, `archive_read_finish`, `archive_read_support_compression_*`).
- **Errors** follow [cArchiveBase](cArchiveBase.md): every method returns the libarchive result code; `ARCHIVE_FAILED` and `ARCHIVE_FATAL` are stored in `piLastResult` / `psLastError` and raise `Error DFERR_PROGRAM` unless `pbRaiseErrors` is False. A method that needs a handle reports `ARCHIVE_FATAL` ("there is no libarchive handle") instead of crashing when there is none.
- **A handle opens one archive.** Calling an `Open*` method a second time, also after a failed open, would corrupt memory in libarchive 3.7.7, so it is refused with `ARCHIVE_FATAL`. Call `CreateReader` for the next archive.
- **Registering a format twice.** libarchive 3.7.7 crashes when the rar5 reader is registered twice (for example `SupportFormatRar5` after `SupportFormatAll`). The class remembers it: repeated `SupportFormatRar5` / `SupportFormatAll` calls are harmless.
- **Reader slots.** libarchive 3.7.7 gives a handle 16 format reader slots and 16 filter slots; registering more crashes. `SupportFormatAll` / `SupportFilterAll` fit; do not register every individual format and filter on one handle.
- **Crash guards.** `AppendFilter ARCHIVE_FILTER_COMPRESS` crashes inside libarchive 3.7.7, so the class enables detection of the compress filter instead (`archive_read_support_filter_compress`). `AppendFilterProgram` / `AppendFilterProgramSignature` return `ARCHIVE_FATAL` at once when the program cannot be started.
- **Memory archives.** `OpenMemory` copies the bytes into a buffer owned by the object (`ppMemory`, `piMemorySize`) because libarchive keeps reading from it until the archive is closed. The buffer is released by `FreeReader`.
- **Non ASCII names.** File names are passed as wide strings. Entry names are UTF-8 (`psPathname`). Source files with non ASCII string literals must be saved as UTF-8 with BOM.
- **After `SkipData`, an error or the end** the entry data cannot be read any more; call `NextHeader`. After `ARCHIVE_EOF` do not call `NextHeader` again (libarchive reports `ARCHIVE_FATAL`).
- **Extraction safety.** Extract untrusted archives with `ARCHIVE_EXTRACT_SECURE_NODOTDOT ior ARCHIVE_EXTRACT_SECURE_SYMLINKS ior ARCHIVE_EXTRACT_SECURE_NOABSOLUTEPATHS`. libarchive reports an entry it refuses (path with `..`, absolute path, ...) as `ARCHIVE_WARN` and does not write it.
- libarchive 3.7.7 has no working `archive_seek_data` in the readers that can be tested (`SeekData` returns `ARCHIVE_FATAL` for zip, tar, 7zip, cpio, iso9660 and rar5), and its 7zip *writer* garbles non ASCII names when the process uses the "C" locale (which DataFlex programs do). Reading 7zip archives with Unicode names is fine.

## Properties

| Property | Type | Access | libarchive function |
|---|---|---|---|
| `ppArchive` | `Pointer` | read/write | The handle (`struct archive *`), see [cArchiveBase](cArchiveBase.md). |
| `phoEntry` | `Handle` | read | Object of class `cArchiveEntry` that wraps the entry `NextHeader` returned (borrowed, invalid after the next header or `FreeReader`). |
| `psPassphrase` | `String` | read/write | Passphrase that `OpenArchive`, `ListEntries` and `ReadEntryData` add before opening. |
| `pbUtf8HeaderCharset` | `Boolean` | read/write | Default False. True sets `hdrcharset=UTF-8` for the format readers before opening. libarchive 3.7.7 then reports `ARCHIVE_WARN` for every non ASCII entry name and returns no name (`psPathname` is empty, the entry cannot be extracted) because it converts to the locale of the process; without the option names are UTF-8 and correct. `ARCHIVE_WARN` is never raised as an error. |
| `ppMemory` | `Pointer` | read | The memory copy `OpenMemory` made. |
| `piMemorySize` | `Integer` | read | Its size in bytes. |
| `pbRar5Registered`, `pbAllRegistered`, `pbOpenCalled` | `Boolean` | read | Internal state that guards the libarchive 3.7.7 problems described above. |
| `pbHasEncryptedEntries` | `Boolean` | read | `archive_read_has_encrypted_entries`: True when an encrypted entry was found among the headers read so far. |
| `peFormatCapabilities` | `Integer` | read | `archive_read_format_capabilities`: `ARCHIVE_READ_FORMAT_CAPS_*` bit mask of what the format reader can tell about encryption (valid after the first header). |
| `pbRaiseErrors`, `piLastResult`, `psLastError`, `piErrorNumber`, `psErrorString`, `piFileCount`, `peFormat`, `psFormatName`, `piFilterCount`, version properties | | | Inherited from [cArchiveBase](cArchiveBase.md). `FilterCode`, `FilterName` and `FilterBytes` give the filter pipeline. |

## Methods

### Create, close and free

| Method | Description | libarchive function |
|---|---|---|
| `Procedure CreateReader` | Frees the previous handle and creates a reader handle. No formats or filters are enabled. | `archive_read_new` |
| `Procedure CreateReaderAll` | `CreateReader` + `SupportFormatAll` + `SupportFilterAll`. | `archive_read_new` |
| `Procedure CloseReader` | Closes the archive but keeps the handle. | `archive_read_close` |
| `Procedure FreeReader` / `FreeHandle` | Closes and frees the handle and the memory copy of `OpenMemory`. Safe without a handle. | `archive_read_free` |

### Format support (call before opening)

| Method | Description | libarchive function |
|---|---|---|
| `Function SupportFormat7zip Returns Integer` | Enables reading of 7-Zip archives. Needs a seekable source (file or memory). | `archive_read_support_format_7zip` |
| `Function SupportFormatAr Returns Integer` | Enables reading of ar archives. | `archive_read_support_format_ar` |
| `Function SupportFormatCab Returns Integer` | Enables reading of Microsoft CAB archives. | `archive_read_support_format_cab` |
| `Function SupportFormatCpio Returns Integer` | Enables reading of cpio archives, all variants. | `archive_read_support_format_cpio` |
| `Function SupportFormatEmpty Returns Integer` | Enables reading of empty (zero byte) archives; they report no entries instead of an error. | `archive_read_support_format_empty` |
| `Function SupportFormatGnutar Returns Integer` | Enables reading of GNU tar archives and the tar variants it can detect. | `archive_read_support_format_gnutar` |
| `Function SupportFormatIso9660 Returns Integer` | Enables reading of ISO 9660 images including Rock Ridge and Joliet. | `archive_read_support_format_iso9660` |
| `Function SupportFormatLha Returns Integer` | Enables reading of LHA/LZH archives. | `archive_read_support_format_lha` |
| `Function SupportFormatMtree Returns Integer` | Enables reading of mtree manifests. | `archive_read_support_format_mtree` |
| `Function SupportFormatRar Returns Integer` | Enables reading of RAR archives up to version 4. | `archive_read_support_format_rar` |
| `Function SupportFormatRaw Returns Integer` | Enables the raw format, which presents any data stream as one entry named "data". | `archive_read_support_format_raw` |
| `Function SupportFormatTar Returns Integer` | Enables reading of tar archives: v7, ustar, pax and GNU variants. | `archive_read_support_format_tar` |
| `Function SupportFormatWarc Returns Integer` | Enables reading of WARC web archives. | `archive_read_support_format_warc` |
| `Function SupportFormatXar Returns Integer` | Enables reading of XAR archives. | `archive_read_support_format_xar` |
| `Function SupportFormatZip Returns Integer` | Enables both the streamable and the seekable zip reader. | `archive_read_support_format_zip` |
| `Function SupportFormatZipStreamable Returns Integer` | Enables the zip reader that reads from the beginning to the end of the stream. It does not handle self extracting zips or zips that were modified in place. | `archive_read_support_format_zip_streamable` |
| `Function SupportFormatZipSeekable Returns Integer` | Enables the zip reader that starts at the central directory. It needs a seekable source. | `archive_read_support_format_zip_seekable` |
| `Function SupportFormatRar5 Returns Integer` | Enables reading of RAR 5 archives. Repeated calls are harmless (see Notes). | `archive_read_support_format_rar5` |
| `Function SupportFormatAll Returns Integer` | Enables all formats except raw. Repeated calls are harmless; when `SupportFormatRar5` was called before, the other formats are enabled one by one. | `archive_read_support_format_all` |
| `Function SupportFormatByCode Integer eFormat Returns Integer` | Enables one format by its `ARCHIVE_FORMAT_*` code. | `archive_read_support_format_by_code` |
| `Function SetFormat Integer eFormat Returns Integer` | Selects the format and skips the format detection. | `archive_read_set_format` |

### Filter support (call before opening)

| Method | Description | libarchive function |
|---|---|---|
| `Function SupportFilterAll Returns Integer` | Enables detection of all supported filters. | `archive_read_support_filter_all` |
| `Function SupportFilterBzip2 Returns Integer` | Enables detection and decompression of bzip2. | `archive_read_support_filter_bzip2` |
| `Function SupportFilterCompress Returns Integer` | Enables detection and decompression of Unix compress, .Z. | `archive_read_support_filter_compress` |
| `Function SupportFilterGzip Returns Integer` | Enables detection and decompression of gzip. | `archive_read_support_filter_gzip` |
| `Function SupportFilterGrzip Returns Integer` | Enables detection of grzip; needs the external grzip program. | `archive_read_support_filter_grzip` |
| `Function SupportFilterLrzip Returns Integer` | Enables detection of lrzip; needs the external lrzip program. | `archive_read_support_filter_lrzip` |
| `Function SupportFilterLz4 Returns Integer` | Enables detection and decompression of lz4. | `archive_read_support_filter_lz4` |
| `Function SupportFilterLzip Returns Integer` | Enables detection and decompression of lzip. | `archive_read_support_filter_lzip` |
| `Function SupportFilterLzma Returns Integer` | Enables detection and decompression of lzma. | `archive_read_support_filter_lzma` |
| `Function SupportFilterLzop Returns Integer` | Enables detection of lzop; needs the external lzop program. | `archive_read_support_filter_lzop` |
| `Function SupportFilterNone Returns Integer` | Enables the pass-through filter for uncompressed data. | `archive_read_support_filter_none` |
| `Function SupportFilterRpm Returns Integer` | Enables detection of the RPM wrapper around a payload. | `archive_read_support_filter_rpm` |
| `Function SupportFilterUu Returns Integer` | Enables detection and decoding of uuencoded data. | `archive_read_support_filter_uu` |
| `Function SupportFilterXz Returns Integer` | Enables detection and decompression of xz. | `archive_read_support_filter_xz` |
| `Function SupportFilterZstd Returns Integer` | Enables detection and decompression of Zstandard. | `archive_read_support_filter_zstd` |
| `Function SupportFilterByCode Integer eFilter Returns Integer` | Enables one filter by its `ARCHIVE_FILTER_*` code. | `archive_read_support_filter_by_code` |
| `Function SupportFilterProgram String sCommand Returns Integer` | Applies an external program as filter to every input (no detection). | `archive_read_support_filter_program` |
| `Function SupportFilterProgramSignature String sCommand UChar[] ucSignature Returns Integer` | External program filter that is used when the input starts with `ucSignature`. | `archive_read_support_filter_program_signature` |
| `Function AppendFilter Integer eFilter Returns Integer` | Appends one filter to the pipeline without detection (for `ARCHIVE_FILTER_COMPRESS` it enables detection instead, see Notes). | `archive_read_append_filter` |
| `Function AppendFilterProgram String sCommand Returns Integer` | Appends an external decompression program to the pipeline. | `archive_read_append_filter_program` |
| `Function AppendFilterProgramSignature String sCommand UChar[] ucSignature Returns Integer` | Appends an external program that is used when the input starts with `ucSignature`. | `archive_read_append_filter_program_signature` |

`SupportFilterGrzip`, `SupportFilterLrzip` and `SupportFilterLzop` need the external program and return `ARCHIVE_WARN`; `SupportFormatXar` returns `ARCHIVE_WARN` when libarchive was built without an XML library.

### Options and passphrases (call before opening)

| Method | Description | libarchive function |
|---|---|---|
| `Function SetFormatOption String sModule String sOption String sValue Returns Integer` | Option for the format readers; `sModule` "" matches any module. `ARCHIVE_FAILED` when no module knows the option. | `archive_read_set_format_option` |
| `Function SetFilterOption String sModule String sOption String sValue Returns Integer` | Option for the filters. | `archive_read_set_filter_option` |
| `Function SetOption String sModule String sOption String sValue Returns Integer` | Option for formats and filters. | `archive_read_set_option` |
| `Function SetOptions String sOptions Returns Integer` | Options from a string like `"tar:read_concatenated_archives=1,zip:hdrcharset=UTF-8"`. | `archive_read_set_options` |
| `Function AddPassphrase String sPassphrase Returns Integer` | Adds a passphrase that is tried when decrypting entries; call it several times to offer more. | `archive_read_add_passphrase` |

### Open

| Method | Description | libarchive function |
|---|---|---|
| `Function OpenFile String sFileName Integer iBlockSize Returns Integer` | Opens an archive file (wide name). `iBlockSize` <= 0 uses 10240. An empty name (stdin) is refused. | `archive_read_open_filename_w` |
| `Function OpenFiles String[] asFileNames Integer iBlockSize Returns Integer` | Opens a multi volume archive; the volumes in reading order. | `archive_read_open_filenames_w` |
| `Function OpenMemory UChar[] ByRef ucBuffer Returns Integer` | Opens an archive in memory; the bytes are copied (`ppMemory`). | `archive_read_open_memory` |
| `Function OpenMemoryChunked UChar[] ByRef ucBuffer Integer iReadSize Returns Integer` | Like `OpenMemory`, libarchive receives chunks of `iReadSize` bytes (for testing). | `archive_read_open_memory2` |
| `Function OpenFd Integer iFileDescriptor Integer iBlockSize Returns Integer` | Opens an archive from a C runtime file descriptor; you close it afterwards. | `archive_read_open_fd` |
| `Function OpenFilePtr Pointer pFile Returns Integer` | Opens an archive from a C `FILE *`; you close it afterwards. | `archive_read_open_FILE` |
| `Function Open1 Returns Integer` | Opens with the callbacks set earlier; callbacks cannot be set from DataFlex, so this fails with `ARCHIVE_FATAL`. | `archive_read_open1` |

### Entries and data

| Method | Description | libarchive function |
|---|---|---|
| `Function NextHeader Returns Integer` | Reads the next header into `phoEntry`. `ARCHIVE_OK`/`ARCHIVE_WARN`: an entry; `ARCHIVE_EOF`: the end. | `archive_read_next_header` |
| `Function NextHeaderInto Handle hoEntry Returns Integer` | Reads the next header into your own `cArchiveEntry` (created when empty); it stays valid after the next header. | `archive_read_next_header2` |
| `Function EntryInfo Returns tArchiveEntryInfo` | Summary (path, size, mtime, type, permissions, encrypted) of the current entry. | `archive_entry_*` |
| `Function HeaderPosition Returns BigInt` | Byte offset in the uncompressed data where the last header started. | `archive_read_header_position` |
| `Function ReadData Integer iMaxBytes Returns UChar[]` | Reads up to `iMaxBytes` bytes of the current entry; empty at the end (and after a failure, see `piLastResult`). | `archive_read_data` |
| `Function ReadAllData UChar[] ByRef ucData Returns Integer` | Reads all remaining data into `ucData`. | `archive_read_data` |
| `Function ReadDataToString Returns String` | All remaining data as a binary safe string. | `archive_read_data` |
| `Function ReadDataBlock BigInt ByRef iOffset UChar[] ByRef ucData Returns Integer` | Next data block and its offset in the entry; `ARCHIVE_EOF` at the end. | `archive_read_data_block` |
| `Function DataToFile String sFileName Returns Integer` | Writes the remaining data of the current entry to a file (created or replaced) through libarchive's disk writer, so any Unicode name works and the holes of sparse entries are written at their offsets. The folder of the file must exist. `ARCHIVE_FAILED` when the file cannot be created. | `archive_read_data_block`, `archive_write_disk_*` |
| `Function SkipData Returns Integer` | Skips the remaining data of the current entry. | `archive_read_data_skip` |
| `Function SeekData BigInt iOffset Integer eWhence Returns BigInt` | Seeks in the entry data; returns the new offset or a negative code. Not supported by the readers of libarchive 3.7.7 that can be tested. | `archive_seek_data` |
| `Function EncryptedEntriesState Returns Integer` | Raw result of `archive_read_has_encrypted_entries`: 1 found, 0 none yet, `ARCHIVE_READ_FORMAT_ENCRYPTION_DONT_KNOW` / `_UNSUPPORTED` unknown. | `archive_read_has_encrypted_entries` |

### Extraction

| Method | Description | libarchive function |
|---|---|---|
| `Function ExtractCurrent Integer iFlags Returns Integer` | Extracts the current entry to disk (relative to the current directory, or its absolute path) with `ARCHIVE_EXTRACT_*` flags. Change `psPathname of (phoEntry (Self))` to extract elsewhere. | `archive_read_extract` |
| `Function ExtractCurrentTo Handle hoDiskWriter Returns Integer` | Extracts the current entry through an archive_write_disk wrapper object (`ppArchive`). | `archive_read_extract2` |
| `Procedure SetExtractSkipFile BigInt iDevice BigInt iInode` | A file that extraction must not overwrite (normally the archive itself); `ExtractCurrent` returns `ARCHIVE_WARN` ("Refusing to overwrite archive") for it. | `archive_read_extract_set_skip_file` |

### Convenience methods

They use (and free) the handle of the object and add `psPassphrase` when set.

| Method | Description |
|---|---|
| `Function OpenArchive String sFileName Returns Integer` | `CreateReaderAll`, `AddPassphrase psPassphrase`, `OpenFile`. On failure the handle is kept so the error text can be read. |
| `Function ListEntries String sFileName tArchiveEntryInfo[] ByRef aEntries Returns tArchiveOperationResult` | Opens the archive, reads all headers and frees the handle. `aEntries` is empty unless `bSuccess`; `iEntryCount` holds the count. Never raises an error. |
| `Function ReadEntryData String sArchiveFile String sPathname UChar[] ByRef ucData Returns tArchiveOperationResult` | Reads the data of the first entry named `sPathname` (exact, "/" separators). `ucData` is empty unless `bSuccess`; `biExtractedBytes` is its size. Codes: `C_ARCHIVE_RESULT_OPEN_FAILED`, `_ENTRY_NOT_FOUND`, `_ENCRYPTED` (passphrase missing or wrong), `_IO_ERROR`, `_INVALID_ARGUMENT`. The data is read completely into memory. Never raises an error. |
| `Function InspectZipArchive String sArchivePath Returns tArchiveOperationResult` | Validates a ZIP file and reads the entry metadata without extracting anything. See the ZIP limits in the [README](../README.md). |
| `Function ExtractZipArchive String sArchivePath String sDestination Returns tArchiveOperationResult` | Runs `InspectZipArchive`, then extracts every regular file through application-enforced byte limits. `sDestination` must not exist; a failure removes what was created. |

### struct tArchiveOperationResult

| Member | Type | Description |
|---|---|---|
| `bSuccess` | `Boolean` | True when the operation succeeded. |
| `iErrorCode` | `Integer` | `C_ARCHIVE_RESULT_OK` (0) or the stable failure code (`_INVALID_ARGUMENT`, `_OPEN_FAILED`, `_MALFORMED`, `_UNSUPPORTED_FORMAT`, `_ENCRYPTED`, `_TOO_MANY_ENTRIES`, `_ENTRY_TOO_LARGE`, `_TOTAL_TOO_LARGE`, `_UNSAFE_PATH`, `_UNSAFE_TYPE`, `_DUPLICATE_PATH`, `_DESTINATION_EXISTS`, `_IO_ERROR`, `_SIZE_MISMATCH`, `_CLEANUP_FAILED`, `_TOO_MANY_PATH_COMPONENTS`, `_ARCHIVE_TOO_LARGE`, `_CENTRAL_DIRECTORY_TOO_LARGE`, `_ENTRY_NOT_FOUND`). |
| `sErrorMessage` | `String` | Diagnostic with the libarchive text, meant for trusted logs, not for clients. |
| `iEntryCount`, `iPathComponentCount` | `Integer` | Entries and path components that were counted. |
| `biArchiveBytes`, `biCentralDirectoryBytes`, `biDeclaredUncompressedBytes` | `BigInt` | ZIP sizes (`InspectZipArchive`, `ExtractZipArchive`). |
| `biExtractedBytes` | `BigInt` | Bytes actually written (`ExtractZipArchive`) or read (`ReadEntryData`). |

### struct tArchiveEntryInfo

| Member | Type | Description |
|---|---|---|
| `sPathname` | `String` | Path name (UTF-8). |
| `iSize` | `BigInt` | Size of the data. |
| `iMtime` | `BigInt` | Modification time, seconds since 1970-01-01 UTC. |
| `eFileType` | `Integer` | `AE_IFREG`, `AE_IFDIR`, `AE_IFLNK`, ... |
| `iPerm` | `Integer` | Permission bits (420 = 0644). |
| `bEncrypted` | `Boolean` | Data or metadata is encrypted. |

## Examples

List an archive:

```
Object oReader is a cArchiveReader
End_Object

tArchiveEntryInfo[] aEntries
tArchiveOperationResult Result
Integer iIndex
Get ListEntries of oReader "C:\data\backup.zip" (&aEntries) to Result
If (Result.bSuccess) Begin
    For iIndex from 0 to (SizeOfArray (aEntries) - 1)
        Showln aEntries[iIndex].sPathname aEntries[iIndex].iSize
    Loop
End
Else Begin
    Showln Result.iErrorCode Result.sErrorMessage
End
```

Extract a ZIP file (the destination must not exist):

```
tArchiveOperationResult Result
Get ExtractZipArchive of oReader "C:\data\backup.zip" "C:\restore" to Result
If (not (Result.bSuccess)) Begin
    Showln "Extraction problem:" Result.iErrorCode Result.sErrorMessage
End
```

Read one entry into memory (an encrypted zip):

```
UChar[] ucData
tArchiveOperationResult Result
Set psPassphrase of oReader to "secret"
Get ReadEntryData of oReader "C:\data\secret.zip" "docs/readme.txt" (&ucData) to Result
```

Walk through an archive in memory (the data of the entries is read as strings):

```
Handle hoEntry
Integer iResult
String sData
Send CreateReaderAll of oReader
Get OpenMemory of oReader (&ucArchive) to iResult
Get phoEntry of oReader to hoEntry
Get NextHeader of oReader to iResult
While (iResult = ARCHIVE_OK)
    Get ReadDataToString of oReader to sData
    Get psPathname of hoEntry to sPathname
    Showln sPathname (SizeOfString (sData))
    Get NextHeader of oReader to iResult
Loop
Send FreeReader of oReader
```

Extract the current entry to another folder:

```
Get NextHeader of oReader to iResult
Get phoEntry of oReader to hoEntry
Get psPathname of hoEntry to sPathname
Set psPathname of hoEntry to ("C:\restore\" + sPathname)
Get ExtractCurrent of oReader (ARCHIVE_EXTRACT_TIME ior ARCHIVE_EXTRACT_SECURE_NODOTDOT) to iResult
```

Open a multi volume archive:

```
String[] asVolumes
Move "C:\data\backup.tar.001" to asVolumes[0]
Move "C:\data\backup.tar.002" to asVolumes[1]
Send CreateReaderAll of oReader
Get OpenFiles of oReader asVolumes 0 to iResult
```

Find out whether a passphrase is needed (the headers of an encrypted zip can be read, the data cannot):

```
Get OpenArchive of oReader "C:\data\secret.zip" to iResult
Get NextHeader of oReader to iResult
Get pbHasEncryptedEntries of oReader to bEncrypted
If (bEncrypted) Begin
    Showln "A passphrase is needed"
End
```
