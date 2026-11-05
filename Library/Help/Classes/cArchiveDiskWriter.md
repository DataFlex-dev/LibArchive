# cArchiveDiskWriter

Wrapper around the "write to disk" archive of libarchive (`archive_write_disk_*`). The entries and data written to it are created as files, directories and links on disk. It is the extraction half of the reader classes: read an entry with the reader, pass its header (`WriteHeader`) and data blocks (`WriteDataBlock` / `WriteData`) to this object. Libarchive takes care of creating missing parent folders, restoring time stamps, replacing existing files, and rejecting dangerous paths (`..`, symbolic link tricks).

Package: `Library/AppSrc/cArchiveDiskWriter.pkg` (`Use cArchiveDiskWriter.pkg`)

Superclass: [`cArchiveBase`](cArchiveBase.md) (handle property `ppArchive`, result/error handling).

Related: [`cArchiveEntry`](cArchiveEntry.md) (the entry passed to `WriteHeader`), [`cArchiveWriter`](cArchiveWriter.md) (creates archives).

## Contents

- [Overview](#overview)
- [Usage](#usage)
- [Properties](#properties)
- [Methods](#methods)
- [Extraction options](#extraction-options)
- [Notes for Windows](#notes-for-windows)
- [Callbacks are not available](#callbacks-are-not-available)
- [Error handling](#error-handling)

## Overview

1. `CreateDiskWriter` - allocates the handle (`archive_write_disk_new`) and applies `piOptions`.
2. For every entry: `WriteHeader` creates the file, directory or link; for regular files write the content with `WriteDataBlock` (offset aware, what a reader delivers), `WriteData`, `WriteString` or `WriteDataPointer`; `FinishEntry` completes the file (final size, time stamp).
3. `CloseWriter` - finishes the last entry and restores directory attributes (time stamps of directories are set at the end, because creating files inside changes them).
4. `FreeWriter` - releases the handle.

The path name of an entry is used as it is: relative to the current directory of the process unless it is absolute. The class does not change directories or prefix paths; build the destination into the path name of the entry (a `cArchiveEntry` object can be changed with `Set psPathname`). Missing parent folders are created, unless `ARCHIVE_EXTRACT_NO_AUTODIR` is set.

## Usage

### Create a folder tree with files

```
Use cArchiveDiskWriter.pkg
Use cArchiveEntry.pkg

Object oDiskWriter is a cArchiveDiskWriter
End_Object
```

In a procedure:

```
Handle hoEntry
Pointer pEntry
Integer iResult
BigInt iWritten
String sText
Void_Type iVoid

Send CreateDiskWriter of oDiskWriter
Set piOptions of oDiskWriter to (ARCHIVE_EXTRACT_TIME ior ARCHIVE_EXTRACT_PERM)

Get CreateNamed (RefClass (cArchiveEntry)) "oArchiveEntry" to hoEntry

// a directory
Send CreateEntry of hoEntry
Set psPathname of hoEntry to "C:/Temp/out/docs/"
Get ppEntry of hoEntry to pEntry
Move (archive_entry_set_filetype (pEntry, AE_IFDIR)) to iVoid
Move (archive_entry_set_perm (pEntry, 493)) to iVoid
Move (archive_entry_set_mtime (pEntry, 1700000000, 0)) to iVoid
Get WriteHeader of oDiskWriter hoEntry to iResult

// a file in it
Move "Hello from the archive" to sText
Send CreateEntry of hoEntry
Set psPathname of hoEntry to "C:/Temp/out/docs/readme.txt"
Get ppEntry of hoEntry to pEntry
Move (archive_entry_set_filetype (pEntry, AE_IFREG)) to iVoid
Move (archive_entry_set_perm (pEntry, 420)) to iVoid
Move (archive_entry_set_size (pEntry, SizeOfString (sText))) to iVoid
Move (archive_entry_set_mtime (pEntry, 1700000000, 0)) to iVoid
Get WriteHeader of oDiskWriter hoEntry to iResult
Get WriteString of oDiskWriter sText to iWritten
Get FinishEntry of oDiskWriter to iResult

Get CloseWriter of oDiskWriter to iResult
Send FreeWriter of oDiskWriter
Send Destroy of hoEntry
```

### Extract data that arrives in blocks (what a reader delivers)

```
// for every block the reader returns: pointer, size and offset in the file
Get WriteDataBlock of oDiskWriter ucBlock iOffset to iResult
```

Blocks can arrive in any order; gaps are filled with zero bytes (or become holes with `ARCHIVE_EXTRACT_SPARSE`).

### Do not overwrite existing files

```
Set piOptions of oDiskWriter to (ARCHIVE_EXTRACT_TIME ior ARCHIVE_EXTRACT_NO_OVERWRITE)
```

An existing file is then skipped silently: `WriteHeader` returns `ARCHIVE_OK` and the file stays as it was.

## Properties

Properties of the base class (`ppArchive`, `pbRaiseErrors`, `piLastResult`, `psLastError`, `piErrorNumber`, `psErrorString`, ...) are described in [`cArchiveBase`](cArchiveBase.md).

| Property | Type | R/W | libarchive function | Description |
|---|---|---|---|---|
| `piOptions` | Integer | r/w | `archive_write_disk_set_options` | Combination of the `ARCHIVE_EXTRACT_*` flags (see [Extraction options](#extraction-options)). Default: `ARCHIVE_EXTRACT_TIME ior ARCHIVE_EXTRACT_PERM ior ARCHIVE_EXTRACT_SECURE_NODOTDOT ior ARCHIVE_EXTRACT_SECURE_SYMLINKS`. The value is remembered and applied by `CreateDiskWriter`; setting it while a writer exists applies it immediately to the following entries. |
| `piOptionsValue` | Integer | internal | - | The remembered value of `piOptions`. |

## Methods

| Signature | Description | libarchive function |
|---|---|---|
| `Procedure CreateDiskWriter` | Creates the disk writer and applies `piOptions`; an existing writer is freed first. | `archive_write_disk_new`, `archive_write_disk_set_options` |
| `Function CloseWriter Returns Integer` | Finishes the last entry, restores directory time stamps and permissions. | `archive_write_close` |
| `Procedure FreeWriter` | Frees the writer (closes it when needed). Safe without a writer. | `archive_free` |
| `Function RequireHandle Returns Pointer` | The handle; raises an error and returns 0 when there is no writer. Used by all methods. | - |
| `Function SetSkipFile BigInt iDevice BigInt iInode Returns Integer` | Device and inode of an existing file on disk that must never be overwritten, normally the archive that is being extracted. | `archive_write_disk_set_skip_file` |
| `Function SetStandardLookup Returns Integer` | Installs the standard user and group name lookup of the system (used with `ARCHIVE_EXTRACT_OWNER`). | `archive_write_disk_set_standard_lookup` |
| `Function LookupUid String sUserName BigInt iDefaultUid Returns BigInt` | The user id of a user name with the installed lookup; `iDefaultUid` when unknown or when no lookup is installed. | `archive_write_disk_uid` |
| `Function LookupGid String sGroupName BigInt iDefaultGid Returns BigInt` | The group id of a group name with the installed lookup; `iDefaultGid` when unknown or when no lookup is installed. | `archive_write_disk_gid` |
| `Function WriteHeader Handle hoEntry Returns Integer` | Creates the file, directory or link of the entry of a `cArchiveEntry` object (path name, file type, size, time stamps, permissions, hard link / symlink target). `ARCHIVE_FAILED` when the object has no entry. The entry is not changed. | `archive_write_header` |
| `Function WriteHeaderPointer Pointer pEntry Returns Integer` | Same for a raw `archive_entry *`. | `archive_write_header` |
| `Function WriteData UChar[] ucData Returns BigInt` | Writes the next bytes of the current file. Returns the number of bytes written (negative = error code). | `archive_write_data` |
| `Function WriteString String sData Returns BigInt` | Writes the bytes of a string (UTF-8). | `archive_write_data` |
| `Function WriteDataPointer Pointer pData BigInt iSize Returns BigInt` | Writes `iSize` bytes at `pData`. | `archive_write_data` |
| `Function WriteDataBlock UChar[] ucData BigInt iOffset Returns BigInt` | Writes a block at the file offset `iOffset`. Returns `ARCHIVE_OK` (0), negative = error code. | `archive_write_data_block` |
| `Function FinishEntry Returns Integer` | Completes the current file: final size, time stamp, permissions, owner. Done automatically by the next `WriteHeader` and by `CloseWriter`. | `archive_write_finish_entry` |

## Extraction options

Flags for `piOptions` (constants in `Archive.h.pkg`), combine them with `ior`:

| Flag | Effect |
|---|---|
| `ARCHIVE_EXTRACT_OWNER` | Restore the owner and group (needs `SetStandardLookup` or numeric ids). Not meaningful on Windows. |
| `ARCHIVE_EXTRACT_PERM` | Restore the permissions. Ignored for the file mode on Windows (see below). |
| `ARCHIVE_EXTRACT_TIME` | Restore the modification time. Without it files get the time of their creation. |
| `ARCHIVE_EXTRACT_NO_OVERWRITE` | Do not replace existing files (they are skipped silently). |
| `ARCHIVE_EXTRACT_UNLINK` | Remove an existing file before creating the new one. |
| `ARCHIVE_EXTRACT_ACL`, `ARCHIVE_EXTRACT_FFLAGS`, `ARCHIVE_EXTRACT_XATTR`, `ARCHIVE_EXTRACT_MAC_METADATA` | Restore ACLs, file flags, extended attributes, Mac metadata (platform dependent). |
| `ARCHIVE_EXTRACT_SECURE_SYMLINKS` | Refuse to follow symbolic links when creating files (protects against archives that redirect the extraction). |
| `ARCHIVE_EXTRACT_SECURE_NODOTDOT` | Reject entries that contain `..` path elements (`WriteHeader` returns `ARCHIVE_FAILED`). |
| `ARCHIVE_EXTRACT_SECURE_NOABSOLUTEPATHS` | Reject absolute paths. Do not set it when you pass absolute destination paths in the entries. |
| `ARCHIVE_EXTRACT_NO_AUTODIR` | Do not create missing parent folders (`WriteHeader` returns `ARCHIVE_FAILED`). |
| `ARCHIVE_EXTRACT_NO_OVERWRITE_NEWER` | Do not replace a file that is newer than the entry. |
| `ARCHIVE_EXTRACT_SPARSE` | Write holes for blocks of zero bytes. |
| `ARCHIVE_EXTRACT_SAFE_WRITES` | Write files atomically (temporary file and rename). |
| `ARCHIVE_EXTRACT_CLEAR_NOCHANGE_FFLAGS`, `ARCHIVE_EXTRACT_NO_HFS_COMPRESSION`, `ARCHIVE_EXTRACT_HFS_COMPRESSION_FORCED` | Platform specific. |

## Notes for Windows

These are observations from the tests with archive.dll 3.7.7:

- Entry paths may use `/` or `\`. Absolute paths work (`C:/Temp/out/file.txt`) as long as `ARCHIVE_EXTRACT_SECURE_NOABSOLUTEPATHS` is not set.
- File and folder names with any Unicode characters work (set them with the UTF-8 path name of the entry). Note: the `psPathname` setter of `cArchiveEntry` raises an error when libarchive cannot convert the name to the ANSI code page (for example Japanese on a Western system) although libarchive stores the name; check the entry class for the current behaviour.
- The permission bits are not mapped to Windows attributes in this build (a file with permission 0444 does not get the read-only attribute). `ARCHIVE_EXTRACT_TIME` works (files and, after `CloseWriter`, directories).
- Hard links are created for entries with a hard link target (the target must exist). Creating symbolic links needs the symlink privilege of Windows.
- `SetSkipFile` refers to the device and inode of an existing file on disk; the tests only check that the setting is accepted.
- `LookupUid` / `LookupGid` returned the default value in the tests (with and without `SetStandardLookup`): Windows has no user and group id database.

## Callbacks are not available

DataFlex cannot create native C callback function pointers. `archive_write_disk_set_user_lookup` and `archive_write_disk_set_group_lookup` take a lookup function and a cleanup function; they are declared in `ArchiveWrite.h.pkg` but **not exposed** by the class. Use `SetStandardLookup` and `LookupUid` / `LookupGid`.

## Error handling

The class inherits the error handling of [`cArchiveBase`](cArchiveBase.md):

- Every result of `ARCHIVE_FAILED` or worse is stored in `piLastResult` / `psLastError` and passed to `OnError`, which raises a DataFlex error (`Error DFERR_PROGRAM`) while `pbRaiseErrors` is True (the default). Set `pbRaiseErrors` to False to look at the returned codes, for example to continue with the next entry when `WriteHeader` refuses one (`ARCHIVE_FAILED`: path with `..`, folder missing with `ARCHIVE_EXTRACT_NO_AUTODIR`, file cannot be created).
- `ARCHIVE_FATAL` ends the extraction (disk full, invalid state).
- `ARCHIVE_WARN` is returned as is and does not raise an error.
- A method called without a writer (`CreateDiskWriter` not sent) always raises `DFERR_PROGRAM` and returns `ARCHIVE_FATAL`.
- A `cArchiveEntry` object without an entry, or a null entry pointer, makes `WriteHeader` / `WriteHeaderPointer` return `ARCHIVE_FAILED`.
