# cArchiveDiskReader

`Use cArchiveDiskReader.pkg` — `Class cArchiveDiskReader is a cArchiveReaderBase` (which is a [cArchiveBase](cArchiveBase.md))

Reads files and folders of the local file system as archive entries: libarchive's "read disk" side. It walks a folder tree, fills entries with the metadata of the files (size, times, type, permissions) and delivers the file data, in the same way [cArchiveReader](cArchiveReader.md) delivers the entries of an archive. Typical uses: find out what an archive made from a folder would contain, or feed entries to an archive writer.

`cArchiveReaderBase` (defined in `cArchiveReader.pkg`, which this package uses) provides `phoEntry`, `NextHeader`, `EntryInfo`, `ReadData`, `ReadAllData`, `ReadDataToString`, `ReadDataBlock` and `DataToFile`; they work on a disk handle exactly as on an archive. `SkipData`, `SeekData`, `HeaderPosition` and the extraction methods exist only in `cArchiveReader` because libarchive does not support them on a disk handle. The struct `tArchiveEntryInfo` is defined in `cArchiveReader.pkg`.

## Workflow

1. `CreateDiskReader` creates the handle (the behavior properties are applied to it).
2. Optionally `SetMatching` to exclude entries.
3. `OpenDisk sPath` starts the traversal. The first entry `NextHeader` returns is `sPath` itself.
4. `NextHeader` returns each entry. **A folder is entered only when you call `Descend`** right after it was returned (use `CanDescend` to test); a folder you do not descend into is skipped. Read the file data with `ReadAllData` & co.
5. `FreeHandle` (also done when the object is destroyed); `CloseDiskReader` ends a traversal but keeps the handle and its settings.

`ListFolder` does the whole traversal in one call.

## Notes

- **No callbacks.** DataFlex cannot create native C function pointers. `archive_read_disk_set_uname_lookup`, `archive_read_disk_set_gname_lookup` and `archive_read_disk_set_metadata_filter_callback` are declared in `ArchiveReadDisk.h.pkg` but not exposed by the class; `SetMatching` passes no exclusion callback (the match object decides). The ANSI code page variant `archive_read_disk_open` is not exposed, `OpenDisk` uses the wide variant.
- **Errors** follow [cArchiveBase](cArchiveBase.md). A path that does not exist is reported by the first `NextHeader` (`ARCHIVE_FAILED`).
- **Paths.** Entry path names are what libarchive builds from the path given to `OpenDisk` (on Windows with backslashes, as in `C:\data\sub\file.txt`); `OpenDisk` removes trailing backslashes and slashes (except for a drive root) because libarchive cannot visit `C:\data\`.
- **Windows.** There are no numeric user and group ids: `SetStandardLookup` returns `ARCHIVE_FATAL` ("Standard lookups not available on Windows") and `UserName` / `GroupName` return "". `piFileCount` is not maintained for disk handles.
- **Symbolic links.** `peSymlinkMode` decides whether a link is described itself (`ARCHIVE_SYMLINK_PHYSICAL`, default), always followed (`ARCHIVE_SYMLINK_LOGICAL`) or followed only at the root of the traversal (`ARCHIVE_SYMLINK_HYBRID`). Creating symbolic links on Windows needs the privilege or developer mode.

## Constants

| Constant | Value | Description |
|---|---|---|
| `ARCHIVE_SYMLINK_PHYSICAL` | 0 | Never follow symbolic links (default). |
| `ARCHIVE_SYMLINK_LOGICAL` | 1 | Always follow symbolic links. |
| `ARCHIVE_SYMLINK_HYBRID` | 2 | Follow the symbolic link given as the traversal root only. |

`piBehaviorFlags` takes a combination of the `ARCHIVE_READDISK_*` constants (see [Constants](../Constants.md)).

## Properties

| Property | Type | Access | libarchive function |
|---|---|---|---|
| `piBehaviorFlags` | `Integer` | read/write | `archive_read_disk_set_behavior`: `ARCHIVE_READDISK_RESTORE_ATIME`, `_HONOR_NODUMP`, `_MAC_COPYFILE`, `_NO_TRAVERSE_MOUNTS`, `_NO_XATTR`, `_NO_ACL`, `_NO_FFLAGS`, `_NO_SPARSE`. Can be set before `CreateDiskReader` (applied to the new handle). |
| `pbAtimeRestored` | `Boolean` | read/write | `archive_read_disk_set_atime_restored`: restore the access time of visited files; the same as the `ARCHIVE_READDISK_RESTORE_ATIME` flag. Setting False clears the flag. |
| `peSymlinkMode` | `Integer` | read/write | `archive_read_disk_set_symlink_physical` / `_logical` / `_hybrid`: `ARCHIVE_SYMLINK_*`. Can be set before `CreateDiskReader`. |
| `phoEntry` | `Handle` | read | `cArchiveEntry` object wrapping the entry `NextHeader` returned (borrowed). |
| `piCurrentFilesystemId` | `Integer` | read | `archive_read_disk_current_filesystem`: id of the file system of the current entry; negative when unknown (valid after `NextHeader`). |
| `pbCurrentFilesystemIsSynthetic` | `Boolean` | read | `archive_read_disk_current_filesystem_is_synthetic`: True for a synthetic file system (like proc); False when not or unknown. |
| `pbCurrentFilesystemIsRemote` | `Boolean` | read | `archive_read_disk_current_filesystem_is_remote`: True for a remote file system; False when not or unknown. |
| `pbRaiseErrors`, `piLastResult`, `psLastError`, `piErrorNumber`, `psErrorString`, ... | | | Inherited from [cArchiveBase](cArchiveBase.md). |

## Methods

| Method | Description | libarchive function |
|---|---|---|
| `Procedure CreateDiskReader` | Frees the previous handle and creates a read disk handle; applies `piBehaviorFlags` and `peSymlinkMode`. | `archive_read_disk_new` |
| `Procedure CloseDiskReader` | Ends the traversal, keeps the handle and its settings (so `OpenDisk` can start another traversal). | `archive_read_close` |
| `Procedure FreeHandle` | Frees the handle. | `archive_read_free` |
| `Function OpenDisk String sPath Returns Integer` | Starts the traversal of a file or folder (wide path). | `archive_read_disk_open_w` |
| `Function NextHeader Returns Integer` | Returns the next entry in `phoEntry`; `ARCHIVE_EOF` at the end. | `archive_read_next_header` |
| `Function Descend Returns Integer` | Enters the folder `NextHeader` returned last. Ignored for files. | `archive_read_disk_descend` |
| `Function CanDescend Returns Boolean` | True when the current entry is a folder that `Descend` can enter. | `archive_read_disk_can_descend` |
| `Function EntryFromFile Handle hoEntry String sFileName Returns Integer` | Fills a `cArchiveEntry` with the metadata of a file; sets its path name and source path first. Creates the entry when `hoEntry` has none. No traversal needed. | `archive_read_disk_entry_from_file` |
| `Function SetMatching Handle hoMatch Returns Integer` | Excludes the entries an archive_match object ([cArchiveMatch](cArchiveMatch.md); any object with the match handle in `ppArchive`) selects; 0 removes the matching. | `archive_read_disk_set_matching` |
| `Function SetStandardLookup Returns Integer` | Installs the standard user/group name lookup; fails on Windows (see Notes). | `archive_read_disk_set_standard_lookup` |
| `Function UserName BigInt iUserId Returns String` | User name for an id with the installed lookup; "" when unknown. | `archive_read_disk_uname` |
| `Function GroupName BigInt iGroupId Returns String` | Group name for an id with the installed lookup; "" when unknown. | `archive_read_disk_gname` |
| `Function EntryInfo Returns tArchiveEntryInfo` | Summary (path, size, mtime, type, permissions) of the current entry. | `archive_entry_*` |
| `Function ReadData Integer iMaxBytes Returns UChar[]` | Reads up to `iMaxBytes` bytes of the current file. | `archive_read_data` |
| `Function ReadAllData UChar[] ByRef ucData Returns Integer` | Reads the remaining data of the current file. | `archive_read_data` |
| `Function ReadDataToString Returns String` | The remaining data as a binary safe string. | `archive_read_data` |
| `Function ReadDataBlock BigInt ByRef iOffset UChar[] ByRef ucData Returns Integer` | Next data block and its offset. | `archive_read_data_block` |
| `Function DataToFile String sFileName Returns Integer` | Copies the remaining data of the current file to another file (created or replaced) through libarchive's disk writer. The folder of the file must exist. | `archive_read_data_block`, `archive_write_disk_*` |
| `Function ListFolder String sFolder Returns tArchiveEntryInfo[]` | Lists a folder tree recursively: the folder itself, then every file and sub folder. Uses the handle of the object (created when missing; settings and matching are kept) and closes the traversal afterwards. Empty when the folder does not exist. | `archive_read_disk_open_w`, `archive_read_next_header`, `archive_read_disk_descend` |

## Examples

List a folder tree:

```
Object oDisk is a cArchiveDiskReader
End_Object

