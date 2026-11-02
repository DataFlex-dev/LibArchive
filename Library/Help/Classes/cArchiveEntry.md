# cArchiveEntry

`Use cArchiveEntry.pkg` — `Class cArchiveEntry is a cObject`

Wrapper around a libarchive `struct archive_entry`: the metadata of one archive member (path name, type, mode, size, times, owner, links, file flags, ACL, extended attributes, sparse map, digests, ...). It is used to describe entries that are written ([cArchiveWriter](cArchiveWriter.md), [cArchiveDiskWriter](cArchiveDiskWriter.md)), to inspect entries that were read ([cArchiveReader](cArchiveReader.md), [cArchiveDiskReader](cArchiveDiskReader.md)), and as the entry argument of [cArchiveMatch](cArchiveMatch.md) and [cArchiveLinkResolver](cArchiveLinkResolver.md).

The properties follow the libarchive naming: a getter and a setter map to `archive_entry_X` and `archive_entry_set_X`; where libarchive only offers a getter the property is read only. Every property is a normal DataFlex property (`Get psPathname`, `Set psPathname to ...`) and can be used in expressions: `(psPathname (oEntry))`.

## Ownership

An entry is either **owned** or **borrowed** (`pbOwnsEntry`):

| How the object got its entry | `pbOwnsEntry` | Who frees it |
|---|---|---|
| `CreateEntry`, `CreateEntryForArchive`, `CloneEntry` | True | The object (`FreeEntry` or when the object is destroyed). |
| `AttachEntry hEntry True` | True | The object. |
| `AttachEntry hEntry False` | False | The owner of the pointer. This is how to wrap the entry a reader returns from `archive_read_next_header`: libarchive owns it and it is only valid until the next header is read. |

`CreateEntry`, `CreateEntryForArchive`, `AttachEntry` and `FreeEntry` free a previously owned entry first. An object without an entry is harmless: getters return 0, False or an empty string, setters and methods do nothing, `CloneEntry` returns 0 and the methods that return a libarchive result report `ARCHIVE_FAILED`.

## Strings and encodings

Names (path name, hard link, symbolic link, user name, group name) are available in three encodings:

| Accessor | Encoding | libarchive functions |
|---|---|---|
| `psX` | UTF-8, **recommended**. The setter validates the text first and raises a DataFlex error (`DFERR_PROGRAM`) only when it is **not valid UTF-8**; libarchive is not called then and the entry is unchanged. Valid text that cannot be converted to the ANSI code page without loss (for example Japanese text on a Western Windows) is accepted and stored as it is: `archive_entry_update_X_utf8` returns 0 for it, which is reported in `pbLastTextLossless` instead of an error. | `archive_entry_X_utf8`, `archive_entry_update_X_utf8` |
| `psXWide` | Wide (UTF-16), lossless for all characters. | `archive_entry_X_w`, `archive_entry_copy_X_w` |
| `psXLocale` | Narrow text. The bytes of the DataFlex string (UTF-8) are passed to and returned from libarchive unchanged, libarchive interprets them in the ANSI code page. Only ASCII text is portable. | `archive_entry_X`, `archive_entry_set_X` |

Setting a name to an empty string removes it. **Source files with non-ASCII string literals must be saved as UTF-8 with BOM**, otherwise the text is not valid UTF-8.

The source path (the file on disk the entry was created from) has only narrow and wide functions in libarchive; `psSourcePath` is the wide variant.

## Structs

Defined at the top of `cArchiveEntry.pkg`.

| Struct | Members | Used by |
|---|---|---|
| `tArchiveEntryAcl` | `Integer eType` (`ARCHIVE_ENTRY_ACL_TYPE_*`, 0 = no more entries), `Integer iPermset` (`ARCHIVE_ENTRY_ACL_*` bits), `Integer eTag` (`ARCHIVE_ENTRY_ACL_USER`, `_GROUP`, ...), `Integer iQualifier` (user/group id), `String sName` | `AclNext`, `AclEntries` |
| `tArchiveEntryXattr` | `String sName` (empty = no more attributes), `UChar[] ucValue` | `XattrNext`, `XattrEntries` |
| `tArchiveEntrySparse` | `BigInt iOffset`, `BigInt iLength` (-1 = no more regions) | `SparseNext`, `SparseEntries` |

