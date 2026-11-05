# ArchiveReadDisk.h.pkg

Functions to read files and folders from the local file system as archive entries (archive_read_disk_*).

Source: `Library/AppSrc/ArchiveReadDisk.h.pkg`. All functions are declared with `External_Function <name> "<export>" archive.dll`; the DataFlex name equals the DLL export unless noted. Pointers to libarchive objects are `Pointer`; strings are passed as `Pointer` to a NUL terminated string (`AddressOf (sValue)`) and returned as `Pointer` (use `PointerToString`).

## Index

- [`archive_read_disk_new`](#archive_read_disk_new)
- [`archive_read_disk_open`](#archive_read_disk_open)
- [`archive_read_disk_open_w`](#archive_read_disk_open_w)
- [`archive_read_disk_descend`](#archive_read_disk_descend)
- [`archive_read_disk_can_descend`](#archive_read_disk_can_descend)
- [`archive_read_disk_entry_from_file`](#archive_read_disk_entry_from_file)
- [`archive_read_disk_set_behavior`](#archive_read_disk_set_behavior)
- [`archive_read_disk_set_atime_restored`](#archive_read_disk_set_atime_restored)
- [`archive_read_disk_set_symlink_logical`](#archive_read_disk_set_symlink_logical)
- [`archive_read_disk_set_symlink_physical`](#archive_read_disk_set_symlink_physical)
- [`archive_read_disk_set_symlink_hybrid`](#archive_read_disk_set_symlink_hybrid)
- [`archive_read_disk_set_standard_lookup`](#archive_read_disk_set_standard_lookup)
- [`archive_read_disk_set_gname_lookup`](#archive_read_disk_set_gname_lookup)
- [`archive_read_disk_set_uname_lookup`](#archive_read_disk_set_uname_lookup)
- [`archive_read_disk_gname`](#archive_read_disk_gname)
- [`archive_read_disk_uname`](#archive_read_disk_uname)
- [`archive_read_disk_set_matching`](#archive_read_disk_set_matching)
- [`archive_read_disk_set_metadata_filter_callback`](#archive_read_disk_set_metadata_filter_callback)
- [`archive_read_disk_current_filesystem`](#archive_read_disk_current_filesystem)
- [`archive_read_disk_current_filesystem_is_synthetic`](#archive_read_disk_current_filesystem_is_synthetic)
- [`archive_read_disk_current_filesystem_is_remote`](#archive_read_disk_current_filesystem_is_remote)

## Reference

#### archive_read_disk_new

```
Pointer archive_read_disk_new ()
```

is a crucial function in the libarchive library, serving as the entry point for creating a new libarchive read handle specifically designed for reading metadata and data directly from the local filesystem (disk).

Returns: `Pointer`

#### archive_read_disk_open

```
Integer archive_read_disk_open (Pointer pArchive, Pointer pPath)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_read_disk_open_w` instead. The wrapper classes do not call this function.

Is used when you want to read information directly from the file system (i.e., disk) rather than from an archive file. This is particularly useful when you're trying to create an archive from a directory or a set of files on your local system, or when you need to inspect the metadata of files on disk.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPath` | `Pointer` |

> **Note:** The narrow path is interpreted in the ANSI code page. A path with a trailing backslash fails (a drive root like C:\ works).

Returns: `Integer`

#### archive_read_disk_open_w

```
Integer archive_read_disk_open_w (Pointer pArchive, Pointer pPath)
```

Starts a traversal of the file or directory tree at the wide (UTF-16, WString) path.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPath` | `Pointer` |

> **Note:** A path with a trailing backslash fails (a drive root like C:\ works).

Returns: `Integer`

#### archive_read_disk_descend

```
Integer archive_read_disk_descend (Pointer pArchive)
```

Requests that the directory returned by the last archive_read_next_header is entered. Ignored for entries that are not directories.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_can_descend

```
Integer archive_read_disk_can_descend (Pointer pArchive)
```

Returns 1 when the current entry is a directory that can be descended into, otherwise 0.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_entry_from_file

```
Integer archive_read_disk_entry_from_file (Pointer pArchive, Pointer pEntry, Integer iFileDescriptor, Pointer pStat)
```

Fills an archive_entry (whose pathname or sourcepath must be set) with the metadata of the file. iFileDescriptor can be -1 and pStat can be 0.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |
| `iFileDescriptor` | `Integer` |
| `pStat` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_set_behavior

```
Integer archive_read_disk_set_behavior (Pointer pArchive, Integer iFlags)
```

is a function in the libarchive library that allows you to configure various specific behaviors when archive_read_disk is traversing the local filesystem. Instead of a single flag,

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlags` | `Integer` |

Returns: `Integer`

#### archive_read_disk_set_atime_restored

```
Integer archive_read_disk_set_atime_restored (Pointer pArchive)
```

Requests that the access time of visited entries is restored (same as ARCHIVE_READDISK_RESTORE_ATIME).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_set_symlink_logical

```
Integer archive_read_disk_set_symlink_logical (Pointer pArchive)
```

is a function in libarchive that controls how archive_read_disk handles symbolic links (symlinks) when reading files from the disk.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_set_symlink_physical

```
Integer archive_read_disk_set_symlink_physical (Pointer pArchive)
```

is a function within the libarchive library that dictates how the archive_read_disk component handles symbolic links (symlinks) encountered while reading files and directories directly from the local filesystem.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_set_symlink_hybrid

```
Integer archive_read_disk_set_symlink_hybrid (Pointer pArchive)
```

Follow symlink initially, then not.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_set_standard_lookup

```
Integer archive_read_disk_set_standard_lookup (Pointer pArchive)
```

is a convenience function in the libarchive library that configures an archive_read_disk object to use standard system mechanisms for looking up user and group names from their IDs (UIDs and GIDs), and vice-versa.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Returns ARCHIVE_FATAL on Windows ("Standard lookups not available on Windows"); archive_read_disk_uname / _gname then return 0.

Returns: `Integer`

#### archive_read_disk_set_gname_lookup

```
Integer archive_read_disk_set_gname_lookup (Pointer pArchive, Pointer pPrivateData, Pointer pLookupFunc, Pointer pCleanupFunc)
```

Installs a custom group name lookup (const char *(*)(void*, la_int64_t)). Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPrivateData` | `Pointer` |
| `pLookupFunc` | `Pointer` |
| `pCleanupFunc` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_set_uname_lookup

```
Integer archive_read_disk_set_uname_lookup (Pointer pArchive, Pointer pPrivateData, Pointer pLookupFunc, Pointer pCleanupFunc)
```

Installs a custom user name lookup (const char *(*)(void*, la_int64_t)). Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPrivateData` | `Pointer` |
| `pLookupFunc` | `Pointer` |
| `pCleanupFunc` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_gname

```
Pointer archive_read_disk_gname (Pointer pArchive, BigInt iGroupId)
```

Pointer to the group name for a group id using the installed lookup, or 0.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iGroupId` | `BigInt` |

Returns: `Pointer`

#### archive_read_disk_uname

```
Pointer archive_read_disk_uname (Pointer pArchive, BigInt iUserId)
```

Pointer to the user name for a user id using the installed lookup, or 0.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iUserId` | `BigInt` |

Returns: `Pointer`

#### archive_read_disk_set_matching

```
Integer archive_read_disk_set_matching (Pointer pArchive, Pointer pMatchArchive, Pointer pExcludedFunc, Pointer pClientData)
```

Sets an archive_match object that decides which entries are skipped. The callback is optional (0). Needs a native function pointer when used.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pMatchArchive` | `Pointer` |
| `pExcludedFunc` | `Pointer` |
| `pClientData` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_set_metadata_filter_callback

```
Integer archive_read_disk_set_metadata_filter_callback (Pointer pArchive, Pointer pFilterFunc, Pointer pClientData)
```

Sets a callback that decides per entry whether it is included (int (*)(archive*, void*, archive_entry*)). Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFilterFunc` | `Pointer` |
| `pClientData` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_current_filesystem

```
Integer archive_read_disk_current_filesystem (Pointer pArchive)
```

Returns the id of the file system the current entry lives on.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_disk_current_filesystem_is_synthetic

```
Integer archive_read_disk_current_filesystem_is_synthetic (Pointer pArchive)
```

Returns 1 when the current file system is synthetic (like proc), 0 when not, ARCHIVE_FAILED when unknown.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Returns -1 when the answer is not available.

Returns: `Integer`

#### archive_read_disk_current_filesystem_is_remote

```
Integer archive_read_disk_current_filesystem_is_remote (Pointer pArchive)
```

Returns 1 when the current file system is remote, 0 when not, ARCHIVE_FAILED when unknown.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`
