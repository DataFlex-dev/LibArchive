# Constants

Defined in `Library/AppSrc/Archive.h.pkg` (the same values as the libarchive C headers `archive.h` and `archive_entry.h`). Values written as `|CI$xxxx` are hexadecimal.

### The "flags" argument selects optional behavior, 'OR' the flags you want.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_EXTRACT_OWNER` | `0x0001` | Default: Do not try to set owner/group. |
| `ARCHIVE_EXTRACT_PERM` | `0x0002` | Default: Do obey umask, do not restore SUID/SGID/SVTX bits. |
| `ARCHIVE_EXTRACT_TIME` | `0x0004` | Default: Do not restore mtime/atime. |
| `ARCHIVE_EXTRACT_NO_OVERWRITE` | `0x0008` | Default: Replace existing files. |
| `ARCHIVE_EXTRACT_UNLINK` | `0x0010` | Default: Try create first, unlink only if create fails with EEXIST. |
| `ARCHIVE_EXTRACT_ACL` | `0x0020` | Default: Do not restore ACLs. |
| `ARCHIVE_EXTRACT_FFLAGS` | `0x0040` | Default: Do not restore fflags. |
| `ARCHIVE_EXTRACT_XATTR` | `0x0080` | Default: Do not restore xattrs. |
| `ARCHIVE_EXTRACT_SECURE_SYMLINKS` | `0x0100` | Default: Do not try to guard against extracts redirected by symlinks. Note: With ARCHIVE_EXTRACT_UNLINK, will remove any intermediate symlink. |
| `ARCHIVE_EXTRACT_SECURE_NODOTDOT` | `0x0200` | Default: Do not reject entries with '..' as path elements. |
| `ARCHIVE_EXTRACT_NO_AUTODIR` | `0x0400` | Default: Create parent directories as needed. |
| `ARCHIVE_EXTRACT_NO_OVERWRITE_NEWER` | `0x0800` | Default: Overwrite files, even if one on disk is newer. |
| `ARCHIVE_EXTRACT_SPARSE` | `0x1000` | Detect blocks of 0 and write holes instead. |
| `ARCHIVE_EXTRACT_MAC_METADATA` | `0x2000` | Default: Do not restore Mac extended metadata. This has no effect except on Mac OS. |
| `ARCHIVE_EXTRACT_NO_HFS_COMPRESSION` | `0x4000` | Default: Use HFS+ compression if it was compressed. This has no effect except on Mac OS v10.6 or later. |
| `ARCHIVE_EXTRACT_HFS_COMPRESSION_FORCED` | `0x8000` | Default: Do not use HFS+ compression if it was not compressed. This has no effect except on Mac OS v10.6 or later. |
| `ARCHIVE_EXTRACT_SECURE_NOABSOLUTEPATHS` | `0x10000` | Default: Do not reject entries with absolute paths |
| `ARCHIVE_EXTRACT_CLEAR_NOCHANGE_FFLAGS` | `0x20000` | Default: Do not clear no-change flags when unlinking object |
| `ARCHIVE_EXTRACT_SAFE_WRITES` | `0x40000` | Default: Do not extract atomically (using rename) |

### Codes to identify various stream filters.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_FILTER_NONE` | `0` | none filter |
| `ARCHIVE_FILTER_GZIP` | `1` | gzip filter |
| `ARCHIVE_FILTER_BZIP2` | `2` | bzip2 filter |
| `ARCHIVE_FILTER_COMPRESS` | `3` | compress filter |
| `ARCHIVE_FILTER_PROGRAM` | `4` | program filter |
| `ARCHIVE_FILTER_LZMA` | `5` | lzma filter |
| `ARCHIVE_FILTER_XZ` | `6` | xz filter |
| `ARCHIVE_FILTER_UU` | `7` | uu filter |
| `ARCHIVE_FILTER_RPM` | `8` | rpm filter |
| `ARCHIVE_FILTER_LZIP` | `9` | lzip filter |
| `ARCHIVE_FILTER_LRZIP` | `10` | lrzip filter |
| `ARCHIVE_FILTER_LZOP` | `11` | lzop filter |
| `ARCHIVE_FILTER_GRZIP` | `12` | grzip filter |
| `ARCHIVE_FILTER_LZ4` | `13` | lz4 filter |
| `ARCHIVE_FILTER_ZSTD` | `14` | zstd filter |

