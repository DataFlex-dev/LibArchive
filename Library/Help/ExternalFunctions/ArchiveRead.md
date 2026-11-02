# ArchiveRead.h.pkg

Functions to read archives (archive_read_*).

Source: `Library/AppSrc/ArchiveRead.h.pkg`. All functions are declared with `External_Function <name> "<export>" archive.dll`; the DataFlex name equals the DLL export unless noted. Pointers to libarchive objects are `Pointer`; strings are passed as `Pointer` to a NUL terminated string (`AddressOf (sValue)`) and returned as `Pointer` (use `PointerToString`).

## Index


**Create and free**

- [`archive_read_new`](#archive_read_new)
- [`archive_read_close`](#archive_read_close)
- [`archive_read_free`](#archive_read_free)

**Format support**

- [`archive_read_support_format_7zip`](#archive_read_support_format_7zip)
- [`archive_read_support_format_all`](#archive_read_support_format_all)
- [`archive_read_support_format_ar`](#archive_read_support_format_ar)
- [`archive_read_support_format_by_code`](#archive_read_support_format_by_code)
- [`archive_read_support_format_cab`](#archive_read_support_format_cab)
- [`archive_read_support_format_cpio`](#archive_read_support_format_cpio)
- [`archive_read_support_format_empty`](#archive_read_support_format_empty)
- [`archive_read_support_format_gnutar`](#archive_read_support_format_gnutar)
- [`archive_read_support_format_iso9660`](#archive_read_support_format_iso9660)
- [`archive_read_support_format_lha`](#archive_read_support_format_lha)
- [`archive_read_support_format_mtree`](#archive_read_support_format_mtree)
- [`archive_read_support_format_rar`](#archive_read_support_format_rar)
- [`archive_read_support_format_rar5`](#archive_read_support_format_rar5)
- [`archive_read_support_format_raw`](#archive_read_support_format_raw)
- [`archive_read_support_format_tar`](#archive_read_support_format_tar)
- [`archive_read_support_format_warc`](#archive_read_support_format_warc)
- [`archive_read_support_format_xar`](#archive_read_support_format_xar)
- [`archive_read_support_format_zip`](#archive_read_support_format_zip)
- [`archive_read_support_format_zip_streamable`](#archive_read_support_format_zip_streamable)
- [`archive_read_support_format_zip_seekable`](#archive_read_support_format_zip_seekable)
- [`archive_read_set_format`](#archive_read_set_format)

**Filter support**

- [`archive_read_support_filter_all`](#archive_read_support_filter_all)
- [`archive_read_support_filter_by_code`](#archive_read_support_filter_by_code)
- [`archive_read_support_filter_bzip2`](#archive_read_support_filter_bzip2)
- [`archive_read_support_filter_compress`](#archive_read_support_filter_compress)
- [`archive_read_support_filter_gzip`](#archive_read_support_filter_gzip)
- [`archive_read_support_filter_grzip`](#archive_read_support_filter_grzip)
- [`archive_read_support_filter_lrzip`](#archive_read_support_filter_lrzip)
- [`archive_read_support_filter_lz4`](#archive_read_support_filter_lz4)
- [`archive_read_support_filter_lzip`](#archive_read_support_filter_lzip)
- [`archive_read_support_filter_lzma`](#archive_read_support_filter_lzma)
- [`archive_read_support_filter_lzop`](#archive_read_support_filter_lzop)
- [`archive_read_support_filter_none`](#archive_read_support_filter_none)
- [`archive_read_support_filter_program`](#archive_read_support_filter_program)
- [`archive_read_support_filter_program_signature`](#archive_read_support_filter_program_signature)
- [`archive_read_support_filter_rpm`](#archive_read_support_filter_rpm)
- [`archive_read_support_filter_uu`](#archive_read_support_filter_uu)
- [`archive_read_support_filter_xz`](#archive_read_support_filter_xz)
- [`archive_read_support_filter_zstd`](#archive_read_support_filter_zstd)
- [`archive_read_append_filter`](#archive_read_append_filter)
- [`archive_read_append_filter_program`](#archive_read_append_filter_program)
- [`archive_read_append_filter_program_signature`](#archive_read_append_filter_program_signature)

**Callbacks and client data**

- [`archive_read_set_open_callback`](#archive_read_set_open_callback)
- [`archive_read_set_read_callback`](#archive_read_set_read_callback)
- [`archive_read_set_seek_callback`](#archive_read_set_seek_callback)
- [`archive_read_set_skip_callback`](#archive_read_set_skip_callback)
- [`archive_read_set_close_callback`](#archive_read_set_close_callback)
- [`archive_read_set_switch_callback`](#archive_read_set_switch_callback)
- [`archive_read_set_callback_data`](#archive_read_set_callback_data)
- [`archive_read_set_callback_data2`](#archive_read_set_callback_data2)
- [`archive_read_add_callback_data`](#archive_read_add_callback_data)
- [`archive_read_append_callback_data`](#archive_read_append_callback_data)
- [`archive_read_prepend_callback_data`](#archive_read_prepend_callback_data)

**Open**

- [`archive_read_open1`](#archive_read_open1)
- [`archive_read_open`](#archive_read_open)
- [`archive_read_open2`](#archive_read_open2)
- [`archive_read_open_filename`](#archive_read_open_filename)
- [`archive_read_open_filename_w`](#archive_read_open_filename_w)
- [`archive_read_open_filenames`](#archive_read_open_filenames)
- [`archive_read_open_filenames_w`](#archive_read_open_filenames_w)
- [`archive_read_open_file`](#archive_read_open_file)
- [`archive_read_open_memory`](#archive_read_open_memory)
- [`archive_read_open_memory2`](#archive_read_open_memory2)
- [`archive_read_open_fd`](#archive_read_open_fd)
- [`archive_read_open_FILE_Ptr`](#archive_read_open_file_ptr)

**Entries and data**

- [`archive_read_next_header`](#archive_read_next_header)
- [`archive_read_next_header2`](#archive_read_next_header2)
- [`archive_read_header_position`](#archive_read_header_position)
- [`archive_read_has_encrypted_entries`](#archive_read_has_encrypted_entries)
- [`archive_read_format_capabilities`](#archive_read_format_capabilities)
- [`archive_read_data`](#archive_read_data)
- [`archive_seek_data`](#archive_seek_data)
- [`archive_read_data_block`](#archive_read_data_block)
- [`archive_read_data_skip`](#archive_read_data_skip)
- [`archive_read_data_into_fd`](#archive_read_data_into_fd)

**Options and passphrases**

- [`archive_read_set_format_option`](#archive_read_set_format_option)
- [`archive_read_set_filter_option`](#archive_read_set_filter_option)
- [`archive_read_set_option`](#archive_read_set_option)
- [`archive_read_set_options`](#archive_read_set_options)
- [`archive_read_add_passphrase`](#archive_read_add_passphrase)
- [`archive_read_set_passphrase_callback`](#archive_read_set_passphrase_callback)

**Extract**

- [`archive_read_extract`](#archive_read_extract)
- [`archive_read_extract2`](#archive_read_extract2)
- [`archive_read_extract_set_progress_callback`](#archive_read_extract_set_progress_callback)
- [`archive_read_extract_set_skip_file`](#archive_read_extract_set_skip_file)

**Deprecated**

- [`archive_read_finish`](#archive_read_finish)
- [`archive_read_support_compression_all`](#archive_read_support_compression_all)
- [`archive_read_support_compression_bzip2`](#archive_read_support_compression_bzip2)
- [`archive_read_support_compression_compress`](#archive_read_support_compression_compress)
- [`archive_read_support_compression_gzip`](#archive_read_support_compression_gzip)
- [`archive_read_support_compression_lzip`](#archive_read_support_compression_lzip)
- [`archive_read_support_compression_lzma`](#archive_read_support_compression_lzma)
- [`archive_read_support_compression_none`](#archive_read_support_compression_none)
- [`archive_read_support_compression_program`](#archive_read_support_compression_program)
- [`archive_read_support_compression_program_signature`](#archive_read_support_compression_program_signature)
- [`archive_read_support_compression_rpm`](#archive_read_support_compression_rpm)
- [`archive_read_support_compression_uu`](#archive_read_support_compression_uu)
- [`archive_read_support_compression_xz`](#archive_read_support_compression_xz)

## Reference

### Create and free

#### archive_read_new

```
Pointer archive_read_new ()
```

Basic outline for reading an archive:
1) Ask archive_read_new for an archive reader object.
2) Update any global properties as appropriate.
In particular, you'll certainly want to call appropriate
archive_read_support_XXX functions.
3) Call archive_read_open_XXX to open the archive
4) Repeatedly call archive_read_next_header to get information about
successive archive entries.  Call archive_read_data to extract
data for entries of interest.
5) Call archive_read_free to end processing.

archive_read_new() is a Function in the libarchive library that allocates and initializes a new archive Object for reading.

According to the libarchive documentation, this function returns a pointer to a newly created struct archive object. This object is then used for subsequent operations related to reading an archive, such as setting options, adding format and filter support, and actually reading the archive.

Here's a breakdown of what archive_read_new() does:

Allocation: It allocates memory for a new struct archive structure.
Initialization: It initializes the internal state of this newly allocated structure, preparing it for reading operations.
After calling archive_read_new(), you would typically proceed by:

Setting options using functions like archive_read_set_options().
Enabling support for specific archive formats using functions like archive_read_support_format_all() or archive_read_support_format_tar().
Enabling support for compression filters using functions like archive_read_support_filter_all() or archive_read_support_filter_gzip().
Setting the file or data source to read from using functions like archive_read_open_filename() or archive_read_open_memory().
Finally, you would use functions like archive_read_next_header() and archive_read_data() to iterate through and extract the contents of the archive. Don't forget to call archive_read_free() when you are finished with the archive object to release the allocated memory.

In summary, archive_read_new() is the first essential step when you want to read an archive using the libarchive library, as it provides you with the necessary archive reading context.

> **Note:** A reader has 16 slots for format readers and 16 for filter readers; registering more on one handle crashes.

Returns: `Pointer`

#### archive_read_close

```
Integer archive_read_close (Pointer pArchive)
```

Closes the archive and releases most resources. archive_read_free calls it for you.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_free

```
Integer archive_read_free (Pointer pArchive)
```

Closes the archive (when still open), releases all resources and invalidates the handle.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

### Format support

#### archive_read_support_format_7zip

```
Integer archive_read_support_format_7zip (Pointer pArchive)
```

Enables reading of 7-Zip archives.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_all

```
Integer archive_read_support_format_all (Pointer pArchive)
```

archive_read_support_format_all(struct archive *) is a function in the libarchive library that enables support for reading all archive formats currently supported by the library.

According to the manual pages, calling this function allows libarchive to automatically detect and handle various archive formats when reading an archive.

Here's a list of archive formats that libarchive can typically read (this list might vary slightly depending on the libarchive version):

7-zip
Ar (including GNU/SysV and BSD extensions)
CAB
Cpio (and its variants like odc and newc)
ISO9660 (including Rock Ridge and Joliet extensions)
LHA/LZH
Mtree
RAR (and most RAR5)
Shar
Tar (including old-style, ustar, pax, and GNU extensions)
WARC
XAR
Zip
Calling archive_read_support_format_all() generally includes support for all of these formats, except for the "raw" format, which treats any data stream as a single-entry archive. The "raw" format is not enabled by archive_read_support_format_all() to avoid potential misinterpretation of damaged archives.

Therefore, when you call archive_read_support_format_all(), you are telling libarchive to be ready to handle and automatically detect any of these supported archive formats when you attempt to read an archive.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_ar

```
Integer archive_read_support_format_ar (Pointer pArchive)
```

Enables reading of ar archives.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_by_code

```
Integer archive_read_support_format_by_code (Pointer pArchive, Integer iFormatCode)
```

used for reading and writing streaming archives in various formats (like tar, zip, etc.). This specific function allows you to enable support for a particular archive format by specifying its format code.

eFormatcode: is an integer constant representing the format (e.g., ARCHIVE_FORMAT_TAR, ARCHIVE_FORMAT_ZIP).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFormatCode` | `Integer` |

Returns: `Integer`

#### archive_read_support_format_cab

```
Integer archive_read_support_format_cab (Pointer pArchive)
```

Enables reading of Microsoft CAB archives.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_cpio

```
Integer archive_read_support_format_cpio (Pointer pArchive)
```

Enables reading of cpio archives (all variants).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_empty

```
Integer archive_read_support_format_empty (Pointer pArchive)
```

Enables reading of empty (zero byte) archives; they report no entries instead of an error.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_gnutar

```
Integer archive_read_support_format_gnutar (Pointer pArchive)
```

Enables reading of GNU tar archives (and the tar variants it can detect).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_iso9660

```
Integer archive_read_support_format_iso9660 (Pointer pArchive)
```

Enables reading of ISO 9660 images (including Rock Ridge and Joliet).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_lha

```
Integer archive_read_support_format_lha (Pointer pArchive)
```

Enables reading of LHA/LZH archives.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_mtree

```
Integer archive_read_support_format_mtree (Pointer pArchive)
```

Enables reading of mtree manifests.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_rar

```
Integer archive_read_support_format_rar (Pointer pArchive)
```

Enables reading of RAR archives (up to version 4).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_rar5

```
Integer archive_read_support_format_rar5 (Pointer pArchive)
```

Enables reading of RAR 5 archives.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Registering the rar5 reader twice on one handle (also via archive_read_support_format_all after it) crashes libarchive 3.7.7.

Returns: `Integer`

#### archive_read_support_format_raw

```
Integer archive_read_support_format_raw (Pointer pArchive)
```

Enables the raw format, which presents any data stream as a single-entry archive.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_tar

```
Integer archive_read_support_format_tar (Pointer pArchive)
```

Enables reading of tar archives (v7, ustar, pax and GNU variants).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_warc

```
Integer archive_read_support_format_warc (Pointer pArchive)
```

Enables reading of WARC web archives.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_xar

```
Integer archive_read_support_format_xar (Pointer pArchive)
```

Enables reading of XAR archives.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** This archive.dll has no XAR support: the function returns ARCHIVE_WARN ("Xar not supported on this platform").

Returns: `Integer`

#### archive_read_support_format_zip

```
Integer archive_read_support_format_zip (Pointer pArchive)
```

archive_read_support_format_zip() enables both streamable and seekable zip readers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_zip_streamable

```
Integer archive_read_support_format_zip_streamable (Pointer pArchive)
```

Reads Zip archives as stream from beginning to end. Doesn't
correctly handle SFX ZIP files or ZIP archives that have been modified in-place.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_format_zip_seekable

```
Integer archive_read_support_format_zip_seekable (Pointer pArchive)
```

Reads starting from central directory; requires seekable input.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_set_format

```
Integer archive_read_set_format (Pointer pArchive, Integer iFormatCode)
```

Functions to manually set the format and filters to be used. This is
useful to bypass the bidding process when the format and filters to use
is known in advance.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFormatCode` | `Integer` |

Returns: `Integer`

### Filter support

#### archive_read_support_filter_all

```
Integer archive_read_support_filter_all (Pointer pArchive)
```

Enables detection of all supported filters (compression and encoding).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_by_code

```
Integer archive_read_support_filter_by_code (Pointer pArchive, Integer iFilterCode)
```

Enables detection of one filter identified by its code (ARCHIVE_FILTER_*).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFilterCode` | `Integer` |

Returns: `Integer`

#### archive_read_support_filter_bzip2

```
Integer archive_read_support_filter_bzip2 (Pointer pArchive)
```

Enables detection and decompression of bzip2.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_compress

```
Integer archive_read_support_filter_compress (Pointer pArchive)
```

Enables detection and decompression of Unix compress (.Z).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_gzip

```
Integer archive_read_support_filter_gzip (Pointer pArchive)
```

Enables detection and decompression of gzip.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_grzip

```
Integer archive_read_support_filter_grzip (Pointer pArchive)
```

Enables detection of grzip; needs the external grzip program.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_lrzip

```
Integer archive_read_support_filter_lrzip (Pointer pArchive)
```

Enables detection of lrzip; needs the external lrzip program.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_lz4

```
Integer archive_read_support_filter_lz4 (Pointer pArchive)
```

Enables detection and decompression of lz4.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_lzip

```
Integer archive_read_support_filter_lzip (Pointer pArchive)
```

Enables detection and decompression of lzip.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_lzma

```
Integer archive_read_support_filter_lzma (Pointer pArchive)
```

Enables detection and decompression of lzma.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_lzop

```
Integer archive_read_support_filter_lzop (Pointer pArchive)
```

Enables detection of lzop; needs the external lzop program.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_none

```
Integer archive_read_support_filter_none (Pointer pArchive)
```

Enables the pass-through filter for uncompressed data.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_program

```
Integer archive_read_support_filter_program (Pointer pArchive, Pointer pCommand)
```

Enables an external program as a filter that is applied to every input (no detection).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_program_signature

```
Integer archive_read_support_filter_program_signature (Pointer pArchive, Pointer pCommand, Pointer pSignature, Longptr iSignatureLength)
```

This function is lower-level and typically used when you need custom filter handling.

If you're just working with common formats, archive_read_support_filter_all() is usually sufficient.

Make sure the external program is available in the system's PATH.

pCmd: Command to run the external decompression program.
pSignature: Byte pattern to match against the beginning of the archive stream.
iSignatureLength: Length of the signature in bytes.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |
| `pSignature` | `Pointer` |
| `iSignatureLength` | `Longptr` |

Returns: `Integer`

#### archive_read_support_filter_rpm

```
Integer archive_read_support_filter_rpm (Pointer pArchive)
```

Enables detection of the RPM wrapper around a payload.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_uu

```
Integer archive_read_support_filter_uu (Pointer pArchive)
```

Enables detection and decoding of uuencoded data.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_xz

```
Integer archive_read_support_filter_xz (Pointer pArchive)
```

Enables detection and decompression of xz.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_filter_zstd

```
Integer archive_read_support_filter_zstd (Pointer pArchive)
```

Enables detection and decompression of Zstandard.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_append_filter

```
Integer archive_read_append_filter (Pointer pArchive, Integer iFilterCode)
```

used to enable support for a specific decompression filter when reading an archive. This allows you to manually add support for filters like gzip, bzip2, xz, etc., rather than relying on automatic detection.
eFiltercode: An integer constant representing the filter type, such as:
ARCHIVE_FILTER_GZIP
ARCHIVE_FILTER_BZIP2
ARCHIVE_FILTER_XZ
ARCHIVE_FILTER_NONE

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFilterCode` | `Integer` |

> **Note:** archive_read_append_filter (ARCHIVE_FILTER_COMPRESS) crashes with an access violation in libarchive 3.7.7; use archive_read_support_filter_compress instead. A missing external program (FILTER_PROGRAM) is not reported here.

Returns: `Integer`

#### archive_read_append_filter_program

```
Integer archive_read_append_filter_program (Pointer pArchive, Pointer pCommand)
```

allows you to specify an external decompression program to use as a filter when reading an archive. This is useful when libarchive doesn't natively support a particular compression format, but you have a command-line tool that can decompress it.
pCmd: The name of the external decompression program (e.g., "xz", "gzip", "bzip2").

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |

> **Note:** With a program that does not exist libarchive returns ARCHIVE_FATAL immediately.

Returns: `Integer`

#### archive_read_append_filter_program_signature

```
Integer archive_read_append_filter_program_signature (Pointer pArchive, Pointer pCommand, Pointer pSignature, Longptr iSignatureLength)
```

This function is similar to archive_read_append_filter_program()
pCmd: Name of the external decompression program (e.g., "gzip", "xz").
pSignature: A pointer to a byte sequence that identifies the filter (e.g., magic bytes).
iSignatureLength: Length of the signature in bytes.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |
| `pSignature` | `Pointer` |
| `iSignatureLength` | `Longptr` |

> **Note:** With a program that does not exist libarchive returns ARCHIVE_FATAL immediately.

Returns: `Integer`

### Callbacks and client data

#### archive_read_set_open_callback

```
Integer archive_read_set_open_callback (Pointer pArchive, Pointer pCallback)
```

Sets the open callback (int (*)(archive*, void*)). Needs a native function pointer; DataFlex cannot create one.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_set_read_callback

```
Integer archive_read_set_read_callback (Pointer pArchive, Pointer pCallback)
```

Sets the read callback (la_ssize_t (*)(archive*, void*, const void**)). Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_set_seek_callback

```
Integer archive_read_set_seek_callback (Pointer pArchive, Pointer pCallback)
```

Sets the seek callback (la_int64_t (*)(archive*, void*, la_int64_t, int)). Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_set_skip_callback

```
Integer archive_read_set_skip_callback (Pointer pArchive, Pointer pCallback)
```

Sets the skip callback (la_int64_t (*)(archive*, void*, la_int64_t)). Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_set_close_callback

```
Integer archive_read_set_close_callback (Pointer pArchive, Pointer pCallback)
```

Sets the close callback (int (*)(archive*, void*)). Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_set_switch_callback

```
Integer archive_read_set_switch_callback (Pointer pArchive, Pointer pCallback)
```

Sets the callback that switches from one client data object to the next. Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_set_callback_data

```
Integer archive_read_set_callback_data (Pointer pArchive, Pointer pClientData)
```

Sets the first client data object that is passed to the callbacks.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |

Returns: `Integer`

#### archive_read_set_callback_data2

```
Integer archive_read_set_callback_data2 (Pointer pArchive, Pointer pClientData, UInteger iIndex)
```

Sets the client data object at the given index.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `iIndex` | `UInteger` |

Returns: `Integer`

#### archive_read_add_callback_data

```
Integer archive_read_add_callback_data (Pointer pArchive, Pointer pClientData, UInteger iIndex)
```

Adds a client data object at the given index.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `iIndex` | `UInteger` |

Returns: `Integer`

#### archive_read_append_callback_data

```
Integer archive_read_append_callback_data (Pointer pArchive, Pointer pClientData)
```

Appends a client data object to the end of the list.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |

Returns: `Integer`

#### archive_read_prepend_callback_data

```
Integer archive_read_prepend_callback_data (Pointer pArchive, Pointer pClientData)
```

Prepends a client data object to the beginning of the list.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |

Returns: `Integer`

### Open

#### archive_read_open1

```
Integer archive_read_open1 (Pointer pArchive)
```

Opens the archive using the callbacks that were set earlier; after this call the callbacks are frozen.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_open

```
Integer archive_read_open (Pointer pArchive, Pointer pClientData, Pointer pOpenCallback, Pointer pReadCallback, Pointer pCloseCallback)
```

Convenience wrapper that sets the callbacks and opens the archive. Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `pOpenCallback` | `Pointer` |
| `pReadCallback` | `Pointer` |
| `pCloseCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_open2

```
Integer archive_read_open2 (Pointer pArchive, Pointer pClientData, Pointer pOpenCallback, Pointer pReadCallback, Pointer pSkipCallback, Pointer pCloseCallback)
```

Like archive_read_open with an additional skip callback. Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `pOpenCallback` | `Pointer` |
| `pReadCallback` | `Pointer` |
| `pSkipCallback` | `Pointer` |
| `pCloseCallback` | `Pointer` |

Returns: `Integer`

#### archive_read_open_filename

```
Integer archive_read_open_filename (Pointer pArchive, Pointer pFileName, Longptr iBlockSize)
```

Opens an archive file by name (narrow string in the ANSI code page). A zero pointer reads stdin. A block size of 10240 is a good default.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `iBlockSize` | `Longptr` |

> **Note:** The narrow name is interpreted in the ANSI code page; use archive_read_open_filename_w for file names with other characters. Opening a handle a second time (even after a failed open) corrupts the heap.

Returns: `Integer`

#### archive_read_open_filename_w

```
Integer archive_read_open_filename_w (Pointer pArchive, Pointer pFileName, Longptr iBlockSize)
```

Opens an archive file by name using a wide (UTF-16, WString) file name.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `iBlockSize` | `Longptr` |

Returns: `Integer`

#### archive_read_open_filenames

```
Integer archive_read_open_filenames (Pointer pArchive, Pointer pFileNames, Longptr iBlockSize)
```

Opens a multi-volume archive. pFileNames points to a zero-terminated array of pointers to file names; the files are not sorted.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileNames` | `Pointer` |
| `iBlockSize` | `Longptr` |

Returns: `Integer`

#### archive_read_open_filenames_w

```
Integer archive_read_open_filenames_w (Pointer pArchive, Pointer pFileNames, Longptr iBlockSize)
```

Wide-character variant of archive_read_open_filenames (zero-terminated array of wide string pointers).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileNames` | `Pointer` |
| `iBlockSize` | `Longptr` |

Returns: `Integer`

#### archive_read_open_file

```
Integer archive_read_open_file (Pointer pArchive, Pointer pFileName, Longptr iBlockSize)
```

Deprecated synonym for archive_read_open_filename.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `iBlockSize` | `Longptr` |

Returns: `Integer`

#### archive_read_open_memory

```
Integer archive_read_open_memory (Pointer pArchive, Pointer pBuffer, Longptr iSize)
```

Opens an archive that is stored in a memory buffer. The buffer must stay valid until the archive is closed.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pBuffer` | `Pointer` |
| `iSize` | `Longptr` |

Returns: `Integer`

#### archive_read_open_memory2

```
Integer archive_read_open_memory2 (Pointer pArchive, Pointer pBuffer, Longptr iSize, Longptr iReadSize)
```

Like archive_read_open_memory but delivers the data in chunks of iReadSize bytes (intended for testing).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pBuffer` | `Pointer` |
| `iSize` | `Longptr` |
| `iReadSize` | `Longptr` |

Returns: `Integer`

#### archive_read_open_fd

```
Integer archive_read_open_fd (Pointer pArchive, Integer iFileDescriptor, Longptr iBlockSize)
```

Opens an archive that is already open as a C runtime file descriptor.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFileDescriptor` | `Integer` |
| `iBlockSize` | `Longptr` |

> **Note:** archive.dll uses the universal C runtime: the descriptor must come from ucrtbase.dll (_open), descriptors of msvcrt.dll are not shared.

Returns: `Integer`

#### archive_read_open_FILE_Ptr

```
Integer archive_read_open_FILE_Ptr (Pointer pArchive, Pointer pFile)
```

DLL export: `archive_read_open_FILE`.

Opens an archive that is already open as a C runtime FILE pointer. Not for tape drives. Declared as archive_read_open_FILE_Ptr because DataFlex names are not case sensitive and archive_read_open_file exists.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFile` | `Pointer` |

> **Note:** archive.dll uses the universal C runtime: the FILE pointer must come from ucrtbase.dll (_wfopen), pointers of msvcrt.dll are not shared.

Returns: `Integer`

### Entries and data

#### archive_read_next_header

```
Integer archive_read_next_header (Pointer pArchive, Pointer ppEntry)
```

Parses and returns next entry header.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `ppEntry` | `Pointer` |

Returns: `Integer`

#### archive_read_next_header2

```
Integer archive_read_next_header2 (Pointer pArchive, Pointer pEntry)
```

Parses and returns next entry header using the archive_entry passed in

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_read_header_position

```
BigInt archive_read_header_position (Pointer pArchive)
```

Byte offset in the uncompressed data where the last read header started.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `BigInt`

#### archive_read_has_encrypted_entries

```
Integer archive_read_has_encrypted_entries (Pointer pArchive)
```

1 when at least one encrypted entry was found, 0 when none was found yet, ARCHIVE_READ_FORMAT_ENCRYPTION_DONT_KNOW or _UNSUPPORTED (negative) when unknown.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_format_capabilities

```
Integer archive_read_format_capabilities (Pointer pArchive)
```

Bit mask of ARCHIVE_READ_FORMAT_CAPS_* values describing the encryption capabilities of the format reader.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** The zip reader reports ARCHIVE_READ_FORMAT_CAPS_ENCRYPT_DATA and _ENCRYPT_METADATA (3).

Returns: `Integer`

#### archive_read_data

```
Longptr archive_read_data (Pointer pArchive, Pointer pBuffer, Longptr iSize)
```

Reads up to iSize bytes of the current entry into the buffer. Returns the number of bytes read, 0 at the end of the entry, or a negative ARCHIVE_* code.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pBuffer` | `Pointer` |
| `iSize` | `Longptr` |

Returns: `Longptr`

#### archive_seek_data

```
BigInt archive_seek_data (Pointer pArchive, BigInt iOffset, Integer iWhence)
```

Seeks within the data of the current entry (whence 0 = SEEK_SET, 1 = SEEK_CUR, 2 = SEEK_END). Returns the new offset or a negative ARCHIVE_* code.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iOffset` | `BigInt` |
| `iWhence` | `Integer` |

> **Note:** For most formats (tar, zip, 7zip, cpio, iso9660) libarchive 3.7.7 returns ARCHIVE_FATAL; only some formats can seek.

Returns: `BigInt`

#### archive_read_data_block

```
Integer archive_read_data_block (Pointer pArchive, Pointer ppBuffer, Pointer pSize, Pointer pOffset)
```

Zero-copy read of the next data block of the current entry: stores the block pointer, its size and its file offset in the variables pointed to.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `ppBuffer` | `Pointer` |
| `pSize` | `Pointer` |
| `pOffset` | `Pointer` |

Returns: `Integer`

#### archive_read_data_skip

```
Integer archive_read_data_skip (Pointer pArchive)
```

Skips the remaining data of the current entry.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_data_into_fd

```
Integer archive_read_data_into_fd (Pointer pArchive, Integer iFileDescriptor)
```

Writes the data of the current entry to a C runtime file descriptor.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFileDescriptor` | `Integer` |

Returns: `Integer`

### Options and passphrases

#### archive_read_set_format_option

```
Integer archive_read_set_format_option (Pointer pArchive, Pointer pModule, Pointer pOption, Pointer pValue)
```

Sets an option for the format reader only. pModule can be 0 to match any module.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pModule` | `Pointer` |
| `pOption` | `Pointer` |
| `pValue` | `Pointer` |

> **Note:** An unknown option returns ARCHIVE_FAILED (not ARCHIVE_WARN).

Returns: `Integer`

#### archive_read_set_filter_option

```
Integer archive_read_set_filter_option (Pointer pArchive, Pointer pModule, Pointer pOption, Pointer pValue)
```

Sets an option for the filter only. pModule can be 0 to match any module.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pModule` | `Pointer` |
| `pOption` | `Pointer` |
| `pValue` | `Pointer` |

> **Note:** An unknown option returns ARCHIVE_FAILED (not ARCHIVE_WARN).

Returns: `Integer`

#### archive_read_set_option

```
Integer archive_read_set_option (Pointer pArchive, Pointer pModule, Pointer pOption, Pointer pValue)
```

Sets an option for both the format and the filter. pModule can be 0 to match any module.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pModule` | `Pointer` |
| `pOption` | `Pointer` |
| `pValue` | `Pointer` |

> **Note:** An unknown option returns ARCHIVE_FAILED (not ARCHIVE_WARN).

Returns: `Integer`

#### archive_read_set_options

```
Integer archive_read_set_options (Pointer pArchive, Pointer pOptions)
```

Sets options from a string like "module:option=value,option2" for both the format and the filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pOptions` | `Pointer` |

> **Note:** An unknown option returns ARCHIVE_FAILED (not ARCHIVE_WARN).

Returns: `Integer`

#### archive_read_add_passphrase

```
Integer archive_read_add_passphrase (Pointer pArchive, Pointer pPassphrase)
```

Adds a passphrase that is tried when decrypting entries; can be called several times.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPassphrase` | `Pointer` |

Returns: `Integer`

#### archive_read_set_passphrase_callback

```
Integer archive_read_set_passphrase_callback (Pointer pArchive, Pointer pClientData, Pointer pCallback)
```

Sets a callback that provides passphrases (const char *(*)(archive*, void*)). Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

### Extract

#### archive_read_extract

```
Integer archive_read_extract (Pointer pArchive, Pointer pEntry, Integer iFlags)
```

Extracts the current entry (header and data) to disk. iFlags is a combination of ARCHIVE_EXTRACT_* values.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |
| `iFlags` | `Integer` |

Returns: `Integer`

#### archive_read_extract2

```
Integer archive_read_extract2 (Pointer pArchive, Pointer pEntry, Pointer pDestArchive)
```

Extracts the current entry through the given archive_write_disk handle.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |
| `pDestArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_extract_set_progress_callback

```
Void_Type archive_read_extract_set_progress_callback (Pointer pArchive, Pointer pProgressFunc, Pointer pUserData)
```

Sets a progress callback (void (*)(void*)) for extraction. Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pProgressFunc` | `Pointer` |
| `pUserData` | `Pointer` |

Returns: `Void_Type`

#### archive_read_extract_set_skip_file

```
Void_Type archive_read_extract_set_skip_file (Pointer pArchive, BigInt iDevice, BigInt iInode)
```

Records the device and inode of a file that must not be overwritten (normally the archive being read).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iDevice` | `BigInt` |
| `iInode` | `BigInt` |

> **Note:** Has no effect on Windows: an entry with the registered device and inode is extracted anyway (archive_read_extract returns ARCHIVE_WARN only for the archive being read).

Returns: `Void_Type`

### Deprecated

#### archive_read_finish

```
Integer archive_read_finish (Pointer pArchive)
```

Deprecated synonym for archive_read_free.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_all

```
Integer archive_read_support_compression_all (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_all.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_bzip2

```
Integer archive_read_support_compression_bzip2 (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_bzip2.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_compress

```
Integer archive_read_support_compression_compress (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_compress.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_gzip

```
Integer archive_read_support_compression_gzip (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_gzip.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_lzip

```
Integer archive_read_support_compression_lzip (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_lzip.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_lzma

```
Integer archive_read_support_compression_lzma (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_lzma.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_none

```
Integer archive_read_support_compression_none (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_none.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_program

```
Integer archive_read_support_compression_program (Pointer pArchive, Pointer pCommand)
```

Deprecated synonym for archive_read_support_filter_program.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_program_signature

```
Integer archive_read_support_compression_program_signature (Pointer pArchive, Pointer pCommand, Pointer pSignature, Longptr iSignatureLength)
```

Deprecated synonym for archive_read_support_filter_program_signature.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |
| `pSignature` | `Pointer` |
| `iSignatureLength` | `Longptr` |

Returns: `Integer`

#### archive_read_support_compression_rpm

```
Integer archive_read_support_compression_rpm (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_rpm.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_uu

```
Integer archive_read_support_compression_uu (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_uu.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_read_support_compression_xz

```
Integer archive_read_support_compression_xz (Pointer pArchive)
```

Deprecated synonym for archive_read_support_filter_xz.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`
