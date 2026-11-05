# cArchiveBase

`Use cArchiveBase.pkg` — `Class cArchiveBase is a cObject`

Base class of all wrapper classes that own a libarchive `struct archive` handle: [cArchiveReader](cArchiveReader.md), [cArchiveWriter](cArchiveWriter.md), [cArchiveDiskReader](cArchiveDiskReader.md), [cArchiveDiskWriter](cArchiveDiskWriter.md) and [cArchiveMatch](cArchiveMatch.md). It holds the handle, frees it when the object is destroyed and provides the shared error handling and archive information.

## Conventions of all wrapper classes

- Methods return the libarchive result code (`ARCHIVE_OK`, `ARCHIVE_EOF`, `ARCHIVE_RETRY`, `ARCHIVE_WARN`, `ARCHIVE_FAILED`, `ARCHIVE_FATAL`, see [Constants](../Constants.md)) unless documented otherwise.
- Every result passes through `CheckResult`. A result of `ARCHIVE_FAILED` or worse is stored in `piLastResult` / `psLastError` and handed to `OnError`, which raises `Error DFERR_PROGRAM` when `pbRaiseErrors` is True (default). `ARCHIVE_WARN`, `ARCHIVE_RETRY` and `ARCHIVE_EOF` never raise an error; check the returned code.
- Strings are passed to libarchive as UTF-8. **Source files that contain non-ASCII string literals must be saved as UTF-8 with BOM**, otherwise the strings are not valid UTF-8 and libarchive can crash. File names are passed as wide (UTF-16) strings where libarchive offers `_w` functions.
- Functions that libarchive offers only with C callbacks (custom read/write/seek/skip/open/close callbacks, passphrase callback, user/group lookup callbacks, progress callback, metadata filter callback) cannot be used from DataFlex, because DataFlex cannot create native function pointers. They are declared in `ArchiveRead.h.pkg` / `ArchiveWrite.h.pkg` / `ArchiveReadDisk.h.pkg` but not exposed by the classes. Use the file, memory and file descriptor variants instead.
- Functions that are used inside expressions must be defined before use (DataFlex rule); the helper functions of this class are therefore declared first.

## Properties

| Property | Type | Access | Description |
|---|---|---|---|
| `ppArchive` | `Pointer` | read/write | The libarchive handle (`struct archive *`); 0 when there is none. |
| `pbRaiseErrors` | `Boolean` | read/write | True (default): `ARCHIVE_FAILED` / `ARCHIVE_FATAL` raise a DataFlex error. |
| `piLastResult` | `Integer` | read/write | Result code of the last failed operation. |
| `psLastError` | `String` | read/write | Error text of the last failed operation. |
| `piErrorNumber` | `Integer` | read | `archive_errno` of the handle. |
| `psErrorString` | `String` | read | `archive_error_string` of the handle; empty when there is none. |
| `piFileCount` | `Integer` | read | `archive_file_count`: number of entries processed so far. |
| `peFormat` | `Integer` | read | `archive_format`: format code (`ARCHIVE_FORMAT_*`) of the current entry. |
| `psFormatName` | `String` | read | `archive_format_name`: human readable format name. |
| `piFilterCount` | `Integer` | read | `archive_filter_count`: number of filters in the pipeline. |
| `piVersionNumber` | `Integer` | read | `archive_version_number` (3007007 = 3.7.7). Needs no handle. |
| `psVersionString` | `String` | read | `archive_version_string`, "libarchive 3.7.7". |
| `psVersionDetails` | `String` | read | `archive_version_details`: libarchive plus the versions of the libraries it is built with. |
| `psZlibVersion`, `psLibLzmaVersion`, `psBzlibVersion`, `psLibLz4Version`, `psLibZstdVersion` | `String` | read | Versions of the compression libraries; empty when libarchive was built without them. |

## Methods

| Method | Description | libarchive function |
|---|---|---|
| `Function HasHandle Returns Boolean` | True when the object has a handle. | |
| `Procedure FreeHandle` | Releases the handle (closes the archive when needed). Safe without a handle. Overridden by `cArchiveMatch`. | `archive_free` |
| `Procedure OnError Integer iResult String sOperation String sErrorText` | Hook for failures; default raises `Error DFERR_PROGRAM` when `pbRaiseErrors`. Override to log or handle errors yourself. | |
| `Function CheckResult Integer iResult String sOperation Returns Integer` | Used by the subclasses for every result; stores failures and calls `OnError`; returns `iResult` unchanged. | |
| `Procedure ClearLastResult` | Resets `piLastResult` and `psLastError`. | |
| `Procedure ClearError` | Clears the error of the handle and the last result. | `archive_clear_error` |
| `Procedure SetError Integer iErrorNumber String sMessage` | Sets the error number and text of the handle. | `archive_set_error` |
| `Procedure CopyError Handle hoSource` | Copies the error of another wrapper object. | `archive_copy_error` |
| `Function FilterBytes Integer iIndex Returns BigInt` | Bytes processed by a filter (-1 = last filter). | `archive_filter_bytes` |
| `Function FilterCode Integer iIndex Returns Integer` | Filter code `ARCHIVE_FILTER_*`. | `archive_filter_code` |
| `Function FilterName Integer iIndex Returns String` | Filter name. | `archive_filter_name` |
| `Function PointerText Pointer pText Returns String` | Helper for subclasses: converts a C string pointer to a string; 0 gives "". | |
| `Function PointerWideText Pointer pText Returns String` | Same for a wide string pointer. | |

## Example: error handling

```
Object oReader is a cArchiveReader
    Set pbRaiseErrors to False
End_Object

Integer iResult
String sLastError
Get OpenFile of oReader "c:\missing.zip" 10240 to iResult
If (iResult <> ARCHIVE_OK) Begin
    Get psLastError of oReader to sLastError
    Showln "Failed:" sLastError
End
```