## Properties

Access: **rw** = read/write, **r** = read only. Times are Unix time (seconds since 1970-01-01 UTC) as `BigInt` plus nanoseconds. Properties that hold libarchive `unsigned int` values use `UInteger`.

| Property | Type | Access | libarchive function |
|---|---|---|---|
| `ppEntry` | `Pointer` | rw | The `struct archive_entry *`; 0 when there is none. |
| `pbOwnsEntry` | `Boolean` | rw | True when the object frees the entry. |
| `pbRaiseErrors` | `Boolean` | rw | True (default): `ARCHIVE_FAILED` results of the ACL methods raise a DataFlex error. |
| `pbLastTextLossless` | `Boolean` | r | False when the last UTF-8 name setter (`psPathname`, `psHardlink`, `psSymlink`, `psUname`, `psGname`, `psLink`) stored valid text that could not be converted to the ANSI code page without loss; True otherwise. Informational: libarchive keeps and writes the UTF-8 text either way. |
| `psPathname` | `String` | rw | `archive_entry_pathname_utf8`, `archive_entry_update_pathname_utf8` — path name, UTF-8 |
| `psPathnameWide` | `String` | rw | `archive_entry_pathname_w`, `archive_entry_copy_pathname_w` — path name, wide |
| `psPathnameLocale` | `String` | rw | `archive_entry_pathname`, `archive_entry_set_pathname` — path name, narrow |
| `psHardlink` | `String` | rw | `archive_entry_hardlink_utf8`, `archive_entry_update_hardlink_utf8` — hard link target, UTF-8 |
| `psHardlinkWide` | `String` | rw | `archive_entry_hardlink_w`, `archive_entry_copy_hardlink_w` — hard link target, wide |
| `psHardlinkLocale` | `String` | rw | `archive_entry_hardlink`, `archive_entry_set_hardlink` — hard link target, narrow |
| `psSymlink` | `String` | rw | `archive_entry_symlink_utf8`, `archive_entry_update_symlink_utf8` — symbolic link target, UTF-8 |
| `psSymlinkWide` | `String` | rw | `archive_entry_symlink_w`, `archive_entry_copy_symlink_w` — symbolic link target, wide |
| `psSymlinkLocale` | `String` | rw | `archive_entry_symlink`, `archive_entry_set_symlink` — symbolic link target, narrow |
| `psUname` | `String` | rw | `archive_entry_uname_utf8`, `archive_entry_update_uname_utf8` — user name, UTF-8 |
| `psUnameWide` | `String` | rw | `archive_entry_uname_w`, `archive_entry_copy_uname_w` — user name, wide |
| `psUnameLocale` | `String` | rw | `archive_entry_uname`, `archive_entry_set_uname` — user name, narrow |
| `psGname` | `String` | rw | `archive_entry_gname_utf8`, `archive_entry_update_gname_utf8` — group name, UTF-8 |
| `psGnameWide` | `String` | rw | `archive_entry_gname_w`, `archive_entry_copy_gname_w` — group name, wide |
| `psGnameLocale` | `String` | rw | `archive_entry_gname`, `archive_entry_set_gname` — group name, narrow |
| `psSourcePath` | `String` | rw | `archive_entry_sourcepath_w`, `archive_entry_copy_sourcepath_w` — source path on disk, wide |
| `psSourcePathLocale` | `String` | rw | `archive_entry_sourcepath`, `archive_entry_copy_sourcepath` — source path, narrow |
| `psLink` | `String` | rw | `archive_entry_hardlink_utf8` / `archive_entry_symlink_utf8`, `archive_entry_update_link_utf8` — the link target of the kind that is set (see notes) |
| `pbHardlinkIsSet` | `Boolean` | r | `archive_entry_hardlink_is_set` |
| `peSymlinkType` | `Integer` | rw | `archive_entry_symlink_type`, `archive_entry_set_symlink_type` — `AE_SYMLINK_TYPE_UNDEFINED`, `_FILE`, `_DIRECTORY` |
| `piAtime` | `BigInt` | rw | `archive_entry_atime`, `archive_entry_set_atime` — seconds of the access time (setter keeps the nanoseconds) |
| `piAtimeNsec` | `Integer` | rw | `archive_entry_atime_nsec`, `archive_entry_set_atime` — nanoseconds (setter keeps the seconds) |
| `pbAtimeIsSet` | `Boolean` | r | `archive_entry_atime_is_set` |
| `piBirthtime` | `BigInt` | rw | `archive_entry_birthtime`, `archive_entry_set_birthtime` — seconds of the creation (birth) time (setter keeps the nanoseconds) |
| `piBirthtimeNsec` | `Integer` | rw | `archive_entry_birthtime_nsec`, `archive_entry_set_birthtime` — nanoseconds (setter keeps the seconds) |
| `pbBirthtimeIsSet` | `Boolean` | r | `archive_entry_birthtime_is_set` |
| `piCtime` | `BigInt` | rw | `archive_entry_ctime`, `archive_entry_set_ctime` — seconds of the inode change time (setter keeps the nanoseconds) |
| `piCtimeNsec` | `Integer` | rw | `archive_entry_ctime_nsec`, `archive_entry_set_ctime` — nanoseconds (setter keeps the seconds) |
| `pbCtimeIsSet` | `Boolean` | r | `archive_entry_ctime_is_set` |
| `piMtime` | `BigInt` | rw | `archive_entry_mtime`, `archive_entry_set_mtime` — seconds of the modification time (setter keeps the nanoseconds) |
| `piMtimeNsec` | `Integer` | rw | `archive_entry_mtime_nsec`, `archive_entry_set_mtime` — nanoseconds (setter keeps the seconds) |
| `pbMtimeIsSet` | `Boolean` | r | `archive_entry_mtime_is_set` |
| `piDev` | `UInteger` | rw | `archive_entry_dev`, `archive_entry_set_dev` |
| `pbDevIsSet` | `Boolean` | r | `archive_entry_dev_is_set` |
| `piDevMajor` | `UInteger` | rw | `archive_entry_devmajor`, `archive_entry_set_devmajor` |
| `piDevMinor` | `UInteger` | rw | `archive_entry_devminor`, `archive_entry_set_devminor` |
| `piIno` | `BigInt` | rw | `archive_entry_ino64`, `archive_entry_set_ino64` — 64 bit inode number |
| `piInoLegacy` | `BigInt` | rw | `archive_entry_ino`, `archive_entry_set_ino` — older inode functions; prefer `piIno` |
| `pbInoIsSet` | `Boolean` | r | `archive_entry_ino_is_set` |
| `piNlink` | `UInteger` | rw | `archive_entry_nlink`, `archive_entry_set_nlink` |
| `piRdev` | `UInteger` | rw | `archive_entry_rdev`, `archive_entry_set_rdev` |
| `pbRdevIsSet` | `Boolean` | r | `archive_entry_rdev_is_set` |
| `piRdevMajor` | `UInteger` | rw | `archive_entry_rdevmajor`, `archive_entry_set_rdevmajor` |
| `piRdevMinor` | `UInteger` | rw | `archive_entry_rdevminor`, `archive_entry_set_rdevminor` |
| `peFileType` | `Integer` | rw | `archive_entry_filetype`, `archive_entry_set_filetype` — `AE_IFREG`, `AE_IFDIR`, `AE_IFLNK`, ... |
| `pbFileTypeIsSet` | `Boolean` | r | `archive_entry_filetype_is_set` |
| `piMode` | `Integer` | rw | `archive_entry_mode`, `archive_entry_set_mode` — type and permission bits |
| `piPerm` | `Integer` | rw | `archive_entry_perm`, `archive_entry_set_perm` — permission bits (420 = octal 0644, 493 = 0755) |
| `pbPermIsSet` | `Boolean` | r | `archive_entry_perm_is_set` |
| `psStrMode` | `String` | r | `archive_entry_strmode` — for example `-rw-r--r-- ` |
| `piSize` | `BigInt` | rw | `archive_entry_size`, `archive_entry_set_size` |
| `pbSizeIsSet` | `Boolean` | r | `archive_entry_size_is_set` |
| `piUid` | `BigInt` | rw | `archive_entry_uid`, `archive_entry_set_uid` |
| `pbUidIsSet` | `Boolean` | r | `archive_entry_uid_is_set` |
| `piGid` | `BigInt` | rw | `archive_entry_gid`, `archive_entry_set_gid` |
| `pbGidIsSet` | `Boolean` | r | `archive_entry_gid_is_set` |
| `pbDataEncrypted` | `Boolean` | rw | `archive_entry_is_data_encrypted`, `archive_entry_set_is_data_encrypted` |
| `pbMetadataEncrypted` | `Boolean` | rw | `archive_entry_is_metadata_encrypted`, `archive_entry_set_is_metadata_encrypted` |
| `pbEncrypted` | `Boolean` | r | `archive_entry_is_encrypted` — data or metadata encrypted |
| `piFFlagsSet` | `UInteger` | rw | `archive_entry_fflags`, `archive_entry_set_fflags` — file flag bits to set (setter keeps the clear bits) |
| `piFFlagsClear` | `UInteger` | rw | `archive_entry_fflags`, `archive_entry_set_fflags` — file flag bits to clear (setter keeps the set bits) |
| `psFFlagsText` | `String` | rw | `archive_entry_fflags_text`, `archive_entry_copy_fflags_text` — file flags as text; the setter raises an error naming the first invalid token |