tArchiveEntryInfo[] aEntries
Integer iIndex
Get ListFolder of oDisk "C:\data" to aEntries
For iIndex from 0 to (SizeOfArray (aEntries) - 1)
    Showln aEntries[iIndex].sPathname aEntries[iIndex].iSize
Loop
```

Walk the tree yourself and read the files:

```
Handle hoEntry
Integer iResult
UChar[] ucData
Send CreateDiskReader of oDisk
Get OpenDisk of oDisk "C:\data" to iResult
Get phoEntry of oDisk to hoEntry
Get NextHeader of oDisk to iResult
While (iResult = ARCHIVE_OK)
    Get CanDescend of oDisk to bCanDescend
    If (bCanDescend) Begin
        Get Descend of oDisk to iResult          // enter the folder
    End
    Else Begin
        Get ReadAllData of oDisk (&ucData) to iResult
        Get psPathname of hoEntry to sPathname
        Showln sPathname (SizeOfArray (ucData))
    End
    Get NextHeader of oDisk to iResult
Loop
Send FreeHandle of oDisk
```

Skip files with a match object and do not touch the access times:

```
Set piBehaviorFlags of oDisk to ARCHIVE_READDISK_RESTORE_ATIME
Send CreateDiskReader of oDisk
Get SetMatching of oDisk oMatch to iResult       // oMatch excludes "*.log"
Get ListFolder of oDisk "C:\data" to aEntries
```

Read the metadata of one file:

```
Handle hoEntry
Get CreateNamed (RefClass (cArchiveEntry)) "oArchiveEntry" to hoEntry
Send CreateDiskReader of oDisk
Get EntryFromFile of oDisk hoEntry "C:\data\report.pdf" to iResult
Get ppEntry of hoEntry to pEntry
Showln (archive_entry_size (pEntry))
```
