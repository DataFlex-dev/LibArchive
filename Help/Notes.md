# Notes: libarchive 3.7.7 on Windows

Behavior of the shipped `archive.dll` that differs from what the libarchive documentation (or the C headers) suggest. All of it was verified by the unit tests in `Demo/AppSrc/Tests`. The wrapper classes handle most of these cases for you.

## Strings and file names

- Strings are UTF-8. **A DataFlex source file needs a BOM** to contain UTF-8 string literals; without it a non-ASCII literal is not valid UTF-8, the entry pathname becomes NULL and `archive_write_header` crashes the program (silent exit code 5).
- Narrow (`char *`) functions that take file names or patterns (`archive_read_open_filename`, `archive_write_open_filename`, `archive_read_disk_open`, `archive_match_*_pattern`, ...) interpret them in the ANSI code page. Use the `_w` variants (pass a `WString` with `AddressOf`) for names with other characters. The wrapper classes do.
- Writing a pathname with characters outside the ANSI code page (for example `a-€-b.txt`) with `archive_entry_set_pathname_utf8` crashes the zip writer unless the writer option `hdrcharset=UTF-8` is set. `cArchiveWriter` sets it by default (`pbUtf8HeaderCharset`). cpio refuses such names, 7zip garbles non-ASCII names set with `archive_entry_set_pathname_utf8` (use `archive_entry_update_pathname_utf8`).
- When reading with `hdrcharset=UTF-8` libarchive returns `ARCHIVE_WARN` for names it cannot convert to the locale and an empty pathname. `cArchiveReader.pbUtf8HeaderCharset` therefore defaults to False.
- `archive_entry_update_*_utf8` returns 0 when the text cannot be converted to the locale without loss; libarchive keeps the text anyway.

## C runtime objects

`archive.dll` uses the universal C runtime. File descriptors (`archive_read_open_fd`, `archive_write_open_fd`, `archive_read_data_into_fd`) and `FILE` pointers (`archive_read_open_FILE_Ptr`, `archive_write_open_FILE_Ptr`) must be created with `ucrtbase.dll` (`_open`, `_wfopen`), not with `msvcrt.dll`. Memory returned by `archive_entry_acl_to_text(_w)` is malloc'ed and must be freed with `free` from `ucrtbase.dll`.

## Crashes to avoid

| Call | Problem |
|---|---|
| `archive_read_append_filter (ARCHIVE_FILTER_COMPRESS)` | Access violation. Use `archive_read_support_filter_compress`. |
| Registering the RAR 5 reader twice on one handle | Crash. |
| Registering more than 16 format readers or 16 filter readers on one handle | Crash. |
| Opening a read handle a second time (even after a failed open) | Heap corruption. Create a new handle. |
| `archive_write_free` on a handle opened with callbacks of 0 without close | Crash. Call `archive_write_fail` first. |
| `archive_entry_acl_add_entry_w` with a NULL name | Crash in `wcslen` (an empty `WString` is NULL). |
| `archive_entry_linkresolver_free` with deferred entries (cpio SVR4 strategy) | Entries are freed twice. Flush with `archive_entry_linkify` first (`cArchiveLinkResolver` does). |
| A NULL pathname in `archive_write_header` | Crash. |

## Result codes that differ from the documentation

- `archive_write_fail` returns 32768, not `ARCHIVE_FATAL`; `archive_write_data_block` returns 0 on success.
- The `archive_entry_*_is_set` functions return a non-zero flag, not necessarily 1.
- Unknown options: `archive_read_set_*option` / `archive_write_set_*option` return `ARCHIVE_FAILED`, not `ARCHIVE_WARN`.
- `archive_seek_data` returns `ARCHIVE_FATAL` for tar, zip, 7zip, cpio and ISO 9660; after `archive_read_data_skip` or `ARCHIVE_EOF` further data and header reads return `ARCHIVE_FATAL`.
- `archive_read_append_filter_program(_signature)` with a missing program returns `ARCHIVE_FATAL` at once.
- `archive_write_set_format` by code cannot select ar or cpio SVR4 with CRC (`ARCHIVE_FATAL`) and selects ustar for `ARCHIVE_FORMAT_TAR`; `archive_write_add_filter_by_name ("none")` returns `ARCHIVE_FATAL`.
- `archive_write_set_format_filter_by_ext` knows `.zip .jar .7z .tar .tgz .tar.gz .tar.bz2 .tar.xz .cpio .iso .a .ar` only.
- `ARCHIVE_EXTRACT_NO_OVERWRITE` / `_NO_OVERWRITE_NEWER`: `archive_write_header` returns `ARCHIVE_FATAL` for an existing file.
- `archive_read_disk_current_filesystem_is_synthetic` returns -1 (unknown).
- `archive_entry_digest` returns pointer to zero bytes (not NULL) when the entry has no digest.

## Not available in this build

- XAR: `archive_read_support_format_xar` and `archive_write_set_format_xar` return `ARCHIVE_WARN` ("Xar not supported on this platform").
- `archive_write_set_format_ar_gnu` does not exist in the DLL (GNU ar archives are written with `archive_write_set_format_ar_svr4`).
- lzop, lrzip, grzip filters need the external programs; adding them returns `ARCHIVE_WARN`, opening fails without the program.
- `archive_read_disk_set_standard_lookup` returns `ARCHIVE_FATAL` on Windows; `archive_read_disk_uname` / `_gname` return NULL. (`archive_write_disk_set_standard_lookup` succeeds; unknown names give the default id.)
- `archive_read_extract_set_skip_file` and `archive_write_disk_set_skip_file` have no useful effect on Windows (no device/inode numbers). `archive_file_count` stays 0 on a read disk handle.
- No callbacks from DataFlex (no native function pointers): all `*_callback` functions, `archive_read_open`, `archive_read_open2`, `archive_write_open`, `archive_write_open2`, passphrase and lookup callbacks, progress and metadata filter callbacks can only be called with 0.

## Format notes

- Zip: the streamable zip reader reports size 0 in the header; the seekable reader (default with a file or memory) reports the real size. The zip reader reports `ARCHIVE_READ_FORMAT_CAPS_ENCRYPT_DATA or _ENCRYPT_METADATA`.
- 7zip stores directories after files.
- The WARC reader returns 4 extra bytes (CRLFCRLF) after the data of an entry.
- `archive_write_open_FILE` pads the output to 10240 bytes; ustar defaults to no padding of the last block.
- Encrypted zip: `zip:encryption=zipcrypt|aes128|aes256` with `archive_write_set_passphrase`; read with `archive_read_add_passphrase`.
- `archive_entry_stat` returns a `struct _stat64i32` (32 bit size at offset 20). `archive_entry_copy_bhfi` copies times, size, inode and link count but not type or permissions.
- File flags on Windows: `rdonly`, `hidden`, `system` (and the `no` prefixed forms).
- A hard link and a symbolic link share one storage in an entry: an entry has one or the other.

## DataFlex pitfalls found while writing the wrapper

- Names (including external functions) are not case sensitive.
- A function used in an expression must be defined before use in the class.
- Arithmetic in expressions is evaluated left to right without operator precedence; `*` between a string and a number multiplies.
- An uninitialized local `BigInt` is not zero.
- `Case` labels fall through until `Case Break`.
- `ExpectError` (DFUnit) stays active until `UnExpectError`.
