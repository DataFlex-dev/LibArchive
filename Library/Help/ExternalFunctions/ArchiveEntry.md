# ArchiveEntry.h.pkg

Functions to create and query archive entries (archive_entry_*): metadata, ACLs, xattrs, sparse maps and the hard link resolver.

Source: `Library/AppSrc/ArchiveEntry.h.pkg`. All functions are declared with `External_Function <name> "<export>" archive.dll`; the DataFlex name equals the DLL export unless noted. Pointers to libarchive objects are `Pointer`; strings are passed as `Pointer` to a NUL terminated string (`AddressOf (sValue)`) and returned as `Pointer` (use `PointerToString`).

## Index


**Life cycle**

- [`archive_entry_new`](#archive_entry_new)
- [`archive_entry_new2`](#archive_entry_new2)
- [`archive_entry_clear`](#archive_entry_clear)
- [`archive_entry_clone`](#archive_entry_clone)
- [`archive_entry_free`](#archive_entry_free)

**Timestamps (time_t = 64 bit, nanoseconds = C long = 32 bit on Windows)**

- [`archive_entry_atime`](#archive_entry_atime)
- [`archive_entry_atime_nsec`](#archive_entry_atime_nsec)
- [`archive_entry_atime_is_set`](#archive_entry_atime_is_set)
- [`archive_entry_birthtime`](#archive_entry_birthtime)
- [`archive_entry_birthtime_nsec`](#archive_entry_birthtime_nsec)
- [`archive_entry_birthtime_is_set`](#archive_entry_birthtime_is_set)
- [`archive_entry_ctime`](#archive_entry_ctime)
- [`archive_entry_ctime_nsec`](#archive_entry_ctime_nsec)
- [`archive_entry_ctime_is_set`](#archive_entry_ctime_is_set)
- [`archive_entry_mtime`](#archive_entry_mtime)
- [`archive_entry_mtime_nsec`](#archive_entry_mtime_nsec)
- [`archive_entry_mtime_is_set`](#archive_entry_mtime_is_set)
- [`archive_entry_set_atime`](#archive_entry_set_atime)
- [`archive_entry_set_birthtime`](#archive_entry_set_birthtime)
- [`archive_entry_set_ctime`](#archive_entry_set_ctime)
- [`archive_entry_unset_atime`](#archive_entry_unset_atime)
- [`archive_entry_unset_birthtime`](#archive_entry_unset_birthtime)
- [`archive_entry_unset_ctime`](#archive_entry_unset_ctime)
- [`archive_entry_unset_mtime`](#archive_entry_unset_mtime)

**Device and inode**

- [`archive_entry_dev`](#archive_entry_dev)
- [`archive_entry_dev_is_set`](#archive_entry_dev_is_set)
- [`archive_entry_devmajor`](#archive_entry_devmajor)
- [`archive_entry_devminor`](#archive_entry_devminor)
- [`archive_entry_ino`](#archive_entry_ino)
- [`archive_entry_ino64`](#archive_entry_ino64)
- [`archive_entry_ino_is_set`](#archive_entry_ino_is_set)
- [`archive_entry_nlink`](#archive_entry_nlink)
- [`archive_entry_rdev`](#archive_entry_rdev)
- [`archive_entry_rdevmajor`](#archive_entry_rdevmajor)
- [`archive_entry_rdevminor`](#archive_entry_rdevminor)
- [`archive_entry_set_dev`](#archive_entry_set_dev)
- [`archive_entry_set_devmajor`](#archive_entry_set_devmajor)
- [`archive_entry_set_devminor`](#archive_entry_set_devminor)
- [`archive_entry_set_ino`](#archive_entry_set_ino)
- [`archive_entry_set_ino64`](#archive_entry_set_ino64)
- [`archive_entry_set_nlink`](#archive_entry_set_nlink)
- [`archive_entry_set_rdev`](#archive_entry_set_rdev)
- [`archive_entry_set_rdevmajor`](#archive_entry_set_rdevmajor)
- [`archive_entry_set_rdevminor`](#archive_entry_set_rdevminor)

**Mode, type and size**

- [`archive_entry_filetype`](#archive_entry_filetype)
- [`archive_entry_mode`](#archive_entry_mode)
- [`archive_entry_perm`](#archive_entry_perm)
- [`archive_entry_strmode`](#archive_entry_strmode)
- [`archive_entry_size`](#archive_entry_size)
- [`archive_entry_size_is_set`](#archive_entry_size_is_set)
- [`archive_entry_unset_size`](#archive_entry_unset_size)
- [`archive_entry_is_data_encrypted`](#archive_entry_is_data_encrypted)
- [`archive_entry_is_metadata_encrypted`](#archive_entry_is_metadata_encrypted)
- [`archive_entry_is_encrypted`](#archive_entry_is_encrypted)
- [`archive_entry_set_mode`](#archive_entry_set_mode)
- [`archive_entry_set_perm`](#archive_entry_set_perm)
- [`archive_entry_set_filetype`](#archive_entry_set_filetype)
- [`archive_entry_set_size`](#archive_entry_set_size)
- [`archive_entry_set_is_data_encrypted`](#archive_entry_set_is_data_encrypted)
- [`archive_entry_set_is_metadata_encrypted`](#archive_entry_set_is_metadata_encrypted)

**Owner**

- [`archive_entry_uid`](#archive_entry_uid)
- [`archive_entry_gid`](#archive_entry_gid)
- [`archive_entry_uname`](#archive_entry_uname)
- [`archive_entry_uname_utf8`](#archive_entry_uname_utf8)
- [`archive_entry_uname_w`](#archive_entry_uname_w)
- [`archive_entry_gname`](#archive_entry_gname)
- [`archive_entry_gname_utf8`](#archive_entry_gname_utf8)
- [`archive_entry_gname_w`](#archive_entry_gname_w)
- [`archive_entry_set_uid`](#archive_entry_set_uid)
- [`archive_entry_set_gid`](#archive_entry_set_gid)
- [`archive_entry_set_uname`](#archive_entry_set_uname)
- [`archive_entry_set_uname_utf8`](#archive_entry_set_uname_utf8)
- [`archive_entry_copy_uname`](#archive_entry_copy_uname)
- [`archive_entry_copy_uname_w`](#archive_entry_copy_uname_w)
- [`archive_entry_update_uname_utf8`](#archive_entry_update_uname_utf8)
- [`archive_entry_set_gname`](#archive_entry_set_gname)
- [`archive_entry_set_gname_utf8`](#archive_entry_set_gname_utf8)
- [`archive_entry_copy_gname`](#archive_entry_copy_gname)
- [`archive_entry_copy_gname_w`](#archive_entry_copy_gname_w)
- [`archive_entry_update_gname_utf8`](#archive_entry_update_gname_utf8)

**Path names**

- [`archive_entry_pathname`](#archive_entry_pathname)
- [`archive_entry_pathname_utf8`](#archive_entry_pathname_utf8)
- [`archive_entry_pathname_w`](#archive_entry_pathname_w)
- [`archive_entry_sourcepath`](#archive_entry_sourcepath)
- [`archive_entry_sourcepath_w`](#archive_entry_sourcepath_w)
- [`archive_entry_set_pathname`](#archive_entry_set_pathname)
- [`archive_entry_set_pathname_utf8`](#archive_entry_set_pathname_utf8)
- [`archive_entry_copy_pathname`](#archive_entry_copy_pathname)
- [`archive_entry_copy_pathname_w`](#archive_entry_copy_pathname_w)
- [`archive_entry_update_pathname_utf8`](#archive_entry_update_pathname_utf8)
- [`archive_entry_copy_sourcepath`](#archive_entry_copy_sourcepath)
- [`archive_entry_copy_sourcepath_w`](#archive_entry_copy_sourcepath_w)

**Hard links and symbolic links**

- [`archive_entry_hardlink`](#archive_entry_hardlink)
- [`archive_entry_hardlink_utf8`](#archive_entry_hardlink_utf8)
- [`archive_entry_hardlink_w`](#archive_entry_hardlink_w)
- [`archive_entry_hardlink_is_set`](#archive_entry_hardlink_is_set)
- [`archive_entry_symlink`](#archive_entry_symlink)
- [`archive_entry_symlink_utf8`](#archive_entry_symlink_utf8)
- [`archive_entry_symlink_w`](#archive_entry_symlink_w)
- [`archive_entry_symlink_type`](#archive_entry_symlink_type)
- [`archive_entry_set_hardlink`](#archive_entry_set_hardlink)
- [`archive_entry_set_hardlink_utf8`](#archive_entry_set_hardlink_utf8)
- [`archive_entry_copy_hardlink`](#archive_entry_copy_hardlink)
- [`archive_entry_copy_hardlink_w`](#archive_entry_copy_hardlink_w)
- [`archive_entry_update_hardlink_utf8`](#archive_entry_update_hardlink_utf8)
- [`archive_entry_set_symlink`](#archive_entry_set_symlink)
- [`archive_entry_set_symlink_utf8`](#archive_entry_set_symlink_utf8)
- [`archive_entry_set_symlink_type`](#archive_entry_set_symlink_type)
- [`archive_entry_copy_symlink`](#archive_entry_copy_symlink)
- [`archive_entry_copy_symlink_w`](#archive_entry_copy_symlink_w)
- [`archive_entry_update_symlink_utf8`](#archive_entry_update_symlink_utf8)
- [`archive_entry_set_link`](#archive_entry_set_link)
- [`archive_entry_set_link_utf8`](#archive_entry_set_link_utf8)
- [`archive_entry_copy_link`](#archive_entry_copy_link)
- [`archive_entry_copy_link_w`](#archive_entry_copy_link_w)
- [`archive_entry_update_link_utf8`](#archive_entry_update_link_utf8)
- [`archive_entry_set_link_to_hardlink`](#archive_entry_set_link_to_hardlink)
- [`archive_entry_set_link_to_symlink`](#archive_entry_set_link_to_symlink)

**File flags**

- [`archive_entry_fflags`](#archive_entry_fflags)
- [`archive_entry_fflags_text`](#archive_entry_fflags_text)
- [`archive_entry_set_fflags`](#archive_entry_set_fflags)
- [`archive_entry_copy_fflags_text`](#archive_entry_copy_fflags_text)
- [`archive_entry_copy_fflags_text_len`](#archive_entry_copy_fflags_text_len)
- [`archive_entry_copy_fflags_text_w`](#archive_entry_copy_fflags_text_w)

**stat and platform data**

- [`archive_entry_stat`](#archive_entry_stat)
- [`archive_entry_copy_stat`](#archive_entry_copy_stat)
- [`archive_entry_copy_bhfi`](#archive_entry_copy_bhfi)
- [`archive_entry_mac_metadata`](#archive_entry_mac_metadata)
- [`archive_entry_copy_mac_metadata`](#archive_entry_copy_mac_metadata)
- [`archive_entry_digest`](#archive_entry_digest)

**ACL**

- [`archive_entry_acl`](#archive_entry_acl)
- [`archive_entry_acl_clear`](#archive_entry_acl_clear)
- [`archive_entry_acl_add_entry`](#archive_entry_acl_add_entry)
- [`archive_entry_acl_add_entry_w`](#archive_entry_acl_add_entry_w)
- [`archive_entry_acl_reset`](#archive_entry_acl_reset)
- [`archive_entry_acl_next`](#archive_entry_acl_next)
- [`archive_entry_acl_count`](#archive_entry_acl_count)
- [`archive_entry_acl_types`](#archive_entry_acl_types)
- [`archive_entry_acl_to_text`](#archive_entry_acl_to_text)
- [`archive_entry_acl_to_text_w`](#archive_entry_acl_to_text_w)
- [`archive_entry_acl_from_text`](#archive_entry_acl_from_text)
- [`archive_entry_acl_from_text_w`](#archive_entry_acl_from_text_w)
- [`archive_entry_acl_text`](#archive_entry_acl_text)
- [`archive_entry_acl_text_w`](#archive_entry_acl_text_w)

**Extended attributes**

- [`archive_entry_xattr_clear`](#archive_entry_xattr_clear)
- [`archive_entry_xattr_add_entry`](#archive_entry_xattr_add_entry)
- [`archive_entry_xattr_count`](#archive_entry_xattr_count)
- [`archive_entry_xattr_reset`](#archive_entry_xattr_reset)
- [`archive_entry_xattr_next`](#archive_entry_xattr_next)

**Sparse regions**

- [`archive_entry_sparse_clear`](#archive_entry_sparse_clear)
- [`archive_entry_sparse_add_entry`](#archive_entry_sparse_add_entry)
- [`archive_entry_sparse_count`](#archive_entry_sparse_count)
- [`archive_entry_sparse_reset`](#archive_entry_sparse_reset)
- [`archive_entry_sparse_next`](#archive_entry_sparse_next)

**Hard link resolver**

- [`archive_entry_linkresolver_new`](#archive_entry_linkresolver_new)
- [`archive_entry_linkresolver_set_strategy`](#archive_entry_linkresolver_set_strategy)
- [`archive_entry_linkresolver_free`](#archive_entry_linkresolver_free)
- [`archive_entry_linkify`](#archive_entry_linkify)
- [`archive_entry_partial_links`](#archive_entry_partial_links)

**Is-set queries added after the shipped 3.6.1 header (libarchive 3.7.x)**

- [`archive_entry_filetype_is_set`](#archive_entry_filetype_is_set)
- [`archive_entry_perm_is_set`](#archive_entry_perm_is_set)
- [`archive_entry_uid_is_set`](#archive_entry_uid_is_set)
- [`archive_entry_gid_is_set`](#archive_entry_gid_is_set)
- [`archive_entry_rdev_is_set`](#archive_entry_rdev_is_set)

**Time setter documented in the original declarations**

- [`archive_entry_set_mtime`](#archive_entry_set_mtime)

## Reference

### Life cycle

#### archive_entry_new

```
Pointer archive_entry_new ()
```

A function that allocates and returns a new, empty archive entry object.

An archive_entry object represents a single file or directory within an archive. It holds metadata about the entry, such as its pathname, permissions, ownership, timestamps, and size.

Allocation: It allocates memory for a new struct archive_entry.
Initialization: It initializes the fields of this new entry object to default or empty values.
After obtaining a new archive entry using archive_entry_new(), you would typically use other archive_entry_ functions to populate its metadata. For example:

archive_entry_set_pathname(): Sets the name of the entry.
archive_entry_set_mode(): Sets the file type and permissions.
archive_entry_set_size(): Sets the size of the file data.
archive_entry_set_mtime(): Sets the last modification time.
and many others.
When you are finished with an archive_entry object, you should free its associated memory using archive_entry_free().

Returns: `Pointer`

#### archive_entry_new2

```
Pointer archive_entry_new2 (Pointer pArchive)
```

Allocates a new archive_entry that takes its character set conversion settings from the given archive handle.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Pointer`

#### archive_entry_clear

```
Pointer archive_entry_clear (Pointer pEntry)
```

Resets all fields of the entry to their defaults and returns the same pointer.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_clone

```
Pointer archive_entry_clone (Pointer pEntry)
```

Creates a deep copy of the entry (all strings are copied). Free the clone with archive_entry_free.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_free

```
Void_Type archive_entry_free (Pointer pEntry)
```

The function archive_entry_free() in libarchive is a void function — it does not return any value.
Always free entries you allocate with archive_entry_new() to avoid memory leaks, especially when writing many files in a loop.
What is does:
- Frees the memory associated with an archive_entry Object.
- Safe to call on a NULL Pointer (no-op).
- No return value; there's no success/failure result to check.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

### Timestamps (time_t = 64 bit, nanoseconds = C long = 32 bit on Windows)

#### archive_entry_atime

```
BigInt archive_entry_atime (Pointer pEntry)
```

Provides functions for manipulating archive entries (like tar or cpio files). This specific function retrieves the last access time of a file entry in the archive.
Represents absolute time in seconds since the epoch.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_atime_nsec

```
Integer archive_entry_atime_nsec (Pointer pEntry)
```

Provides functions for manipulating archive entries (like tar or cpio files). This specific function retrieves the last access time of a file entry in the archive in nanoseconds.
Represents absolute time in nanoseconds since the epoch.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_atime_is_set

```
Integer archive_entry_atime_is_set (Pointer pEntry)
```

1 when the access time is set, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_birthtime

```
BigInt archive_entry_birthtime (Pointer pEntry)
```

Creation time in seconds since 1970-01-01 UTC.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_birthtime_nsec

```
Integer archive_entry_birthtime_nsec (Pointer pEntry)
```

Nanosecond part of the creation time.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_birthtime_is_set

```
Integer archive_entry_birthtime_is_set (Pointer pEntry)
```

1 when the creation time is set, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_ctime

```
BigInt archive_entry_ctime (Pointer pEntry)
```

Inode change time in seconds since 1970-01-01 UTC.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_ctime_nsec

```
Integer archive_entry_ctime_nsec (Pointer pEntry)
```

Nanosecond part of the inode change time.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_ctime_is_set

```
Integer archive_entry_ctime_is_set (Pointer pEntry)
```

1 when the inode change time is set, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_mtime

```
BigInt archive_entry_mtime (Pointer pEntry)
```

Last modification time in seconds since 1970-01-01 UTC.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_mtime_nsec

```
Integer archive_entry_mtime_nsec (Pointer pEntry)
```

Nanosecond part of the last modification time.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_mtime_is_set

```
Integer archive_entry_mtime_is_set (Pointer pEntry)
```

1 when the modification time is set, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_set_atime

```
Void_Type archive_entry_set_atime (Pointer pEntry, BigInt iSeconds, Integer iNanoSeconds)
```

Sets the last access time.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iSeconds` | `BigInt` |
| `iNanoSeconds` | `Integer` |

Returns: `Void_Type`

#### archive_entry_set_birthtime

```
Void_Type archive_entry_set_birthtime (Pointer pEntry, BigInt iSeconds, Integer iNanoSeconds)
```

Sets the creation time.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iSeconds` | `BigInt` |
| `iNanoSeconds` | `Integer` |

Returns: `Void_Type`

#### archive_entry_set_ctime

```
Void_Type archive_entry_set_ctime (Pointer pEntry, BigInt iSeconds, Integer iNanoSeconds)
```

Sets the inode change time.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iSeconds` | `BigInt` |
| `iNanoSeconds` | `Integer` |

Returns: `Void_Type`

#### archive_entry_unset_atime

```
Void_Type archive_entry_unset_atime (Pointer pEntry)
```

Marks the access time as not set.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_unset_birthtime

```
Void_Type archive_entry_unset_birthtime (Pointer pEntry)
```

Marks the creation time as not set.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_unset_ctime

```
Void_Type archive_entry_unset_ctime (Pointer pEntry)
```

Marks the inode change time as not set.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_unset_mtime

```
Void_Type archive_entry_unset_mtime (Pointer pEntry)
```

Marks the modification time as not set.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

### Device and inode

#### archive_entry_dev

```
UInteger archive_entry_dev (Pointer pEntry)
```

Device number of the file.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UInteger`

#### archive_entry_dev_is_set

```
Integer archive_entry_dev_is_set (Pointer pEntry)
```

1 when the device number is set, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_devmajor

```
UInteger archive_entry_devmajor (Pointer pEntry)
```

Major part of the device number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UInteger`

#### archive_entry_devminor

```
UInteger archive_entry_devminor (Pointer pEntry)
```

Minor part of the device number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UInteger`

#### archive_entry_ino

```
BigInt archive_entry_ino (Pointer pEntry)
```

Inode number (truncated to 32 bit on some platforms; prefer archive_entry_ino64).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_ino64

```
BigInt archive_entry_ino64 (Pointer pEntry)
```

Inode number as a 64 bit value.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_ino_is_set

```
Integer archive_entry_ino_is_set (Pointer pEntry)
```

1 when the inode number is set, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_nlink

```
UInteger archive_entry_nlink (Pointer pEntry)
```

Number of hard links to the file.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UInteger`

#### archive_entry_rdev

```
UInteger archive_entry_rdev (Pointer pEntry)
```

Device number of a character or block device entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UInteger`

#### archive_entry_rdevmajor

```
UInteger archive_entry_rdevmajor (Pointer pEntry)
```

Major part of the rdev number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UInteger`

#### archive_entry_rdevminor

```
UInteger archive_entry_rdevminor (Pointer pEntry)
```

Minor part of the rdev number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UInteger`

#### archive_entry_set_dev

```
Void_Type archive_entry_set_dev (Pointer pEntry, UInteger iDevice)
```

Sets the device number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iDevice` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_set_devmajor

```
Void_Type archive_entry_set_devmajor (Pointer pEntry, UInteger iDeviceMajor)
```

Sets the major part of the device number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iDeviceMajor` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_set_devminor

```
Void_Type archive_entry_set_devminor (Pointer pEntry, UInteger iDeviceMinor)
```

Sets the minor part of the device number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iDeviceMinor` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_set_ino

```
Void_Type archive_entry_set_ino (Pointer pEntry, BigInt iInode)
```

Sets the inode number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iInode` | `BigInt` |

Returns: `Void_Type`

#### archive_entry_set_ino64

```
Void_Type archive_entry_set_ino64 (Pointer pEntry, BigInt iInode)
```

Sets the inode number as a 64 bit value.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iInode` | `BigInt` |

Returns: `Void_Type`

#### archive_entry_set_nlink

```
Void_Type archive_entry_set_nlink (Pointer pEntry, UInteger iLinkCount)
```

Sets the number of hard links.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iLinkCount` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_set_rdev

```
Void_Type archive_entry_set_rdev (Pointer pEntry, UInteger iDevice)
```

Sets the rdev number of a character or block device entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iDevice` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_set_rdevmajor

```
Void_Type archive_entry_set_rdevmajor (Pointer pEntry, UInteger iDeviceMajor)
```

Sets the major part of the rdev number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iDeviceMajor` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_set_rdevminor

```
Void_Type archive_entry_set_rdevminor (Pointer pEntry, UInteger iDeviceMinor)
```

Sets the minor part of the rdev number.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iDeviceMinor` | `UInteger` |

Returns: `Void_Type`

### Mode, type and size

#### archive_entry_filetype

```
UShort archive_entry_filetype (Pointer pEntry)
```

File type bits of the mode (AE_IFREG, AE_IFDIR, AE_IFLNK, ...).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UShort`

#### archive_entry_mode

```
UShort archive_entry_mode (Pointer pEntry)
```

Complete mode: file type bits and permission bits.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UShort`

#### archive_entry_perm

```
UShort archive_entry_perm (Pointer pEntry)
```

Permission bits of the mode (for example 420 = octal 0644).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `UShort`

#### archive_entry_strmode

```
Pointer archive_entry_strmode (Pointer pEntry)
```

Pointer to a 10 character string like "-rw-r--r-- " describing type and permissions. Owned by the entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_size

```
BigInt archive_entry_size (Pointer pEntry)
```

Size of the entry data in bytes.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_size_is_set

```
Integer archive_entry_size_is_set (Pointer pEntry)
```

1 when the size is set, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_unset_size

```
Void_Type archive_entry_unset_size (Pointer pEntry)
```

Marks the size as not set.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_is_data_encrypted

```
Integer archive_entry_is_data_encrypted (Pointer pEntry)
```

1 when the data of the entry is encrypted.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_is_metadata_encrypted

```
Integer archive_entry_is_metadata_encrypted (Pointer pEntry)
```

1 when the metadata (name, times, ...) of the entry is encrypted.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_is_encrypted

```
Integer archive_entry_is_encrypted (Pointer pEntry)
```

1 when the data or the metadata of the entry is encrypted.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_set_mode

```
Void_Type archive_entry_set_mode (Pointer pEntry, Integer iMode)
```

It sets the mode for an entry within an archive. The mode is a combination of the file type (e.g., regular file, directory, symbolic link) and its permissions (read, write, execute for owner, group, and others).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iMode` | `Integer` |

Returns: `Void_Type`

#### archive_entry_set_perm

```
Void_Type archive_entry_set_perm (Pointer pEntry, Integer iPermission)
```

This Function sets the file permissions (the permission bits within the mode_t argument) for the archive entry. It's generally assumed to succeed in setting these permissions. If there were internal issues (like memory allocation problems), they would likely manifest in other ways, but the function itself doesn't return an Error indicator.
Sets the permission bits: archive_entry_set_perm() specifically looks at the permission bits within the provided mode_t value and sets the corresponding permissions for the archive entry. It does not affect the file type bits; for that, you would use functions like archive_entry_set_filetype().

The permission bits in a mode_t value are typically structured as follows (in octal representation):

The last three digits represent permissions for the owner, group, and others, respectively.
Each digit is a sum of bits for read (4), write (2), and execute (1).

For example:

0644 means read/write for owner, read for group, and read for others.
0755 means read/write/execute for owner, read/execute for group, and read/execute for others.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iPermission` | `Integer` |

Returns: `Void_Type`

#### archive_entry_set_filetype

```
Void_Type archive_entry_set_filetype (Pointer pEntry, UInteger iFileType)
```

A function in the libarchive library that sets the file type of an archive entry using a mode_t value.

The mode_t type is typically defined in <sys/types.h> and is used to represent file modes, including the file type and permissions. This function specifically looks at the file type bits within the provided mode_t value.

Here are the common file types that can be set using the bits in the mode_t argument:

AR_IFREG: Regular file
AR_IFDIR: Directory
AR_IFLNK: Symbolic link
AR_IFCHR: Character device
AR_IFBLK: Block device
AR_IFFIFO: FIFO (named pipe)
AR_IFSOCK: Socket

When you call archive_entry_set_filetype(), you pass the archive_entry you want to modify and a mode_t value where the file type bits are set accordingly.

This function sets the file type of the archive entry based on the bits in the provided mode_t value. It's generally assumed to succeed in setting the file type. Internal issues might lead to other problems, but the function itself doesn't return an error code.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iFileType` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_set_size

```
Void_Type archive_entry_set_size (Pointer pEntry, BigInt iSize)
```

A function in the libarchive library that sets the size (in bytes) of the data associated with an archive entry.
This function takes two arguments:
- A pointer to the struct archive_entry object you want to modify.
- A int64 value representing the size of the data. Using int64 allows you to specify large file sizes.
The size set by this function is typically used when writing an archive to indicate how much data will follow for that entry. When reading an archive, this function is usually called internally by libarchive based on the information in the archive header, making the size available through archive_entry_size().
According to the libarchive documentation, this function sets the size of the data associated with the archive entry. It's generally assumed to succeed. Internal memory allocation issues might lead to problems elsewhere, but the function itself doesn't return an error code.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iSize` | `BigInt` |

Returns: `Void_Type`

#### archive_entry_set_is_data_encrypted

```
Void_Type archive_entry_set_is_data_encrypted (Pointer pEntry, Integer iEncrypted)
```

Marks the entry data as encrypted (0 or 1).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iEncrypted` | `Integer` |

Returns: `Void_Type`

#### archive_entry_set_is_metadata_encrypted

```
Void_Type archive_entry_set_is_metadata_encrypted (Pointer pEntry, Integer iEncrypted)
```

Marks the entry metadata as encrypted (0 or 1).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iEncrypted` | `Integer` |

Returns: `Void_Type`

### Owner

#### archive_entry_uid

```
BigInt archive_entry_uid (Pointer pEntry)
```

User id of the owner.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_gid

```
BigInt archive_entry_gid (Pointer pEntry)
```

Group id of the owner.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `BigInt`

#### archive_entry_uname

```
Pointer archive_entry_uname (Pointer pEntry)
```

Pointer to the user name in the current locale (ANSI code page), or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_uname_utf8

```
Pointer archive_entry_uname_utf8 (Pointer pEntry)
```

Pointer to the user name as UTF-8, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_uname_w

```
Pointer archive_entry_uname_w (Pointer pEntry)
```

Pointer to the user name as wide (UTF-16) string, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_gname

```
Pointer archive_entry_gname (Pointer pEntry)
```

Pointer to the group name in the current locale (ANSI code page), or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_gname_utf8

```
Pointer archive_entry_gname_utf8 (Pointer pEntry)
```

Pointer to the group name as UTF-8, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_gname_w

```
Pointer archive_entry_gname_w (Pointer pEntry)
```

Pointer to the group name as wide (UTF-16) string, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_set_uid

```
Void_Type archive_entry_set_uid (Pointer pEntry, BigInt iUserId)
```

Sets the user id of the owner.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iUserId` | `BigInt` |

Returns: `Void_Type`

#### archive_entry_set_gid

```
Void_Type archive_entry_set_gid (Pointer pEntry, BigInt iGroupId)
```

Sets the group id of the owner.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iGroupId` | `BigInt` |

Returns: `Void_Type`

#### archive_entry_set_uname

```
Void_Type archive_entry_set_uname (Pointer pEntry, Pointer pName)
```

Sets the user name (locale string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_set_uname_utf8

```
Void_Type archive_entry_set_uname_utf8 (Pointer pEntry, Pointer pName)
```

Sets the user name (UTF-8 string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_uname

```
Void_Type archive_entry_copy_uname (Pointer pEntry, Pointer pName)
```

Copies the user name (locale string). Same as archive_entry_set_uname.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_uname_w

```
Void_Type archive_entry_copy_uname_w (Pointer pEntry, Pointer pName)
```

Copies the user name (wide string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_update_uname_utf8

```
Integer archive_entry_update_uname_utf8 (Pointer pEntry, Pointer pName)
```

Sets the user name (UTF-8 string); returns 1 on success, 0 when the conversion failed.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

> **Note:** A result of 0 means the text could not be converted to the locale without loss; libarchive keeps the text anyway.

Returns: `Integer`

#### archive_entry_set_gname

```
Void_Type archive_entry_set_gname (Pointer pEntry, Pointer pName)
```

Sets the group name (locale string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_set_gname_utf8

```
Void_Type archive_entry_set_gname_utf8 (Pointer pEntry, Pointer pName)
```

Sets the group name (UTF-8 string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_gname

```
Void_Type archive_entry_copy_gname (Pointer pEntry, Pointer pName)
```

Copies the group name (locale string). Same as archive_entry_set_gname.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_gname_w

```
Void_Type archive_entry_copy_gname_w (Pointer pEntry, Pointer pName)
```

Copies the group name (wide string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_update_gname_utf8

```
Integer archive_entry_update_gname_utf8 (Pointer pEntry, Pointer pName)
```

Sets the group name (UTF-8 string); returns 1 on success, 0 when the conversion failed.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |

> **Note:** A result of 0 means the text could not be converted to the locale without loss; libarchive keeps the text anyway.

Returns: `Integer`

### Path names

#### archive_entry_pathname

```
Pointer archive_entry_pathname (Pointer pEntry)
```

Pointer to the path name in the current locale (ANSI code page), or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_pathname_utf8

```
Pointer archive_entry_pathname_utf8 (Pointer pEntry)
```

Pointer to the path name as UTF-8, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_pathname_w

```
Pointer archive_entry_pathname_w (Pointer pEntry)
```

Pointer to the path name as wide (UTF-16) string, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_sourcepath

```
Pointer archive_entry_sourcepath (Pointer pEntry)
```

Pointer to the path of the file on disk the entry was created from (read disk), or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_sourcepath_w

```
Pointer archive_entry_sourcepath_w (Pointer pEntry)
```

Wide string variant of archive_entry_sourcepath.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_set_pathname

```
Void_Type archive_entry_set_pathname (Pointer pEntry, Pointer pPathName)
```

A function used to set the pathname of an archive entry, explicitly interpreting the provided string as being encoded in UTF-8.

Setting the Pathname: Like archive_entry_set_pathname(), this function sets the name (path) of the file or directory that the archive_entry object represents within the archive.
Explicit UTF-8 Interpretation: The key difference is that archive_entry_set_pathname_utf8() explicitly tells libarchive that the input const char * string is encoded using UTF-8. This is important for handling filenames that contain characters outside of the basic ASCII range in a consistent and portable way.
When you use archive_entry_set_pathname_utf8(), libarchive will store the pathname internally, ensuring that it's treated as UTF-8. This can affect how the pathname is encoded when the archive is written and how it's interpreted when the archive is read by applications that understand UTF-8 pathnames.

Return Value: archive_entry_set_pathname() does not return a value that you would typically use for error checking.
Success/Failure: It's assumed to succeed in setting the pathname. Failures would likely manifest as more severe issues like crashes due to memory problems.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pPathName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_set_pathname_utf8

```
Void_Type archive_entry_set_pathname_utf8 (Pointer pEntry, Pointer pPathName)
```

A function used to set the pathname of an archive entry, explicitly interpreting the provided string as being encoded in UTF-8.

Setting the Pathname: Like archive_entry_set_pathname(), this function sets the name (path) of the file or directory that the archive_entry object represents within the archive.
Explicit UTF-8 Interpretation: The key difference is that archive_entry_set_pathname_utf8() explicitly tells libarchive that the input const char * string is encoded using UTF-8. This is important for handling filenames that contain characters outside of the basic ASCII range in a consistent and portable way.
When you use archive_entry_set_pathname_utf8(), libarchive will store the pathname internally, ensuring that it's treated as UTF-8. This can affect how the pathname is encoded when the archive is written and how it's interpreted when the archive is read by applications that understand UTF-8 pathnames.

Return Value: archive_entry_set_pathname() does not return a value that you would typically use for error checking.
Success/Failure: It's assumed to succeed in setting the pathname. Failures would likely manifest as more severe issues like crashes due to memory problems.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pPathName` | `Pointer` |

> **Note:** Non-ASCII names outside the ANSI code page crash the zip writer unless the writer option hdrcharset=UTF-8 is set; 7zip garbles non-ASCII names set this way (use archive_entry_update_pathname_utf8). The string MUST be valid UTF-8 (program source files need a BOM), a NULL pathname crashes archive_write_header.

Returns: `Void_Type`

#### archive_entry_copy_pathname

```
Void_Type archive_entry_copy_pathname (Pointer pEntry, Pointer pPathName)
```

Copies the path name (locale string). Same as archive_entry_set_pathname.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pPathName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_pathname_w

```
Void_Type archive_entry_copy_pathname_w (Pointer pEntry, Pointer pPathName)
```

Copies the path name (wide string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pPathName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_update_pathname_utf8

```
Integer archive_entry_update_pathname_utf8 (Pointer pEntry, Pointer pPathName)
```

Sets the path name (UTF-8 string); returns 1 on success, 0 when the conversion failed.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pPathName` | `Pointer` |

> **Note:** A result of 0 means the text could not be converted to the locale without loss; libarchive keeps the text anyway. Prefer this function over archive_entry_set_pathname_utf8: the 7zip writer garbles non-ASCII names set with the set_ variant.

Returns: `Integer`

#### archive_entry_copy_sourcepath

```
Void_Type archive_entry_copy_sourcepath (Pointer pEntry, Pointer pPathName)
```

Sets the path of the file on disk (locale string) that archive_read_disk_entry_from_file reads from.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pPathName` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_sourcepath_w

```
Void_Type archive_entry_copy_sourcepath_w (Pointer pEntry, Pointer pPathName)
```

Wide string variant of archive_entry_copy_sourcepath.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pPathName` | `Pointer` |

Returns: `Void_Type`

### Hard links and symbolic links

#### archive_entry_hardlink

```
Pointer archive_entry_hardlink (Pointer pEntry)
```

Pointer to the hard link target in the current locale (ANSI code page), or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_hardlink_utf8

```
Pointer archive_entry_hardlink_utf8 (Pointer pEntry)
```

Pointer to the hard link target as UTF-8, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_hardlink_w

```
Pointer archive_entry_hardlink_w (Pointer pEntry)
```

Pointer to the hard link target as wide (UTF-16) string, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_hardlink_is_set

```
Integer archive_entry_hardlink_is_set (Pointer pEntry)
```

1 when the entry has a hard link target, otherwise 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_symlink

```
Pointer archive_entry_symlink (Pointer pEntry)
```

Pointer to the symbolic link target in the current locale (ANSI code page), or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_symlink_utf8

```
Pointer archive_entry_symlink_utf8 (Pointer pEntry)
```

Pointer to the symbolic link target as UTF-8, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_symlink_w

```
Pointer archive_entry_symlink_w (Pointer pEntry)
```

Pointer to the symbolic link target as wide (UTF-16) string, or 0.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_symlink_type

```
Integer archive_entry_symlink_type (Pointer pEntry)
```

Type of the symbolic link target: AE_SYMLINK_TYPE_UNDEFINED, _FILE or _DIRECTORY.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_set_hardlink

```
Void_Type archive_entry_set_hardlink (Pointer pEntry, Pointer pTarget)
```

Sets the hard link target (locale string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

> **Note:** A hard link and a symbolic link share one storage in libarchive: an entry has one or the other.

Returns: `Void_Type`

#### archive_entry_set_hardlink_utf8

```
Void_Type archive_entry_set_hardlink_utf8 (Pointer pEntry, Pointer pTarget)
```

Sets the hard link target (UTF-8 string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_hardlink

```
Void_Type archive_entry_copy_hardlink (Pointer pEntry, Pointer pTarget)
```

Copies the hard link target (locale string). Same as archive_entry_set_hardlink.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_hardlink_w

```
Void_Type archive_entry_copy_hardlink_w (Pointer pEntry, Pointer pTarget)
```

Copies the hard link target (wide string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_update_hardlink_utf8

```
Integer archive_entry_update_hardlink_utf8 (Pointer pEntry, Pointer pTarget)
```

Sets the hard link target (UTF-8 string); returns 1 on success, 0 when the conversion failed.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

> **Note:** A result of 0 means the text could not be converted to the locale without loss; libarchive keeps the text anyway.

Returns: `Integer`

#### archive_entry_set_symlink

```
Void_Type archive_entry_set_symlink (Pointer pEntry, Pointer pTarget)
```

Sets the symbolic link target (locale string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

> **Note:** A hard link and a symbolic link share one storage in libarchive: an entry has one or the other.

Returns: `Void_Type`

#### archive_entry_set_symlink_utf8

```
Void_Type archive_entry_set_symlink_utf8 (Pointer pEntry, Pointer pTarget)
```

Sets the symbolic link target (UTF-8 string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_set_symlink_type

```
Void_Type archive_entry_set_symlink_type (Pointer pEntry, Integer iSymlinkType)
```

Sets the symbolic link type (AE_SYMLINK_TYPE_*).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iSymlinkType` | `Integer` |

Returns: `Void_Type`

#### archive_entry_copy_symlink

```
Void_Type archive_entry_copy_symlink (Pointer pEntry, Pointer pTarget)
```

Copies the symbolic link target (locale string). Same as archive_entry_set_symlink.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_symlink_w

```
Void_Type archive_entry_copy_symlink_w (Pointer pEntry, Pointer pTarget)
```

Copies the symbolic link target (wide string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_update_symlink_utf8

```
Integer archive_entry_update_symlink_utf8 (Pointer pEntry, Pointer pTarget)
```

Sets the symbolic link target (UTF-8 string); returns 1 on success, 0 when the conversion failed.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

> **Note:** A result of 0 means the text could not be converted to the locale without loss; libarchive keeps the text anyway.

Returns: `Integer`

#### archive_entry_set_link

```
Void_Type archive_entry_set_link (Pointer pEntry, Pointer pTarget)
```

Sets the link target of the kind that is currently set (hard link or symbolic link), locale string.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_set_link_utf8

```
Void_Type archive_entry_set_link_utf8 (Pointer pEntry, Pointer pTarget)
```

Sets the link target of the kind that is currently set (hard link or symbolic link), UTF-8 string.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_link

```
Void_Type archive_entry_copy_link (Pointer pEntry, Pointer pTarget)
```

Copies the link target (locale string); same as archive_entry_set_link.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_link_w

```
Void_Type archive_entry_copy_link_w (Pointer pEntry, Pointer pTarget)
```

Copies the link target (wide string).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_update_link_utf8

```
Integer archive_entry_update_link_utf8 (Pointer pEntry, Pointer pTarget)
```

Sets the link target (UTF-8 string); returns 1 on success, 0 when the conversion failed.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pTarget` | `Pointer` |

> **Note:** A result of 0 means the text could not be converted to the locale without loss; libarchive keeps the text anyway.

Returns: `Integer`

#### archive_entry_set_link_to_hardlink

```
Void_Type archive_entry_set_link_to_hardlink (Pointer pEntry)
```

Declares that the link target set with archive_entry_set_link is a hard link.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_set_link_to_symlink

```
Void_Type archive_entry_set_link_to_symlink (Pointer pEntry)
```

Declares that the link target set with archive_entry_set_link is a symbolic link.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

### File flags

#### archive_entry_fflags

```
Void_Type archive_entry_fflags (Pointer pEntry, Pointer pSet, Pointer pClear)
```

Stores the file flags to set and to clear in the unsigned 32 bit variables pointed to.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pSet` | `Pointer` |
| `pClear` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_fflags_text

```
Pointer archive_entry_fflags_text (Pointer pEntry)
```

Pointer to the file flags as text, or 0 when not set.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_set_fflags

```
Void_Type archive_entry_set_fflags (Pointer pEntry, UInteger iSet, UInteger iClear)
```

Sets the file flags to set and to clear.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iSet` | `UInteger` |
| `iClear` | `UInteger` |

Returns: `Void_Type`

#### archive_entry_copy_fflags_text

```
Pointer archive_entry_copy_fflags_text (Pointer pEntry, Pointer pFlags)
```

Sets the file flags from text. Returns a pointer to the first invalid token, or 0 when all were valid.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pFlags` | `Pointer` |

Returns: `Pointer`

#### archive_entry_copy_fflags_text_len

```
Pointer archive_entry_copy_fflags_text_len (Pointer pEntry, Pointer pFlags, Longptr iLength)
```

Like archive_entry_copy_fflags_text with an explicit text length in bytes. Not in the shipped 3.6.1 header; declared according to the libarchive source.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pFlags` | `Pointer` |
| `iLength` | `Longptr` |

Returns: `Pointer`

#### archive_entry_copy_fflags_text_w

```
Pointer archive_entry_copy_fflags_text_w (Pointer pEntry, Pointer pFlags)
```

Wide string variant of archive_entry_copy_fflags_text.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pFlags` | `Pointer` |

Returns: `Pointer`

### stat and platform data

#### archive_entry_stat

```
Pointer archive_entry_stat (Pointer pEntry)
```

Pointer to a C runtime struct stat filled from the entry. Owned by the entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The structure is a C runtime struct _stat64i32 (size is a 32 bit value at offset 20).

Returns: `Pointer`

#### archive_entry_copy_stat

```
Void_Type archive_entry_copy_stat (Pointer pEntry, Pointer pStat)
```

Copies the fields from a C runtime struct stat into the entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pStat` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_copy_bhfi

```
Void_Type archive_entry_copy_bhfi (Pointer pEntry, Pointer pFileInfo)
```

Windows only: copies the fields from a BY_HANDLE_FILE_INFORMATION structure into the entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pFileInfo` | `Pointer` |

> **Note:** Copies times, size, inode and link count; it does not set the file type or the permissions.

Returns: `Void_Type`

#### archive_entry_mac_metadata

```
Pointer archive_entry_mac_metadata (Pointer pEntry, Pointer pSize)
```

Pointer to the Mac OS AppleDouble metadata blob; the size_t variable pointed to by pSize receives its size.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pSize` | `Pointer` |

Returns: `Pointer`

#### archive_entry_copy_mac_metadata

```
Void_Type archive_entry_copy_mac_metadata (Pointer pEntry, Pointer pData, Longptr iSize)
```

Stores a Mac OS AppleDouble metadata blob in the entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pData` | `Pointer` |
| `iSize` | `Longptr` |

Returns: `Void_Type`

#### archive_entry_digest

```
Pointer archive_entry_digest (Pointer pEntry, Integer iDigestType)
```

Pointer to the raw digest bytes (ARCHIVE_ENTRY_DIGEST_*) when the format provides one, otherwise 0. The length depends on the type (MD5 16, SHA1 20, SHA256 32, ...).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iDigestType` | `Integer` |

> **Note:** For a known type the function never returns 0: when the entry has no digest it returns a pointer to zero-filled bytes. Only an unknown type returns 0.

Returns: `Pointer`

### ACL

#### archive_entry_acl

```
Pointer archive_entry_acl (Pointer pEntry)
```

Pointer to the opaque ACL object of the entry. There is nothing a client can do with it.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Pointer`

#### archive_entry_acl_clear

```
Void_Type archive_entry_acl_clear (Pointer pEntry)
```

Removes all ACL entries.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_acl_add_entry

```
Integer archive_entry_acl_add_entry (Pointer pEntry, Integer iType, Integer iPermset, Integer iTag, Integer iQualifier, Pointer pName)
```

Adds an ACL entry. Type is ARCHIVE_ENTRY_ACL_TYPE_*, tag ARCHIVE_ENTRY_ACL_USER etc.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iType` | `Integer` |
| `iPermset` | `Integer` |
| `iTag` | `Integer` |
| `iQualifier` | `Integer` |
| `pName` | `Pointer` |

Returns: `Integer`

#### archive_entry_acl_add_entry_w

```
Integer archive_entry_acl_add_entry_w (Pointer pEntry, Integer iType, Integer iPermset, Integer iTag, Integer iQualifier, Pointer pName)
```

Wide string variant of archive_entry_acl_add_entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iType` | `Integer` |
| `iPermset` | `Integer` |
| `iTag` | `Integer` |
| `iQualifier` | `Integer` |
| `pName` | `Pointer` |

> **Note:** pName must not be NULL (an empty WString passes NULL with AddressOf): libarchive crashes in wcslen. Pass any non-empty text for entries without a name.

Returns: `Integer`

#### archive_entry_acl_reset

```
Integer archive_entry_acl_reset (Pointer pEntry, Integer iWantType)
```

Starts an enumeration of the ACL entries of the wanted types (returns the number of entries).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iWantType` | `Integer` |

Returns: `Integer`

#### archive_entry_acl_next

```
Integer archive_entry_acl_next (Pointer pEntry, Integer iWantType, Pointer pType, Pointer pPermset, Pointer pTag, Pointer pQualifier, Pointer ppName)
```

Returns the next ACL entry in the Integer variables pointed to (name as char pointer). Returns ARCHIVE_EOF at the end.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iWantType` | `Integer` |
| `pType` | `Pointer` |
| `pPermset` | `Pointer` |
| `pTag` | `Pointer` |
| `pQualifier` | `Pointer` |
| `ppName` | `Pointer` |

> **Note:** The returned user/group name is in the ANSI code page.

Returns: `Integer`

#### archive_entry_acl_count

```
Integer archive_entry_acl_count (Pointer pEntry, Integer iWantType)
```

Number of ACL entries of the wanted types.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iWantType` | `Integer` |

Returns: `Integer`

#### archive_entry_acl_types

```
Integer archive_entry_acl_types (Pointer pEntry)
```

Bit mask of the ARCHIVE_ENTRY_ACL_TYPE_* values present in the entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_acl_to_text

```
Pointer archive_entry_acl_to_text (Pointer pEntry, Pointer pLength, Integer iFlags)
```

Pointer to a newly allocated text form of the ACL (ARCHIVE_ENTRY_ACL_STYLE_* flags). The length (la_ssize_t) is stored when pLength is not 0. The memory is owned by the entry.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pLength` | `Pointer` |
| `iFlags` | `Integer` |

> **Note:** The returned text is allocated with malloc and must be freed by the caller (free from ucrtbase.dll); it is not owned by the entry.

Returns: `Pointer`

#### archive_entry_acl_to_text_w

```
Pointer archive_entry_acl_to_text_w (Pointer pEntry, Pointer pLength, Integer iFlags)
```

Wide string variant of archive_entry_acl_to_text.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pLength` | `Pointer` |
| `iFlags` | `Integer` |

> **Note:** The returned text is allocated with malloc and must be freed by the caller (free from ucrtbase.dll); it is not owned by the entry.

Returns: `Pointer`

#### archive_entry_acl_from_text

```
Integer archive_entry_acl_from_text (Pointer pEntry, Pointer pText, Integer iType)
```

Sets the ACL from text, replacing entries of that type.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pText` | `Pointer` |
| `iType` | `Integer` |

> **Note:** The parsed entries are added to the existing ACL; they do not replace it (call archive_entry_acl_clear first to replace).

Returns: `Integer`

#### archive_entry_acl_from_text_w

```
Integer archive_entry_acl_from_text_w (Pointer pEntry, Pointer pText, Integer iType)
```

Wide string variant of archive_entry_acl_from_text.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pText` | `Pointer` |
| `iType` | `Integer` |

> **Note:** The parsed entries are added to the existing ACL; they do not replace it (call archive_entry_acl_clear first to replace).

Returns: `Integer`

#### archive_entry_acl_text

```
Pointer archive_entry_acl_text (Pointer pEntry, Integer iFlags)
```

Deprecated; use archive_entry_acl_to_text.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iFlags` | `Integer` |

Returns: `Pointer`

#### archive_entry_acl_text_w

```
Pointer archive_entry_acl_text_w (Pointer pEntry, Integer iFlags)
```

Deprecated; use archive_entry_acl_to_text_w.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iFlags` | `Integer` |

Returns: `Pointer`

### Extended attributes

#### archive_entry_xattr_clear

```
Void_Type archive_entry_xattr_clear (Pointer pEntry)
```

Removes all extended attributes.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_xattr_add_entry

```
Void_Type archive_entry_xattr_add_entry (Pointer pEntry, Pointer pName, Pointer pValue, Longptr iSize)
```

Adds an extended attribute (name string, value bytes and size).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pName` | `Pointer` |
| `pValue` | `Pointer` |
| `iSize` | `Longptr` |

Returns: `Void_Type`

#### archive_entry_xattr_count

```
Integer archive_entry_xattr_count (Pointer pEntry)
```

Number of extended attributes.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_xattr_reset

```
Integer archive_entry_xattr_reset (Pointer pEntry)
```

Starts an enumeration of the extended attributes (returns the count).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_xattr_next

```
Integer archive_entry_xattr_next (Pointer pEntry, Pointer ppName, Pointer ppValue, Pointer pSize)
```

Returns the next extended attribute: name pointer, value pointer and size (size_t) are stored in the variables pointed to. Returns ARCHIVE_WARN at the end.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `ppName` | `Pointer` |
| `ppValue` | `Pointer` |
| `pSize` | `Pointer` |

> **Note:** The attributes are enumerated in the reverse order of adding.

Returns: `Integer`

### Sparse regions

#### archive_entry_sparse_clear

```
Void_Type archive_entry_sparse_clear (Pointer pEntry)
```

Removes all sparse regions.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_sparse_add_entry

```
Void_Type archive_entry_sparse_add_entry (Pointer pEntry, BigInt iOffset, BigInt iLength)
```

Adds a sparse region (data block) with offset and length.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iOffset` | `BigInt` |
| `iLength` | `BigInt` |

> **Note:** Regions that reach beyond the entry size are silently ignored: set the size first.

Returns: `Void_Type`

#### archive_entry_sparse_count

```
Integer archive_entry_sparse_count (Pointer pEntry)
```

Number of sparse regions.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_sparse_reset

```
Integer archive_entry_sparse_reset (Pointer pEntry)
```

Starts an enumeration of the sparse regions (returns the count).

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_entry_sparse_next

```
Integer archive_entry_sparse_next (Pointer pEntry, Pointer pOffset, Pointer pLength)
```

Returns the next sparse region in the Int64 variables pointed to. Returns ARCHIVE_WARN at the end.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `pOffset` | `Pointer` |
| `pLength` | `Pointer` |

Returns: `Integer`

### Hard link resolver

#### archive_entry_linkresolver_new

```
Pointer archive_entry_linkresolver_new ()
```

Allocates a hard link resolver. Free it with archive_entry_linkresolver_free.

Returns: `Pointer`

#### archive_entry_linkresolver_set_strategy

```
Void_Type archive_entry_linkresolver_set_strategy (Pointer pResolver, Integer iFormatCode)
```

Selects the hard link strategy that matches the archive format (ARCHIVE_FORMAT_*).

| Parameter | Type |
|---|---|
| `pResolver` | `Pointer` |
| `iFormatCode` | `Integer` |

Returns: `Void_Type`

#### archive_entry_linkresolver_free

```
Void_Type archive_entry_linkresolver_free (Pointer pResolver)
```

Frees the hard link resolver.

| Parameter | Type |
|---|---|
| `pResolver` | `Pointer` |

> **Note:** libarchive 3.7.7 frees entries that are still deferred (SVR4 cpio strategy) twice: call archive_entry_linkify with a zero entry until no more entries are returned before freeing the resolver.

Returns: `Void_Type`

#### archive_entry_linkify

```
Void_Type archive_entry_linkify (Pointer pResolver, Pointer ppEntry, Pointer ppSparseEntry)
```

Filters an entry through the resolver; ppEntry and ppSparseEntry point to entry pointer variables that receive the entries to write (0, 1 or 2). Call with a zero entry to flush.

| Parameter | Type |
|---|---|
| `pResolver` | `Pointer` |
| `ppEntry` | `Pointer` |
| `ppSparseEntry` | `Pointer` |

Returns: `Void_Type`

#### archive_entry_partial_links

```
Pointer archive_entry_partial_links (Pointer pResolver, Pointer pLinks)
```

Returns the entries of files whose links were not all seen; the link count (unsigned 32 bit) is stored in the variable pointed to. Returns 0 when done.

| Parameter | Type |
|---|---|
| `pResolver` | `Pointer` |
| `pLinks` | `Pointer` |

Returns: `Pointer`

### Is-set queries added after the shipped 3.6.1 header (libarchive 3.7.x)

#### archive_entry_filetype_is_set

```
Integer archive_entry_filetype_is_set (Pointer pEntry)
```

1 when the file type is set, otherwise 0. Not in the shipped 3.6.1 header.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_perm_is_set

```
Integer archive_entry_perm_is_set (Pointer pEntry)
```

1 when the permission bits are set, otherwise 0. Not in the shipped 3.6.1 header.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_uid_is_set

```
Integer archive_entry_uid_is_set (Pointer pEntry)
```

1 when the user id is set, otherwise 0. Not in the shipped 3.6.1 header.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_gid_is_set

```
Integer archive_entry_gid_is_set (Pointer pEntry)
```

1 when the group id is set, otherwise 0. Not in the shipped 3.6.1 header.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

#### archive_entry_rdev_is_set

```
Integer archive_entry_rdev_is_set (Pointer pEntry)
```

1 when the rdev number is set, otherwise 0. Not in the shipped 3.6.1 header.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |

> **Note:** The result is a non-zero flag value, not necessarily 1.

Returns: `Integer`

### Time setter documented in the original declarations

#### archive_entry_set_mtime

```
Void_Type archive_entry_set_mtime (Pointer pEntry, BigInt iSeconds, Integer iNanoSeconds)
```

It sets the modification time (mtime) for an entry within an archive.
The modification time indicates the last time the content of a file was modified.
This is a common piece of metadata stored in archive formats and is analogous to the st_mtime field in a Unix-like stat structure.

| Parameter | Type |
|---|---|
| `pEntry` | `Pointer` |
| `iSeconds` | `BigInt` |
| `iNanoSeconds` | `Integer` |

Returns: `Void_Type`