## Methods

### Life cycle

| Method | Description | libarchive function |
|---|---|---|
| `Function HasEntry Returns Boolean` | True when the object wraps an entry. | |
| `Procedure CreateEntry` | Frees an owned entry and creates a new empty owned entry. | `archive_entry_new` |
| `Procedure CreateEntryForArchive Pointer pArchive` | Like `CreateEntry`, taking the character set conversion settings from a libarchive handle (`ppArchive` of a wrapper object, or 0). | `archive_entry_new2` |
| `Procedure AttachEntry Pointer pEntry Boolean bOwns` | Frees an owned entry and wraps an existing one. | |
| `Procedure FreeEntry` | Frees the entry when owned and forgets it. | `archive_entry_free` |
| `Procedure Clear` | Resets every field of the entry; the entry stays attached. | `archive_entry_clear` |
| `Function CloneEntry Returns Handle` | Deep copy in a **new** `cArchiveEntry` object (a sibling of this object) that owns the copy; destroy it with `Send Request_Destroy_Object of hoClone` when done. 0 without entry. | `archive_entry_clone` |
| `Function CheckResult Integer iResult String sOperation Returns Integer` | Passes a result on; raises a DataFlex error for `ARCHIVE_FAILED` or worse when `pbRaiseErrors`. | |