### Codes returned by archive_format.

Top 16 bits identifies the format family (e.g., "tar"); lower
16 bits indicate the variant.  This is updated by read_next_header.
Note that the lower 16 bits will often vary from entry to entry.
In some cases, this variation occurs as libarchive learns more about
the archive (for example, later entries might utilize extensions that
weren't necessary earlier in the archive; in this case, libarchive
will change the format code to indicate the extended format that
was used).  In other cases, it's because different tools have
modified the archive and so different parts of the archive
actually have slightly different formats.  (Both tar and cpio store
format codes in each entry, so it is quite possible for each
entry to be in a different format.)

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_FORMAT_BASE_MASK` | `0xFF0000` | Mask that isolates the format family (top 16 bits) from the variant. |
| `ARCHIVE_FORMAT_CPIO` | `0x10000` | cpio format |
| `ARCHIVE_FORMAT_CPIO_POSIX` | `(ARCHIVE_FORMAT_CPIO ior 1)` | cpio posix format |
| `ARCHIVE_FORMAT_CPIO_BIN_LE` | `(ARCHIVE_FORMAT_CPIO ior 2)` | cpio bin le format |
| `ARCHIVE_FORMAT_CPIO_BIN_BE` | `(ARCHIVE_FORMAT_CPIO ior 3)` | cpio bin be format |
| `ARCHIVE_FORMAT_CPIO_SVR4_NOCRC` | `(ARCHIVE_FORMAT_CPIO ior 4)` | cpio svr4 nocrc format |
| `ARCHIVE_FORMAT_CPIO_SVR4_CRC` | `(ARCHIVE_FORMAT_CPIO ior 5)` | cpio svr4 crc format |
| `ARCHIVE_FORMAT_CPIO_AFIO_LARGE` | `(ARCHIVE_FORMAT_CPIO ior 6)` | cpio afio large format |
| `ARCHIVE_FORMAT_CPIO_PWB` | `(ARCHIVE_FORMAT_CPIO ior 7)` | cpio pwb format |
| `ARCHIVE_FORMAT_SHAR` | `0x20000` | shar format |
| `ARCHIVE_FORMAT_SHAR_BASE` | `(ARCHIVE_FORMAT_SHAR ior 1)` | shar base format |
| `ARCHIVE_FORMAT_SHAR_DUMP` | `(ARCHIVE_FORMAT_SHAR ior 2)` | shar dump format |
| `ARCHIVE_FORMAT_TAR` | `0x30000` | tar format |
| `ARCHIVE_FORMAT_TAR_USTAR` | `(ARCHIVE_FORMAT_TAR ior 1)` | tar ustar format |
| `ARCHIVE_FORMAT_TAR_PAX_INTERCHANGE` | `(ARCHIVE_FORMAT_TAR ior 2)` | tar pax interchange format |
| `ARCHIVE_FORMAT_TAR_PAX_RESTRICTED` | `(ARCHIVE_FORMAT_TAR ior 3)` | tar pax restricted format |
| `ARCHIVE_FORMAT_TAR_GNUTAR` | `(ARCHIVE_FORMAT_TAR ior 4)` | tar gnutar format |
| `ARCHIVE_FORMAT_ISO9660` | `0x40000` | iso9660 format |
| `ARCHIVE_FORMAT_ISO9660_ROCKRIDGE` | `(ARCHIVE_FORMAT_ISO9660 ior 1)` | iso9660 rockridge format |
| `ARCHIVE_FORMAT_ZIP` | `0x50000` | zip format |
| `ARCHIVE_FORMAT_EMPTY` | `0x60000` | empty format |
| `ARCHIVE_FORMAT_AR` | `0x70000` | ar format |
| `ARCHIVE_FORMAT_AR_GNU` | `(ARCHIVE_FORMAT_AR ior 1)` | ar gnu format |
| `ARCHIVE_FORMAT_AR_BSD` | `(ARCHIVE_FORMAT_AR ior 2)` | ar bsd format |
| `ARCHIVE_FORMAT_MTREE` | `0x80000` | mtree format |
| `ARCHIVE_FORMAT_RAW` | `0x90000` | raw format |
| `ARCHIVE_FORMAT_XAR` | `0xA0000` | xar format |
| `ARCHIVE_FORMAT_LHA` | `0xB0000` | lha format |
| `ARCHIVE_FORMAT_CAB` | `0xC0000` | cab format |
| `ARCHIVE_FORMAT_RAR` | `0xD0000` | rar format |
| `ARCHIVE_FORMAT_7ZIP` | `0xE0000` | 7zip format |
| `ARCHIVE_FORMAT_WARC` | `0xF0000` | warc format |
| `ARCHIVE_FORMAT_RAR_V5` | `0x100000` | rar v5 format |

### File types

| Constant | Value | Meaning |
|---|---|---|
| `AE_IFMT` | `0xF000` | used to isolate the file type bits from a file mode value. |
| `AE_IFREG` | `0x8000` | Regular file |
| `AE_IFLNK` | `0xA000` | Symbolic link |
| `AE_IFSOCK` | `0xC000` | Socket |
| `AE_IFCHR` | `0x2000` | Character device |
| `AE_IFBLK` | `0x6000` | Block device |
| `AE_IFDIR` | `0x4000` | Directory |
| `AE_IFIFO` | `0x1000` | FIFO (named pipe) |

### Permission bits.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_ENTRY_ACL_EXECUTE` | `0x00000001` | execute (ACL constant) |
| `ARCHIVE_ENTRY_ACL_WRITE` | `0x00000002` | write (ACL constant) |
| `ARCHIVE_ENTRY_ACL_READ` | `0x00000004` | read (ACL constant) |
| `ARCHIVE_ENTRY_ACL_READ_DATA` | `0x00000008` | read data (ACL constant) |
| `ARCHIVE_ENTRY_ACL_LIST_DIRECTORY` | `0x00000008` | list directory (ACL constant) |
| `ARCHIVE_ENTRY_ACL_WRITE_DATA` | `0x00000010` | write data (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ADD_FILE` | `0x00000010` | add file (ACL constant) |
| `ARCHIVE_ENTRY_ACL_APPEND_DATA` | `0x00000020` | append data (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ADD_SUBDIRECTORY` | `0x00000020` | add subdirectory (ACL constant) |
| `ARCHIVE_ENTRY_ACL_READ_NAMED_ATTRS` | `0x00000040` | read named attrs (ACL constant) |
| `ARCHIVE_ENTRY_ACL_WRITE_NAMED_ATTRS` | `0x00000080` | write named attrs (ACL constant) |
| `ARCHIVE_ENTRY_ACL_DELETE_CHILD` | `0x00000100` | delete child (ACL constant) |
| `ARCHIVE_ENTRY_ACL_READ_ATTRIBUTES` | `0x00000200` | read attributes (ACL constant) |
| `ARCHIVE_ENTRY_ACL_WRITE_ATTRIBUTES` | `0x00000400` | write attributes (ACL constant) |
| `ARCHIVE_ENTRY_ACL_DELETE` | `0x00000800` | delete (ACL constant) |
| `ARCHIVE_ENTRY_ACL_READ_ACL` | `0x00001000` | read acl (ACL constant) |
| `ARCHIVE_ENTRY_ACL_WRITE_ACL` | `0x00002000` | write acl (ACL constant) |
| `ARCHIVE_ENTRY_ACL_WRITE_OWNER` | `0x00004000` | write owner (ACL constant) |
| `ARCHIVE_ENTRY_ACL_SYNCHRONIZE` | `0x00008000` | synchronize (ACL constant) |
| `ARCHIVE_ENTRY_ACL_PERMS_POSIX1E` | `(ARCHIVE_ENTRY_ACL_EXECUTE ior ARCHIVE_ENTRY_ACL_WRITE ior ARCHIVE_ENTRY_ACL_READ)` | perms posix1e (ACL constant) |
| `ARCHIVE_ENTRY_ACL_PERMS_NFS4` | `(ARCHIVE_ENTRY_ACL_EXECUTE ior ARCHIVE_ENTRY_ACL_READ_DATA ior ARCHIVE_ENTRY_ACL_LIST_DIRECTORY ior ARCHIVE_ENTRY_ACL_WRITE_DATA ior ARCHIVE_ENTRY_ACL_ADD_FILE ior ARCHIVE_ENTRY_ACL_APPEND_DATA ior ARCHIVE_ENTRY_ACL_ADD_SUBDIRECTORY ior ARCHIVE_ENTRY_ACL_READ_NAMED_ATTRS ior ARCHIVE_ENTRY_ACL_WRITE_NAMED_ATTRS ior ARCHIVE_ENTRY_ACL_DELETE_CHILD ior ARCHIVE_ENTRY_ACL_READ_ATTRIBUTES ior ARCHIVE_ENTRY_ACL_WRITE_ATTRIBUTES ior ARCHIVE_ENTRY_ACL_DELETE ior ARCHIVE_ENTRY_ACL_READ_ACL ior ARCHIVE_ENTRY_ACL_WRITE_ACL ior ARCHIVE_ENTRY_ACL_WRITE_OWNER ior ARCHIVE_ENTRY_ACL_SYNCHRONIZE)` | perms nfs4 (ACL constant) |

### Inheritance values (NFS4 ACLs only); included in permset.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_ENTRY_ACL_ENTRY_INHERITED` | `0x01000000` | entry inherited (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ENTRY_FILE_INHERIT` | `0x02000000` | entry file inherit (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ENTRY_DIRECTORY_INHERIT` | `0x04000000` | entry directory inherit (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ENTRY_NO_PROPAGATE_INHERIT` | `0x08000000` | entry no propagate inherit (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ENTRY_INHERIT_ONLY` | `0x10000000` | entry inherit only (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ENTRY_SUCCESSFUL_ACCESS` | `0x20000000` | entry successful access (ACL constant) |
| `ARCHIVE_ENTRY_ACL_ENTRY_FAILED_ACCESS` | `0x40000000` | entry failed access (ACL constant) |
| `ARCHIVE_ENTRY_ACL_INHERITANCE_NFS4` | `(ARCHIVE_ENTRY_ACL_ENTRY_FILE_INHERIT ior ARCHIVE_ENTRY_ACL_ENTRY_DIRECTORY_INHERIT ior ARCHIVE_ENTRY_ACL_ENTRY_NO_PROPAGATE_INHERIT ior ARCHIVE_ENTRY_ACL_ENTRY_INHERIT_ONLY ior ARCHIVE_ENTRY_ACL_ENTRY_SUCCESSFUL_ACCESS ior ARCHIVE_ENTRY_ACL_ENTRY_FAILED_ACCESS ior ARCHIVE_ENTRY_ACL_ENTRY_INHERITED)` | inheritance nfs4 (ACL constant) |

### We need to be able to specify combinations of these.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_ENTRY_ACL_TYPE_ACCESS` | `0x00000100` | type access (ACL constant) |
| `ARCHIVE_ENTRY_ACL_TYPE_DEFAULT` | `0x00000200` | type default (ACL constant) |
| `ARCHIVE_ENTRY_ACL_TYPE_ALLOW` | `0x00000400` | type allow (ACL constant) |
| `ARCHIVE_ENTRY_ACL_TYPE_DENY` | `0x00000800` | type deny (ACL constant) |
| `ARCHIVE_ENTRY_ACL_TYPE_AUDIT` | `0x00001000` | type audit (ACL constant) |
| `ARCHIVE_ENTRY_ACL_TYPE_ALARM` | `0x00002000` | type alarm (ACL constant) |
| `ARCHIVE_ENTRY_ACL_TYPE_POSIX1E` | `(ARCHIVE_ENTRY_ACL_TYPE_ACCESS ior ARCHIVE_ENTRY_ACL_TYPE_DEFAULT)` | type posix1e (ACL constant) |
| `ARCHIVE_ENTRY_ACL_TYPE_NFS4` | `(ARCHIVE_ENTRY_ACL_TYPE_ALLOW ior ARCHIVE_ENTRY_ACL_TYPE_DENY ior ARCHIVE_ENTRY_ACL_TYPE_AUDIT ior ARCHIVE_ENTRY_ACL_TYPE_ALARM)` | type nfs4 (ACL constant) |

### Tag values mimic POSIX.1e

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_ENTRY_ACL_USER` | `10001` | Specified user. |
| `ARCHIVE_ENTRY_ACL_USER_OBJ` | `10002` | User who owns the file. |
| `ARCHIVE_ENTRY_ACL_GROUP` | `10003` | Specified group. |
| `ARCHIVE_ENTRY_ACL_GROUP_OBJ` | `10004` | Group who owns the file. |
| `ARCHIVE_ENTRY_ACL_MASK` | `10005` | Modify group access (POSIX.1e only) |
| `ARCHIVE_ENTRY_ACL_OTHER` | `10006` | Public (POSIX.1e only) |
| `ARCHIVE_ENTRY_ACL_EVERYONE` | `10107` | Everyone (NFS4 only). |

### Result codes

Returned by most libarchive functions (`int`). Use `archive_errno()` and `archive_error_string()` to retrieve details of a failure. A result of `ARCHIVE_FAILED` or worse is reported as a DataFlex error by the wrapper classes (see `cArchiveBase`).

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_EOF` | `1` | Found end of archive. |
| `ARCHIVE_OK` | `0` | Operation was successful. |
| `ARCHIVE_RETRY` | `-10` | Retry might succeed. |
| `ARCHIVE_WARN` | `-20` | Partial success. |
| `ARCHIVE_FAILED` | `-25` | Current operation cannot complete (for example write_header "fails": you cannot push data). |
| `ARCHIVE_FATAL` | `-30` | No more operations are possible: the archive is dead and useless. |

### Permission values

Decimal values of the usual octal permission masks, for `archive_entry_set_perm`.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_READ_WRITE_EXECUTE_FOR_ALL` | `511` | 0777 rwxrwxrwx Read/Write/execute for All |
| `ARCHIVE_COMMON_FOR_EXECUTABLE_FILES_AND_DIRS` | `493` | 0755 rwxr-xr-x Common for executable files/dirs |
| `ARCHIVE_FOR_REGULAR_FILES` | `420` | 0644 rw-r--r-- Common for regular files |
| `ARCHIVE_PRIVATE_USER_READABLE_WRITEABLE` | `384` | 0600 rw------- Private user-readable/writeable |
| `ARCHIVE_USER_ONLY_FULL_ACCESS` | `448` | 0700 rwx------ User-only full access |

### Read disk behavior flags

Flags for `archive_read_disk_set_behavior`.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_READDISK_RESTORE_ATIME` | `0x0001` | Request that the access time of the entry visited by traversal be restored (same as archive_read_disk_set_atime_restored). |
| `ARCHIVE_READDISK_HONOR_NODUMP` | `0x0002` | Default: Do not skip an entry which has nodump flags. |
| `ARCHIVE_READDISK_MAC_COPYFILE` | `0x0004` | Default: Skip a mac resource fork file whose prefix is "._" because of using copyfile. |
| `ARCHIVE_READDISK_NO_TRAVERSE_MOUNTS` | `0x0008` | Default: Traverse mount points. |
| `ARCHIVE_READDISK_NO_XATTR` | `0x0010` | Default: Xattrs are read from disk. |
| `ARCHIVE_READDISK_NO_ACL` | `0x0020` | Default: ACLs are read from disk. |
| `ARCHIVE_READDISK_NO_FFLAGS` | `0x0040` | Default: File flags are read from disk. |
| `ARCHIVE_READDISK_NO_SPARSE` | `0x0080` | Default: Sparse file information is read from disk. |

### Codes returned by archive_read_format_capabilities().

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_READ_FORMAT_CAPS_NONE` | `0` | No special capabilities. |
| `ARCHIVE_READ_FORMAT_CAPS_ENCRYPT_DATA` | `1` | The reader can detect encrypted data. |
| `ARCHIVE_READ_FORMAT_CAPS_ENCRYPT_METADATA` | `2` | The reader can detect encryptable metadata (pathname, mtime, etc.). |

### Codes returned by archive_read_has_encrypted_entries() when it cannot tell.

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_READ_FORMAT_ENCRYPTION_UNSUPPORTED` | `-2` | The format does not support encryption detection at all. |
| `ARCHIVE_READ_FORMAT_ENCRYPTION_DONT_KNOW` | `-1` | Not enough data read so far to tell. |

### Symlink types (archive_entry_symlink_type / archive_entry_set_symlink_type)

| Constant | Value | Meaning |
|---|---|---|
| `AE_SYMLINK_TYPE_UNDEFINED` | `0` | The type of the link target is not known. |
| `AE_SYMLINK_TYPE_FILE` | `1` | The link points to a file. |
| `AE_SYMLINK_TYPE_DIRECTORY` | `2` | The link points to a directory. |

### Digest types for archive_entry_digest()

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_ENTRY_DIGEST_MD5` | `1` | MD5 digest |
| `ARCHIVE_ENTRY_DIGEST_RMD160` | `2` | RIPEMD-160 digest |
| `ARCHIVE_ENTRY_DIGEST_SHA1` | `3` | SHA-1 digest |
| `ARCHIVE_ENTRY_DIGEST_SHA256` | `4` | SHA-256 digest |
| `ARCHIVE_ENTRY_DIGEST_SHA384` | `5` | SHA-384 digest |
| `ARCHIVE_ENTRY_DIGEST_SHA512` | `6` | SHA-512 digest |

### Flags for archive_entry_acl_to_text()

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_ENTRY_ACL_STYLE_EXTRA_ID` | `0x00000001` | Include an extra numeric ID field in each ACL entry. |
| `ARCHIVE_ENTRY_ACL_STYLE_MARK_DEFAULT` | `0x00000002` | Include "default:" before each default ACL entry (POSIX.1e only). |
| `ARCHIVE_ENTRY_ACL_STYLE_SOLARIS` | `0x00000004` | Output only one colon after "other" and "mask" entries (POSIX.1e only). |
| `ARCHIVE_ENTRY_ACL_STYLE_SEPARATOR_COMMA` | `0x00000008` | Separate entries with a comma instead of a newline. |
| `ARCHIVE_ENTRY_ACL_STYLE_COMPACT` | `0x00000010` | Do not output the minus character for unset NFSv4 permissions and flags. |

### Flags for the archive_match_include_time / _date / _file_time / archive_match_exclude_entry function

| Constant | Value | Meaning |
|---|---|---|
| `ARCHIVE_MATCH_MTIME` | `0x0100` | Time flag: mtime to be tested. |
| `ARCHIVE_MATCH_CTIME` | `0x0200` | Time flag: ctime to be tested. |
| `ARCHIVE_MATCH_NEWER` | `0x0001` | Comparison flag: Match the time if it is newer than. |
| `ARCHIVE_MATCH_OLDER` | `0x0002` | Comparison flag: Match the time if it is older than. |
| `ARCHIVE_MATCH_EQUAL` | `0x0010` | Comparison flag: Match the time if it is equal to. |

### The external function declarations, grouped by area.
