# cFilesArchiver

`Use cFilesArchiver.pkg` — `Class cFilesArchiver is a cObject`

A small, ready-made helper that packs a list of files and folders into one archive file. It was the first class of the library and stays available unchanged in behavior. For anything beyond "files in, archive out" (reading archives, in-memory archives, filters, encryption, options, entry metadata) use the classes [cArchiveWriter](cArchiveWriter.md), [cArchiveReader](cArchiveReader.md) and [cArchiveEntry](cArchiveEntry.md).

Requires `archive.dll` in the program folder. It declares no Windows API function and needs no `DateAndTime` library: files and folders are read with DataFlex file I/O and libarchive's disk reader.

## Typical use

```
Object oFilesArchiver is a cFilesArchiver
End_Object

Send Init of oFilesArchiver
Set peArchiveFormat of oFilesArchiver to ARCHIVE_FORMAT_ZIP
Set psArchiveFileName of oFilesArchiver to "c:\tmp\example.zip"
Send AddFileToArchive of oFilesArchiver "c:\data\report.pdf"
Send AddFileToArchive of oFilesArchiver "c:\data\images"          // a folder is added recursively
Send WriteFilesToArchive of oFilesArchiver
```

Errors reported by libarchive are raised as `Error DFERR_PROGRAM` with the libarchive error text and error number.

## Properties

| Property | Type | Description |
|---|---|---|
| `psFileNamesToArchive` | `String[]` | Files and folders that are written by `WriteFilesToArchive`. Filled by `AddFileToArchive` / `AddMultipleFiles`. |
| `psArchiveFileName` | `String` | Name of the archive file that is created. |
| `peArchiveFormat` | `Integer` | One of the `ARCHIVE_FORMAT_*` constants (default `ARCHIVE_FORMAT_ZIP`). Formats without a writer in libarchive (EMPTY, LHA, CAB, RAR, RAR_V5, CPIO SVR4/AFIO) raise an error. `ARCHIVE_FORMAT_AR_GNU` uses the SVR4 writer (`archive_write_set_format_ar_svr4`); libarchive has no separate GNU ar writer. |
| `ppArchive` | `Pointer` | The libarchive write handle while an archive is being written (design time false). |
| `pArchiveFormats` | `tArchiveFormat[]` | Name / format code pairs ("zip", "tar_ustar", "7zip", ...), filled in `Construct_Object`, handy for filling a combo form. |

## Struct

| Struct | Members |
|---|---|
| `tArchiveFormat` | `String sFormat` (format name), `Integer eFormat` (`ARCHIVE_FORMAT_*`) |

## Methods

| Method | Description |
|---|---|
| `Procedure Init` | Clears `psFileNamesToArchive` and `psArchiveFileName` so the object can be reused. |
| `Procedure AddFileToArchive String sFileNameWithPath` | Appends a file or folder to `psFileNamesToArchive`. |
| `Procedure AddMultipleFiles String[] sFileNames` | Replaces `psFileNamesToArchive` with the given array. |
| `Procedure WriteFilesToArchive` | Creates the archive: new handle, format from `peArchiveFormat`, opens `psArchiveFileName`, writes all files and folders, closes and frees the handle. |
| `Procedure AddFolder String sFolderPath String sBasePath` | Writes a directory entry and its content recursively. Gets called by `WriteFilesToArchive`. |
| `Function AddFolderRecursive Pointer pArchive String sFolderPath String sBasePath Returns Integer` | Writes the files and sub folders of a folder to an open archive handle. |
| `Function FileContents String sFileName UChar[] ByRef ucFileData Returns Integer` | Reads a whole file into a byte array. Returns the number of data bytes > 0, 0 when the file is empty or cannot be opened, -1 when no channel is free. |
| `Function FileFolderCreationUnixDateTime String sFolderPath Returns BigInt` | Time stamp of a file or folder as Unix time (seconds since 1970-01-01 UTC). The name is kept for compatibility: the value is the **last modification time** read by libarchive, because a creation time is not available on every platform. 0 when the file cannot be read. |

Private methods (`CreateArchiveFormats`, `FreeArchiveWrite`, `OpenNewArchive`, `FinishAndCloseArchive`, `AddFilesToArchive`, `WriteFileToArchive`, `SetArchiveFileName`, `SetArchiveFormat`, `HandleArchiveError`) implement the steps above and are not part of the public interface.

## libarchive functions used

`archive_write_new`, `archive_write_set_format_*`, `archive_write_open_filename`, `archive_entry_new`, `archive_entry_set_pathname_utf8`, `archive_entry_set_size`, `archive_entry_set_perm`, `archive_entry_set_filetype`, `archive_entry_set_mtime`, `archive_write_header`, `archive_write_data`, `archive_entry_free`, `archive_write_close`, `archive_write_free`, `archive_errno`, `archive_error_string`.