### Names and links

For each name X in Pathname, Hardlink, Symlink, Uname, Gname:

| Method | Description | libarchive function |
|---|---|---|
| `Procedure SetXUtf8 String sValue` | Sets the name from UTF-8 text without a validity report (empty removes). | `archive_entry_set_X_utf8` |
| `Procedure CopyXLocale String sValue` | Copies the name from narrow text (empty removes). Same as setting `psXLocale`. | `archive_entry_copy_X` |

The concrete names are:

| X | `SetXUtf8` | `CopyXLocale` |
|---|---|---|
| Pathname | `SetPathnameUtf8` | `CopyPathnameLocale` |
| Hardlink | `SetHardlinkUtf8` | `CopyHardlinkLocale` |
| Symlink | `SetSymlinkUtf8` | `CopySymlinkLocale` |
| Uname | `SetUnameUtf8` | `CopyUnameLocale` |
| Gname | `SetGnameUtf8` | `CopyGnameLocale` |

Further name methods:

| Method | Description | libarchive function |
|---|---|---|
| `Procedure ClearHardlink` / `Procedure ClearSymlink` | Remove the link target. | `archive_entry_set_hardlink_utf8` / `archive_entry_set_symlink_utf8` (NULL) |
| `Procedure SetLinkLocale String sValue` | Sets the link target of the kind that is set, narrow text. | `archive_entry_set_link` |
| `Procedure SetLinkUtf8 String sValue` | Same, UTF-8 without validity report. | `archive_entry_set_link_utf8` |
| `Procedure CopyLinkLocale String sValue` | Copies the link target, narrow text. | `archive_entry_copy_link` |
| `Procedure CopyLinkWide String sValue` | Copies the link target, wide text. | `archive_entry_copy_link_w` |
| `Procedure SetLinkToHardlink` / `Procedure SetLinkToSymlink` | Declare the kind of the link target. | `archive_entry_set_link_to_hardlink` / `archive_entry_set_link_to_symlink` |

