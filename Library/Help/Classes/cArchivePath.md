# cArchivePath

`Use ArchivePath.pkg` — `Class cArchivePath is a cObject`

File system helpers of the library. They are methods of one class, so the library adds no global function to an application. They use libarchive and DataFlex file I/O only; no Windows API is called.

The library classes create their own `cArchivePath` object the first time they need one (`PathTools` of `cArchiveBase` and `cFilesArchiver`; the object is a child of the owner and is destroyed with it). An application can create one too:

```
Handle hoPath
Boolean bIsFolder
Get CreateNamed (RefClass (cArchivePath)) "oArchivePath" to hoPath
Get IsPhysicalFolder of hoPath "C:\Temp" to bIsFolder
```

## Methods

| Method | Description | Based on |
|---|---|---|
| `Function SplitDelimited String sValue String sDelimiter Returns String[]` | Splits at every delimiter; empty parts are kept, an empty value gives an empty array. | |
| `Function DirectoryPart String sPath Returns String` | Folder part including the native separator at the end, "" when there is none. | `SysConf` |
| `Function FileNamePart String sPath Returns String` | Everything after the last native separator. | `SysConf` |
| `Function ReadDiskFileInfo String sPath Boolean bFollowLinks UShort ByRef eFileType BigInt ByRef biSize BigInt ByRef biModificationTime Integer ByRef iModificationNano Returns Boolean` | Type (`AE_IFREG`, `AE_IFDIR`, `AE_IFLNK`, ...), size and modification time of a file. `bFollowLinks` reports a symbolic link as the file it points to. False when the file cannot be read. | `archive_read_disk_entry_from_file` |
| `Function IsPhysicalFolder String sPath Returns Boolean` | True for a folder; a symbolic link to a folder is not. | `archive_read_disk_*` |
| `Function IsFolder String sPath Returns Boolean` | True for a folder or a symbolic link that points to one. | `archive_read_disk_*` |
| `Function ModificationTime String sPath Returns BigInt` | Seconds since 1970-01-01 UTC, 0 when it cannot be read. | `archive_read_disk_*` |
| `Function NativePath String sPath Returns String` | Converts `/` to the native separator where `\` is the separator (Windows); nothing is changed elsewhere. | `SysConf` |
| `Function CreateFolder String sPath Returns Boolean` | Creates the folder and its missing parents; True when it exists afterwards. | `archive_write_disk_*` |
| `Function ListFolderContent String sFolder String[] ByRef asNames Boolean[] ByRef abFolders Returns Boolean` | Names in a folder (`sFolder` ends with the native separator), folders flagged in `abFolders`. Symbolic links and junctions that point to a folder are left out. False when the folder cannot be listed. | `DIR:` device |
| `Function CurrentUnixTime Returns BigInt` | Current UTC time as seconds since 1970-01-01. DataFlex only has the local clock, so libarchive's `archive_match` object, which remembers the time it was created at, is bisected. | `archive_match_include_date` |
| `Function AbsoluteNativePath String sPath Returns String` | Absolute, lexically normalized native path ("..", "." and doubled separators resolved, relative paths taken from the current folder). "" for an empty path, a path that climbs above the root and drive-relative Windows paths (`C:file`). | `Get_Current_Directory` |