`psLink` (property) sets the link target through `archive_entry_update_link_utf8`.

### Times

For each time T in Atime, Birthtime, Ctime, Mtime:

| Method | Description | libarchive function |
|---|---|---|
| `Procedure SetT BigInt iSeconds Integer iNanoSeconds` | Sets seconds and nanoseconds in one call, for example `Send SetMtime of oEntry 1700000000 0`. | `archive_entry_set_T` |
| `Procedure UnsetT` | Marks the time as not set. | `archive_entry_unset_T` |

The concrete names are `SetAtime`, `SetBirthtime`, `SetCtime`, `SetMtime` and `UnsetAtime`, `UnsetBirthtime`, `UnsetCtime`, `UnsetMtime`.

### Size, flags, stat and platform data

| Method | Description | libarchive function |
|---|---|---|
| `Procedure UnsetSize` | Marks the size as not set. | `archive_entry_unset_size` |
| `Procedure SetFFlags UInteger iSet UInteger iClear` | Sets the file flag bits in one call. | `archive_entry_set_fflags` |
| `Function CopyFFlagsText String sFlags Returns String` | Parses file flag text; returns the first invalid token or "" when all was valid. Empty text clears the flags. | `archive_entry_copy_fflags_text` |
| `Function CopyFFlagsTextLen String sFlags Integer iLength Returns String` | Same, using only the first `iLength` bytes. | `archive_entry_copy_fflags_text_len` |
| `Function CopyFFlagsTextWide String sFlags Returns String` | Same with wide text. | `archive_entry_copy_fflags_text_w` |
| `Function StatPointer Returns Pointer` | Pointer to a C runtime `struct stat` filled from the entry; owned by the entry, valid until the entry changes. | `archive_entry_stat` |
| `Procedure CopyStat Pointer pStat` | Copies the fields of a C runtime `struct stat` into the entry. | `archive_entry_copy_stat` |
| `Procedure CopyBhfi Pointer pFileInfo` | Copies a Windows `BY_HANDLE_FILE_INFORMATION` (52 bytes) into the entry. | `archive_entry_copy_bhfi` |
| `Function MacMetadata Returns UChar[]` | The Mac OS AppleDouble metadata blob; empty array when there is none. | `archive_entry_mac_metadata` |
| `Procedure SetMacMetadata UChar[] ucData` | Stores a Mac OS metadata blob (an empty array removes it). | `archive_entry_copy_mac_metadata` |
| `Function Digest Integer eType Returns String` | The digest (`ARCHIVE_ENTRY_DIGEST_MD5`, `_RMD160`, `_SHA1`, `_SHA256`, `_SHA384`, `_SHA512`) as lower case hex text; "" when the entry has none. | `archive_entry_digest` |
| `Function DigestLength Integer eType Returns Integer` | Byte length of a digest type (16, 20, 20, 32, 48, 64; 0 unknown). | |

### ACL

| Method | Description | libarchive function |
|---|---|---|
| `Procedure AclClear` | Removes all ACL entries. | `archive_entry_acl_clear` |
| `Function AclAddEntry Integer eType Integer iPermset Integer eTag Integer iQualifier String sName Returns Integer` | Adds an ACL entry; `sName` "" for none. Returns `ARCHIVE_OK` or `ARCHIVE_FAILED` (invalid type or tag). | `archive_entry_acl_add_entry` |
| `Function AclAddEntryWide ...` | Same with a wide name (use it for non-ASCII names). | `archive_entry_acl_add_entry_w` |
| `Function AclReset Integer iWantType Returns Integer` | Starts an enumeration of the wanted types and returns the number of entries. | `archive_entry_acl_reset` |
| `Function AclNext Integer iWantType Returns tArchiveEntryAcl` | Next entry of the enumeration; `eType` 0 at the end. The name is converted from the ANSI code page. | `archive_entry_acl_next` |
| `Function AclEntries Integer iWantType Returns tArchiveEntryAcl[]` | All entries as an array. | `archive_entry_acl_reset`, `archive_entry_acl_next` |
| `Function AclCount Integer iWantType Returns Integer` | Number of entries of the wanted types. | `archive_entry_acl_count` |
| `Function AclTypes Returns Integer` | Bit mask of the `ARCHIVE_ENTRY_ACL_TYPE_*` values present. | `archive_entry_acl_types` |
| `Function AclToText Integer iFlags Returns String` | Text form; `iFlags` combines the wanted types (`ARCHIVE_ENTRY_ACL_TYPE_ACCESS`, `_DEFAULT`, `_NFS4`) with `ARCHIVE_ENTRY_ACL_STYLE_*` flags. The memory libarchive allocates is released. | `archive_entry_acl_to_text` |
| `Function AclToTextWide Integer iFlags Returns String` | Wide variant. | `archive_entry_acl_to_text_w` |
| `Function AclTextLegacy Integer iFlags Returns String` / `Function AclTextLegacyWide ...` | Deprecated libarchive text functions (text owned by the entry); prefer `AclToText`. | `archive_entry_acl_text` / `archive_entry_acl_text_w` |
| `Function AclFromText String sText Integer eType Returns Integer` | Parses ACL text of one type and **adds** the entries. Returns `ARCHIVE_OK`, `ARCHIVE_WARN` or `ARCHIVE_FAILED`. | `archive_entry_acl_from_text` |
| `Function AclFromTextWide ...` | Wide variant. | `archive_entry_acl_from_text_w` |
| `Function AclPointer Returns Pointer` | The opaque ACL object (nothing to do with it from DataFlex). | `archive_entry_acl` |

### Extended attributes

| Method | Description | libarchive function |
|---|---|---|
| `Procedure XattrClear` | Removes all extended attributes. | `archive_entry_xattr_clear` |
| `Procedure XattrAdd String sName UChar[] ucValue` | Adds an attribute (name and value are copied). | `archive_entry_xattr_add_entry` |
| `Procedure XattrAddText String sName String sValue` | Adds an attribute whose value is the bytes of a string. | `archive_entry_xattr_add_entry` |
| `Function XattrCount Returns Integer` | Number of attributes. | `archive_entry_xattr_count` |
| `Function XattrReset Returns Integer` | Starts an enumeration, returns the count. | `archive_entry_xattr_reset` |
| `Function XattrNext Returns tArchiveEntryXattr` | Next attribute; `sName` is empty at the end. | `archive_entry_xattr_next` |
| `Function XattrEntries Returns tArchiveEntryXattr[]` | All attributes. | `archive_entry_xattr_reset`, `archive_entry_xattr_next` |

### Sparse regions

| Method | Description | libarchive function |
|---|---|---|
| `Procedure SparseClear` | Removes all sparse regions. | `archive_entry_sparse_clear` |
| `Procedure SparseAdd BigInt iOffset BigInt iLength` | Adds a data region. Regions that reach beyond `piSize` are ignored by libarchive: set the size first. | `archive_entry_sparse_add_entry` |
| `Function SparseCount Returns Integer` | Number of regions. | `archive_entry_sparse_count` |
| `Function SparseReset Returns Integer` | Starts an enumeration, returns the count. | `archive_entry_sparse_reset` |
| `Function SparseNext Returns tArchiveEntrySparse` | Next region; `iLength` is -1 at the end. | `archive_entry_sparse_next` |
| `Function SparseEntries Returns tArchiveEntrySparse[]` | All regions. | `archive_entry_sparse_reset`, `archive_entry_sparse_next` |

### Helpers

| Method | Description | libarchive function |
|---|---|---|
| `Function PointerText Pointer pText Returns String` | Converts a zero terminated UTF-8 C string pointer to a string; 0 gives "". | |
| `Function PointerWideText Pointer pText Returns String` | Same for a wide string pointer. | |
| `Function AnsiPointerText Pointer pText Returns String` | Converts a zero terminated string in the ANSI code page (what libarchive returns for ACL names) to a string. | `MultiByteToWideChar` |
| `Function IsValidUtf8 String sText Returns Boolean` | True when the text is valid UTF-8; used by the UTF-8 name setters before they call libarchive. | `MultiByteToWideChar` |

## Example

```
Use cArchiveEntry.pkg

Object oEntry is a cArchiveEntry
End_Object

Send CreateEntry of oEntry
Set psPathname of oEntry to "docs/héllo.txt"          // source file saved as UTF-8 with BOM
Set piMode of oEntry to (AE_IFREG ior 420)              // regular file, 0644
Set piSize of oEntry to 13
Send SetMtime of oEntry 1700000000 0
Set psUname of oEntry to "alice"
Send XattrAddText of oEntry "user.comment" "hello"
Get AclAddEntry of oEntry ARCHIVE_ENTRY_ACL_TYPE_ACCESS 6 ARCHIVE_ENTRY_ACL_USER 1010 "bob" to iResult

// pass ppEntry (oEntry) to archive_write_header, or hand the object to a wrapper writer
```

Inspecting the entry a reader returned:

```
Pointer pEntry
Move (archive_read_next_header (pArchive, AddressOf (pEntry))) to iResult
Send AttachEntry of oEntry pEntry False                 // borrowed: libarchive owns it
Showln (psPathname (oEntry)) (piSize (oEntry))
```

## Notes

- **Hard link and symbolic link share one storage** in libarchive. An entry has either a hard link target or a symbolic link target, never both. Setting `psHardlink` makes the entry a hard link, `psSymlink` a symbolic link. `psLink` / `SetLink*` keep the kind that is set; an entry that has neither becomes a hard link unless `SetLinkToSymlink` was called.
- `piFFlagsSet` / `piFFlagsClear` and the names accepted by `psFFlagsText` depend on the platform libarchive was built for. On Windows the flags are file attributes: `hidden` (bit 2), `rdonly` (1) and `system` (4) set the bit, `nohidden`, `nordonly`, `nosystem` clear it.
- The owner, group and other entries of a POSIX.1e access ACL live in `piMode`. The ACL enumeration (`AclReset`/`AclNext`/`AclCount`/`AclToText`) reports them first, then the extended user/group/mask entries, but only once the ACL has extended entries.
- libarchive lists extended attributes in reverse order of adding. The pax writer stores them in two header forms and a reader reports both.
- `Digest` returns "" for a digest that is all zero bytes (libarchive always returns the digest memory, zero filled when no digest was provided). Digests are provided by the mtree and xar readers.
- `archive_entry_copy_bhfi` copies times, size, inode and link count; it does not set the file type.
- libarchive has no callbacks that apply to entries; nothing is missing from this class because of DataFlex's inability to create C function pointers.

