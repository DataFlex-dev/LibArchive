# ArchiveWrite.h.pkg

Functions to write archives (archive_write_*) and to create files on disk (archive_write_disk_*).

Source: `Library/AppSrc/ArchiveWrite.h.pkg`. All functions are declared with `External_Function <name> "<export>" archive.dll`; the DataFlex name equals the DLL export unless noted. Pointers to libarchive objects are `Pointer`; strings are passed as `Pointer` to a NUL terminated string (`AddressOf (sValue)`) and returned as `Pointer` (use `PointerToString`).

## Index


**Create, configure and free**

- [`archive_write_new`](#archive_write_new)
- [`archive_write_set_bytes_per_block`](#archive_write_set_bytes_per_block)
- [`archive_write_get_bytes_per_block`](#archive_write_get_bytes_per_block)
- [`archive_write_set_bytes_in_last_block`](#archive_write_set_bytes_in_last_block)
- [`archive_write_get_bytes_in_last_block`](#archive_write_get_bytes_in_last_block)
- [`archive_write_set_skip_file`](#archive_write_set_skip_file)
- [`archive_write_fail`](#archive_write_fail)
- [`archive_write_free`](#archive_write_free)

**Filters**

- [`archive_write_add_filter`](#archive_write_add_filter)
- [`archive_write_add_filter_by_name`](#archive_write_add_filter_by_name)
- [`archive_write_add_filter_b64encode`](#archive_write_add_filter_b64encode)
- [`archive_write_add_filter_bzip2`](#archive_write_add_filter_bzip2)
- [`archive_write_add_filter_compress`](#archive_write_add_filter_compress)
- [`archive_write_add_filter_grzip`](#archive_write_add_filter_grzip)
- [`archive_write_add_filter_gzip`](#archive_write_add_filter_gzip)
- [`archive_write_add_filter_lrzip`](#archive_write_add_filter_lrzip)
- [`archive_write_add_filter_lz4`](#archive_write_add_filter_lz4)
- [`archive_write_add_filter_lzip`](#archive_write_add_filter_lzip)
- [`archive_write_add_filter_lzma`](#archive_write_add_filter_lzma)
- [`archive_write_add_filter_lzop`](#archive_write_add_filter_lzop)
- [`archive_write_add_filter_none`](#archive_write_add_filter_none)
- [`archive_write_add_filter_program`](#archive_write_add_filter_program)
- [`archive_write_add_filter_uuencode`](#archive_write_add_filter_uuencode)
- [`archive_write_add_filter_xz`](#archive_write_add_filter_xz)
- [`archive_write_add_filter_zstd`](#archive_write_add_filter_zstd)

**Formats**

- [`archive_write_set_format`](#archive_write_set_format)
- [`archive_write_set_format_by_name`](#archive_write_set_format_by_name)
- [`archive_write_set_format_filter_by_ext`](#archive_write_set_format_filter_by_ext)
- [`archive_write_set_format_filter_by_ext_def`](#archive_write_set_format_filter_by_ext_def)
- [`archive_write_set_format_v7tar`](#archive_write_set_format_v7tar)
- [`archive_write_zip_set_compression_deflate`](#archive_write_zip_set_compression_deflate)
- [`archive_write_zip_set_compression_store`](#archive_write_zip_set_compression_store)

**Open**

- [`archive_write_open`](#archive_write_open)
- [`archive_write_open2`](#archive_write_open2)
- [`archive_write_open_fd`](#archive_write_open_fd)
- [`archive_write_open_filename_w`](#archive_write_open_filename_w)
- [`archive_write_open_file`](#archive_write_open_file)
- [`archive_write_open_FILE_Ptr`](#archive_write_open_file_ptr)
- [`archive_write_open_memory`](#archive_write_open_memory)

**Entries and data**

- [`archive_write_data_block`](#archive_write_data_block)
- [`archive_write_finish_entry`](#archive_write_finish_entry)
- [`archive_write_set_format_option`](#archive_write_set_format_option)
- [`archive_write_set_filter_option`](#archive_write_set_filter_option)
- [`archive_write_set_option`](#archive_write_set_option)
- [`archive_write_set_options`](#archive_write_set_options)
- [`archive_write_set_passphrase`](#archive_write_set_passphrase)
- [`archive_write_set_passphrase_callback`](#archive_write_set_passphrase_callback)

**Write to disk**

- [`archive_write_disk_new`](#archive_write_disk_new)
- [`archive_write_disk_set_options`](#archive_write_disk_set_options)
- [`archive_write_disk_set_skip_file`](#archive_write_disk_set_skip_file)
- [`archive_write_disk_set_standard_lookup`](#archive_write_disk_set_standard_lookup)
- [`archive_write_disk_set_group_lookup`](#archive_write_disk_set_group_lookup)
- [`archive_write_disk_set_user_lookup`](#archive_write_disk_set_user_lookup)
- [`archive_write_disk_gid`](#archive_write_disk_gid)
- [`archive_write_disk_uid`](#archive_write_disk_uid)

**Deprecated**

- [`archive_write_finish`](#archive_write_finish)
- [`archive_write_set_compression_bzip2`](#archive_write_set_compression_bzip2)
- [`archive_write_set_compression_compress`](#archive_write_set_compression_compress)
- [`archive_write_set_compression_gzip`](#archive_write_set_compression_gzip)
- [`archive_write_set_compression_lzip`](#archive_write_set_compression_lzip)
- [`archive_write_set_compression_lzma`](#archive_write_set_compression_lzma)
- [`archive_write_set_compression_none`](#archive_write_set_compression_none)
- [`archive_write_set_compression_program`](#archive_write_set_compression_program)
- [`archive_write_set_compression_xz`](#archive_write_set_compression_xz)

**Entries, data and open (documented in the original declarations)**

- [`archive_write_open_filename`](#archive_write_open_filename)
- [`archive_write_header`](#archive_write_header)
- [`archive_write_data`](#archive_write_data)
- [`archive_write_close`](#archive_write_close)

**Format shortcuts**

- [`archive_write_set_format_7zip`](#archive_write_set_format_7zip)
- [`archive_write_set_format_ar_bsd`](#archive_write_set_format_ar_bsd)
- [`archive_write_set_format_ar_svr4`](#archive_write_set_format_ar_svr4)
- [`archive_write_set_format_cpio`](#archive_write_set_format_cpio)
- [`archive_write_set_format_cpio_bin`](#archive_write_set_format_cpio_bin)
- [`archive_write_set_format_cpio_newc`](#archive_write_set_format_cpio_newc)
- [`archive_write_set_format_cpio_odc`](#archive_write_set_format_cpio_odc)
- [`archive_write_set_format_cpio_pwb`](#archive_write_set_format_cpio_pwb)
- [`archive_write_set_format_gnutar`](#archive_write_set_format_gnutar)
- [`archive_write_set_format_iso9660`](#archive_write_set_format_iso9660)
- [`archive_write_set_format_mtree`](#archive_write_set_format_mtree)
- [`archive_write_set_format_mtree_classic`](#archive_write_set_format_mtree_classic)
- [`archive_write_set_format_pax`](#archive_write_set_format_pax)
- [`archive_write_set_format_pax_restricted`](#archive_write_set_format_pax_restricted)
- [`archive_write_set_format_raw`](#archive_write_set_format_raw)
- [`archive_write_set_format_shar`](#archive_write_set_format_shar)
- [`archive_write_set_format_shar_dump`](#archive_write_set_format_shar_dump)
- [`archive_write_set_format_ustar`](#archive_write_set_format_ustar)
- [`archive_write_set_format_warc`](#archive_write_set_format_warc)
- [`archive_write_set_format_xar`](#archive_write_set_format_xar)
- [`archive_write_set_format_zip`](#archive_write_set_format_zip)

## Reference

### Create, configure and free

#### archive_write_new

```
Pointer archive_write_new ()
```

The function archive_write_new() creates a new archive-writing object.
Unlike most other libarchive functions, archive_write_new() does not return an int status code — it returns a pointer.

Returns: `Pointer`

#### archive_write_set_bytes_per_block

```
Integer archive_write_set_bytes_per_block (Pointer pArchive, Integer iBytesPerBlock)
```

function in the libarchive library that allows you to set the number of bytes per block for the archive being written.

This setting is particularly relevant for certain archive formats, most notably the tar format.
Historically, tar archives were often written to tape drives with specific block sizes.
While less critical for modern file-based archives, some systems or specifications might still expect a particular block size.

The block size can influence how the archive is structured on the storage medium.
For tar, records are typically 512 bytes, and multiple records form a block.
The block size set here might affect how many records are written together.

For many common use cases of creating tar archives on modern file systems, you might not need to explicitly set the bytes per block,
and libarchive will use a reasonable default.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iBytesPerBlock` | `Integer` |

Returns: `Integer`

#### archive_write_get_bytes_per_block

```
Integer archive_write_get_bytes_per_block (Pointer pArchive)
```

Returns the block size used for output.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_bytes_in_last_block

```
Integer archive_write_set_bytes_in_last_block (Pointer pArchive, Integer iBytesInLastBlock)
```

Sets the size the last block is padded to; 1 disables padding of the last block.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iBytesInLastBlock` | `Integer` |

> **Note:** ustar defaults to -1 (no padding of the last block).

Returns: `Integer`

#### archive_write_get_bytes_in_last_block

```
Integer archive_write_get_bytes_in_last_block (Pointer pArchive)
```

Returns the size the last block is padded to.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_skip_file

```
Integer archive_write_set_skip_file (Pointer pArchive, BigInt iDevice, BigInt iInode)
```

Sets the device and inode of a file that must not be archived (avoids adding the archive to itself).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iDevice` | `BigInt` |
| `iInode` | `BigInt` |

> **Note:** Compares with the device and inode of the entry that is written.

Returns: `Integer`

#### archive_write_fail

```
Integer archive_write_fail (Pointer pArchive)
```

Marks the archive as fatally failed so that a following free does not try to close it cleanly (fast abort).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Returns the internal fatal state value 32768, not ARCHIVE_FATAL. Call it before archive_write_free when an archive opened with open/open2 callbacks of 0 was not closed, otherwise free crashes.

Returns: `Integer`

#### archive_write_free

```
Integer archive_write_free (Pointer pArchive)
```

The function archive_write_free from the libarchive library is used to release all resources associated with an archive handle that was previously initialized for writing.

Here's what happens when you call archive_write_free(archive):

Flushes any pending data: If there's any buffered data waiting to be written to the underlying output (e.g., the file or stream you associated with the archive using functions like archive_write_open_file), this function will attempt to flush that data.
Closes the underlying output: If an output stream was opened by libarchive, this function will typically close that stream. If you provided your own output stream, libarchive might not close it (check the documentation for the specific archive_write_open_* function you used).
Deallocates memory: Any memory that libarchive allocated for the write archive handle and its associated data structures will be freed.
Invalidates the archive handle: After calling archive_write_free, the archive handle you passed to it is no longer valid and should not be used.
In essence, archive_write_free is the counterpart to the archive_write_new() function. You should always call archive_write_free when you are finished using a write archive handle to prevent memory leaks and ensure proper cleanup of resources.

After calling this function, if you need to create another archive, you would need to call archive_write_new() again to get a fresh archive handle.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

### Filters

#### archive_write_add_filter

```
Integer archive_write_add_filter (Pointer pArchive, Integer iFilterCode)
```

Adds a filter by code (ARCHIVE_FILTER_*).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFilterCode` | `Integer` |

Returns: `Integer`

#### archive_write_add_filter_by_name

```
Integer archive_write_add_filter_by_name (Pointer pArchive, Pointer pName)
```

Adds a filter by name ("gzip", "bzip2", "xz", "zstd", ...).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pName` | `Pointer` |

> **Note:** "none" returns ARCHIVE_FATAL; use archive_write_add_filter_none.

Returns: `Integer`

#### archive_write_add_filter_b64encode

```
Integer archive_write_add_filter_b64encode (Pointer pArchive)
```

Adds a base64 encoding filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_bzip2

```
Integer archive_write_add_filter_bzip2 (Pointer pArchive)
```

Adds a bzip2 compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_compress

```
Integer archive_write_add_filter_compress (Pointer pArchive)
```

Adds a Unix compress (.Z) filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_grzip

```
Integer archive_write_add_filter_grzip (Pointer pArchive)
```

Adds a grzip compression filter (needs the external grzip program).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Returns ARCHIVE_WARN; opening the archive fails ("Can't launch external program") unless grzip is installed.

Returns: `Integer`

#### archive_write_add_filter_gzip

```
Integer archive_write_add_filter_gzip (Pointer pArchive)
```

Adds a gzip compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_lrzip

```
Integer archive_write_add_filter_lrzip (Pointer pArchive)
```

Adds an lrzip compression filter (needs the external lrzip program).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Returns ARCHIVE_WARN; opening the archive fails ("Can't launch external program") unless lrzip is installed.

Returns: `Integer`

#### archive_write_add_filter_lz4

```
Integer archive_write_add_filter_lz4 (Pointer pArchive)
```

Adds an lz4 compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_lzip

```
Integer archive_write_add_filter_lzip (Pointer pArchive)
```

Adds an lzip compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_lzma

```
Integer archive_write_add_filter_lzma (Pointer pArchive)
```

Adds an lzma compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_lzop

```
Integer archive_write_add_filter_lzop (Pointer pArchive)
```

Adds an lzop compression filter (needs the external lzop program).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Returns ARCHIVE_WARN; opening the archive fails ("Can't launch external program") unless lzop is installed.

Returns: `Integer`

#### archive_write_add_filter_none

```
Integer archive_write_add_filter_none (Pointer pArchive)
```

Adds a pass-through filter that does nothing.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_program

```
Integer archive_write_add_filter_program (Pointer pArchive, Pointer pCommand)
```

Adds an external program as compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_uuencode

```
Integer archive_write_add_filter_uuencode (Pointer pArchive)
```

Adds a uuencode filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_xz

```
Integer archive_write_add_filter_xz (Pointer pArchive)
```

Adds an xz compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_add_filter_zstd

```
Integer archive_write_add_filter_zstd (Pointer pArchive)
```

Adds a Zstandard compression filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

### Formats

#### archive_write_set_format

```
Integer archive_write_set_format (Pointer pArchive, Integer iFormatCode)
```

Sets the output format by code (ARCHIVE_FORMAT_*).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFormatCode` | `Integer` |

> **Note:** By code libarchive cannot select ar or cpio svr4 with crc (ARCHIVE_FATAL), and ARCHIVE_FORMAT_TAR selects ustar. Use the named format functions for those.

Returns: `Integer`

#### archive_write_set_format_by_name

```
Integer archive_write_set_format_by_name (Pointer pArchive, Pointer pName)
```

Sets the output format by name ("zip", "7zip", "pax", "ustar", "gnutar", "cpio", "iso9660", ...).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pName` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_filter_by_ext

```
Integer archive_write_set_format_filter_by_ext (Pointer pArchive, Pointer pFileName)
```

Selects format and filter from the extension of the file name (.tar.gz, .zip, .7z, ...).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |

> **Note:** Known extensions: .zip .jar .7z .tar .tgz .tar.gz .tar.bz2 .tar.xz .cpio .iso .a .ar. Others (for example .tar.zst, .tar.lz4) return ARCHIVE_FATAL.

Returns: `Integer`

#### archive_write_set_format_filter_by_ext_def

```
Integer archive_write_set_format_filter_by_ext_def (Pointer pArchive, Pointer pFileName, Pointer pDefaultExtension)
```

Like archive_write_set_format_filter_by_ext, using the default extension when the file name has no known extension.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `pDefaultExtension` | `Pointer` |

> **Note:** Known extensions: .zip .jar .7z .tar .tgz .tar.gz .tar.bz2 .tar.xz .cpio .iso .a .ar. Others return ARCHIVE_FATAL unless the default extension is known.

Returns: `Integer`

#### archive_write_set_format_v7tar

```
Integer archive_write_set_format_v7tar (Pointer pArchive)
```

The function archive_write_set_format_v7tar from the libarchive library sets the format for writing an archive to the old (Version 7) tar format.
- tar Format: tar (tape archive) is a common archive file format.
- V7 tar: This refers to one of the earliest versions of the tar format, dating back to Version 7 Unix. It has several limitations compared to more modern tar formats. Key characteristics often include:
Limited filename length: Typically around 100 characters.
No support for sparse files.
Limited size of files within the archive.
Only basic metadata (permissions, ownership, timestamps).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_zip_set_compression_deflate

```
Integer archive_write_zip_set_compression_deflate (Pointer pArchive)
```

Makes the zip writer compress entries with deflate (default).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_zip_set_compression_store

```
Integer archive_write_zip_set_compression_store (Pointer pArchive)
```

Makes the zip writer store entries without compression.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

### Open

#### archive_write_open

```
Integer archive_write_open (Pointer pArchive, Pointer pClientData, Pointer pOpenCallback, Pointer pWriteCallback, Pointer pCloseCallback)
```

Deprecated; use archive_write_open2. Opens the archive with callbacks. Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `pOpenCallback` | `Pointer` |
| `pWriteCallback` | `Pointer` |
| `pCloseCallback` | `Pointer` |

Returns: `Integer`

#### archive_write_open2

```
Integer archive_write_open2 (Pointer pArchive, Pointer pClientData, Pointer pOpenCallback, Pointer pWriteCallback, Pointer pCloseCallback, Pointer pFreeCallback)
```

Opens the archive with callbacks. Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `pOpenCallback` | `Pointer` |
| `pWriteCallback` | `Pointer` |
| `pCloseCallback` | `Pointer` |
| `pFreeCallback` | `Pointer` |

Returns: `Integer`

#### archive_write_open_fd

```
Integer archive_write_open_fd (Pointer pArchive, Integer iFileDescriptor)
```

Opens the archive on an already open C runtime file descriptor.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFileDescriptor` | `Integer` |

> **Note:** The descriptor must come from ucrtbase.dll (_open); descriptors of msvcrt.dll are not shared.

Returns: `Integer`

#### archive_write_open_filename_w

```
Integer archive_write_open_filename_w (Pointer pArchive, Pointer pFileName)
```

Creates the archive file with a wide (UTF-16, WString) file name. A zero pointer writes to stdout.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |

Returns: `Integer`

#### archive_write_open_file

```
Integer archive_write_open_file (Pointer pArchive, Pointer pFileName)
```

Deprecated synonym for archive_write_open_filename.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |

Returns: `Integer`

#### archive_write_open_FILE_Ptr

```
Integer archive_write_open_FILE_Ptr (Pointer pArchive, Pointer pFile)
```

DLL export: `archive_write_open_FILE`.

Opens the archive on an already open C runtime FILE pointer. Declared as archive_write_open_FILE_Ptr because DataFlex names are not case sensitive and archive_write_open_file exists.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFile` | `Pointer` |

> **Note:** The FILE pointer must come from ucrtbase.dll (_wfopen); the output is padded to 10240 bytes unlike the other open functions.

Returns: `Integer`

#### archive_write_open_memory

```
Integer archive_write_open_memory (Pointer pArchive, Pointer pBuffer, Longptr iBufferSize, Pointer pUsed)
```

Writes the archive into a memory buffer of iBufferSize bytes. The size_t variable pointed to by pUsed receives the number of bytes written; writing fails when the buffer is full.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pBuffer` | `Pointer` |
| `iBufferSize` | `Longptr` |
| `pUsed` | `Pointer` |

Returns: `Integer`

### Entries and data

#### archive_write_data_block

```
Longptr archive_write_data_block (Pointer pArchive, Pointer pBuffer, Longptr iSize, BigInt iOffset)
```

Writes a block of data at an offset. Only available for archive_write_disk handles.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pBuffer` | `Pointer` |
| `iSize` | `Longptr` |
| `iOffset` | `BigInt` |

> **Note:** Returns 0 on success, not the number of bytes written.

Returns: `Longptr`

#### archive_write_finish_entry

```
Integer archive_write_finish_entry (Pointer pArchive)
```

Finishes the current entry: pads the data when it is shorter than the size in the header.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_option

```
Integer archive_write_set_format_option (Pointer pArchive, Pointer pModule, Pointer pOption, Pointer pValue)
```

Sets an option for the format writer only. pModule can be 0 to match any module.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pModule` | `Pointer` |
| `pOption` | `Pointer` |
| `pValue` | `Pointer` |

Returns: `Integer`

#### archive_write_set_filter_option

```
Integer archive_write_set_filter_option (Pointer pArchive, Pointer pModule, Pointer pOption, Pointer pValue)
```

Sets an option for the filter only. pModule can be 0 to match any module.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pModule` | `Pointer` |
| `pOption` | `Pointer` |
| `pValue` | `Pointer` |

Returns: `Integer`

#### archive_write_set_option

```
Integer archive_write_set_option (Pointer pArchive, Pointer pModule, Pointer pOption, Pointer pValue)
```

Sets an option for both the format and the filter. pModule can be 0 to match any module.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pModule` | `Pointer` |
| `pOption` | `Pointer` |
| `pValue` | `Pointer` |

> **Note:** An unknown option returns ARCHIVE_FAILED (not ARCHIVE_WARN). Useful options: hdrcharset=UTF-8 (file names), zip:encryption=zipcrypt|aes128|aes256 (with archive_write_set_passphrase), zip:compression=store|deflate, 7zip:compression=...

Returns: `Integer`

#### archive_write_set_options

```
Integer archive_write_set_options (Pointer pArchive, Pointer pOptions)
```

Sets options from a string like "module:option=value,option2" for both the format and the filter.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pOptions` | `Pointer` |

Returns: `Integer`

#### archive_write_set_passphrase

```
Integer archive_write_set_passphrase (Pointer pArchive, Pointer pPassphrase)
```

Sets the passphrase used for encryption (zip and 7zip with the proper encryption option).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPassphrase` | `Pointer` |

Returns: `Integer`

#### archive_write_set_passphrase_callback

```
Integer archive_write_set_passphrase_callback (Pointer pArchive, Pointer pClientData, Pointer pCallback)
```

Sets a callback that provides the passphrase. Needs a native function pointer.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pClientData` | `Pointer` |
| `pCallback` | `Pointer` |

Returns: `Integer`

### Write to disk

#### archive_write_disk_new

```
Pointer archive_write_disk_new ()
```

Allocates a new archive handle that creates files, directories and links on disk from the entries and data written to it.

Returns: `Pointer`

#### archive_write_disk_set_options

```
Integer archive_write_disk_set_options (Pointer pArchive, Integer iFlags)
```

Sets how the next entries are created with a combination of ARCHIVE_EXTRACT_* flags.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlags` | `Integer` |

> **Note:** ARCHIVE_EXTRACT_NO_OVERWRITE and ARCHIVE_EXTRACT_NO_OVERWRITE_NEWER make archive_write_header return ARCHIVE_FATAL on Windows for an existing file. A read-only permission (0444) does not set the read-only attribute on Windows.

Returns: `Integer`

#### archive_write_disk_set_skip_file

```
Integer archive_write_disk_set_skip_file (Pointer pArchive, BigInt iDevice, BigInt iInode)
```

Sets the device and inode of a file that must not be overwritten.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iDevice` | `BigInt` |
| `iInode` | `BigInt` |

> **Note:** Compares with the device and inode of the destination file on disk, and has no effect on Windows for entries (the Windows device/inode numbers are not available).

Returns: `Integer`

#### archive_write_disk_set_standard_lookup

```
Integer archive_write_disk_set_standard_lookup (Pointer pArchive)
```

Installs the standard user name / group name lookup (system calls with caching).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_disk_set_group_lookup

```
Integer archive_write_disk_set_group_lookup (Pointer pArchive, Pointer pPrivateData, Pointer pLookupFunc, Pointer pCleanupFunc)
```

Installs a custom group lookup (la_int64_t (*)(void*, const char*, la_int64_t)). Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPrivateData` | `Pointer` |
| `pLookupFunc` | `Pointer` |
| `pCleanupFunc` | `Pointer` |

Returns: `Integer`

#### archive_write_disk_set_user_lookup

```
Integer archive_write_disk_set_user_lookup (Pointer pArchive, Pointer pPrivateData, Pointer pLookupFunc, Pointer pCleanupFunc)
```

Installs a custom user lookup (la_int64_t (*)(void*, const char*, la_int64_t)). Needs native function pointers.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPrivateData` | `Pointer` |
| `pLookupFunc` | `Pointer` |
| `pCleanupFunc` | `Pointer` |

Returns: `Integer`

#### archive_write_disk_gid

```
BigInt archive_write_disk_gid (Pointer pArchive, Pointer pGroupName, BigInt iDefaultGroupId)
```

Looks up the group id for a group name with the installed lookup; returns the default when not found.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pGroupName` | `Pointer` |
| `iDefaultGroupId` | `BigInt` |

Returns: `BigInt`

#### archive_write_disk_uid

```
BigInt archive_write_disk_uid (Pointer pArchive, Pointer pUserName, BigInt iDefaultUserId)
```

Looks up the user id for a user name with the installed lookup; returns the default when not found.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pUserName` | `Pointer` |
| `iDefaultUserId` | `BigInt` |

Returns: `BigInt`

### Deprecated

#### archive_write_finish

```
Integer archive_write_finish (Pointer pArchive)
```

Deprecated synonym for archive_write_free.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_bzip2

```
Integer archive_write_set_compression_bzip2 (Pointer pArchive)
```

Deprecated synonym for archive_write_add_filter_bzip2.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_compress

```
Integer archive_write_set_compression_compress (Pointer pArchive)
```

Deprecated synonym for archive_write_add_filter_compress.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_gzip

```
Integer archive_write_set_compression_gzip (Pointer pArchive)
```

Deprecated synonym for archive_write_add_filter_gzip.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_lzip

```
Integer archive_write_set_compression_lzip (Pointer pArchive)
```

Deprecated synonym for archive_write_add_filter_lzip.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_lzma

```
Integer archive_write_set_compression_lzma (Pointer pArchive)
```

Deprecated synonym for archive_write_add_filter_lzma.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_none

```
Integer archive_write_set_compression_none (Pointer pArchive)
```

Deprecated synonym for archive_write_add_filter_none.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_program

```
Integer archive_write_set_compression_program (Pointer pArchive, Pointer pCommand)
```

Deprecated synonym for archive_write_add_filter_program.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pCommand` | `Pointer` |

Returns: `Integer`

#### archive_write_set_compression_xz

```
Integer archive_write_set_compression_xz (Pointer pArchive)
```

Deprecated synonym for archive_write_add_filter_xz.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

### Entries, data and open (documented in the original declarations)

#### archive_write_open_filename

```
Integer archive_write_open_filename (Pointer pArchive, Pointer pFileName)
```

Opens the file: It attempts to open the specified file in write mode. If the file doesn't exist, it will typically be created. If it exists, it will usually be overwritten.
Associates the file with the archive handle: It sets up the necessary internal structures so that subsequent calls to archive_write_header() and archive_write_data() will write to this opened file.
Return Value:

archive_write_open_filename() returns an integer value to indicate the result of the operation:

ARCHIVE_OK (0): The file was successfully opened.
ARCHIVE_FATAL (> 1): A serious error occurred, and the file could not be opened.
ARCHIVE_FAILED (< 0, typically -1 or -5): An error occurred while trying to open the file. You should check the error message using archive_error_string().
After successfully opening the file, you would typically proceed to create archive_entry objects, write their headers using archive_write_header(), and then write their data using archive_write_data(). Once you're finished writing all the entries, you should call archive_write_close() and finally archive_write_free().

Pass a pointer - addressof() - to a normal DataFlex string (UTF-8)

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |

Returns: `Integer`

#### archive_write_header

```
Integer archive_write_header (Pointer pArchive, Pointer pEntry)
```

Writes the header: archive_write_header() writes the header information for the entry to the archive according to the selected archive format. This header tells the archiver (and later, the extractor) things like the filename, size, permissions, and type of the entry.
Return Value:

archive_write_header() returns an integer value to indicate success or failure:

ARCHIVE_OK (0): The header was written successfully.
ARCHIVE_WARN (1): The header was written, but one or more non-critical issues were encountered. You should check the warning messages using archive_error_string().
ARCHIVE_FATAL (> 1): A serious error occurred, and no more data can be written to this archive.
ARCHIVE_FAILED (< 0, typically -1 or -5): An error occurred while trying to write the header. You should check the error message using archive_error_string().

After successfully writing the header for a file (i.e., when the entry is not a directory or symbolic link with no content), you would typically call archive_write_data() one or more times to write the actual file content. For directories and some other entry types, you might not need to call archive_write_data().

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_write_data

```
Longptr archive_write_data (Pointer pArchive, Pointer pData, Longptr iSize)
```

The function archive_write_data() in libarchive is used to write the file contents (data) for the current entry, and it returns a result code (negative number) or byte count.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pData` | `Pointer` |
| `iSize` | `Longptr` |

Returns: `Longptr`

#### archive_write_close

```
Integer archive_write_close (Pointer pArchive)
```

Finalizes the archive: It performs any necessary finalization steps for the archive format. This might include writing trailer blocks or closing out any open structures within the archive.
Closes the underlying I/O: It closes the file or stream that was associated with the archive for writing (e.g., if you used archive_write_open_filename() or a similar function).
Return Value:

archive_write_close() returns an integer value to indicate the result of the operation:

ARCHIVE_OK (0): The archive was successfully closed.
ARCHIVE_WARN (1): The archive was closed, but some non-critical issues occurred. You should check the warning messages using archive_error_string().
ARCHIVE_FATAL (> 1): A serious error occurred during the closing process.
ARCHIVE_FAILED (< 0, typically -1 or -5): An error occurred while trying to close the archive. You should check the error message using archive_error_string().

After calling archive_write_close(), you should typically call archive_write_free() to release the memory associated with the struct archive object.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

### Format shortcuts

#### archive_write_set_format_7zip

```
Integer archive_write_set_format_7zip (Pointer pArchive)
```

The function sets the output format to 7-Zip (.7z).
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_ar_bsd

```
Integer archive_write_set_format_ar_bsd (Pointer pArchive)
```

The function sets the output format to ar(1) BSD variant, commonly used for creating static libraries on Unix-like systems (.a files).
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_ar_svr4

```
Integer archive_write_set_format_ar_svr4 (Pointer pArchive)
```

The function sets the archive format to System V Release 4 (SVR4) variant of ar — another format used for creating .a static libraries.
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_cpio

```
Integer archive_write_set_format_cpio (Pointer pArchive)
```

The function sets the archive format to CPIO (a legacy POSIX archive format).
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_cpio_bin

```
Integer archive_write_set_format_cpio_bin (Pointer pArchive)
```

The function sets the archive format to the legacy binary CPIO format (also known as "old binary" CPIO format).
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_cpio_newc

```
Integer archive_write_set_format_cpio_newc (Pointer pArchive)
```

The function sets the archive format to "newc" CPIO format, a widely supported, modern variant of CPIO.
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_cpio_odc

```
Integer archive_write_set_format_cpio_odc (Pointer pArchive)
```

The function sets the format for writing an archive to the old character (odc) cpio format.
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_cpio_pwb

```
Integer archive_write_set_format_cpio_pwb (Pointer pArchive)
```

The function sets the format for writing an archive to the PWB (Programmer's WorkBench) cpio format.
cpio: As before, this indicates the cpio (copy in/out) archive format.
PWB: This refers to a specific variant of the cpio format that was used in the Programmer's WorkBench (PWB) Unix system. It's another early ASCII-based cpio format, similar in concept to the ODC cpio format but with its own specific header structure.
Therefore, calling archive_write_set_format_cpio_pwb(archive) configures libarchive to write the subsequent archive entries using the PWB cpio format. This format, like ODC cpio, uses ASCII to represent the header information, aiming for portability. However, the exact layout and fields within the PWB cpio header will differ from the ODC cpio header.

You would likely use this format when you need to create cpio archives specifically for systems or tools that expect the PWB cpio format. You would call this function before adding entries to the archive.
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_gnutar

```
Integer archive_write_set_format_gnutar (Pointer pArchive)
```

The function sets the format for writing an archive to the GNU tar format.
GNU tar: This is the format used by the widely popular GNU tar utility. It's an extension of the older ustar format and includes several enhancements and features.
Extensions: GNU tar adds support for:
Longer filenames: Beyond the 256-character limit of ustar.
Sparse files: Efficiently storing files with large sections of zeros.
Extended attributes: Storing additional metadata.
Long link names.
And other GNU-specific extensions.
Therefore, calling archive_write_set_format_gnutar(archive) configures libarchive to write subsequent archive entries in the GNU tar format, taking advantage of these extensions when necessary. This format is very common in the Linux/Unix world.
You would typically choose this format when you need the features offered by GNU tar and expect the archive to be primarily used on systems that support it. You would call this function before adding file entries to the archive.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_iso9660

```
Integer archive_write_set_format_iso9660 (Pointer pArchive)
```

The function archive_write_set_format_iso9660 from the libarchive library sets the format for writing an archive to the ISO 9660 file system format.
ISO 9660: This is an international standard defining the file system structure for CD-ROMs and other read-only media. It's known for its broad compatibility across different operating systems.
Structure: An ISO 9660 file system has a specific structure including:
A system area (unused by the standard).
A data area containing volume descriptors, path tables, and the directory and file data.
Various levels of compliance (e.g., Level 1 with 8.3 filenames, Level 2 allowing longer names, and extensions like Joliet and Rock Ridge for better support of modern file systems).
Therefore, calling archive_write_set_format_iso9660(archive) configures libarchive to generate an ISO 9660 image as you add files and directories to the archive. This means libarchive will handle the layout and metadata according to the ISO 9660 standard.
You would typically use this when you want to create an ISO image (often with a .iso file extension) that can be burned to a CD-ROM or mounted as a virtual CD-ROM. You would call this function before adding the file system content you want to include in the ISO image.
It's worth noting that basic ISO 9660 has limitations (e.g., filename length). Often, extensions like Rock Ridge (for POSIX-like systems) or Joliet (for Windows) are used in conjunction with ISO 9660 to overcome these limitations. You might need to use other libarchive functions to enable these extensions if desired.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_mtree

```
Integer archive_write_set_format_mtree (Pointer pArchive)
```

The function archive_write_set_format_mtree from the libarchive library sets the format for writing an archive to the mtree format.
This function likely sets the format to a more current or extended version of the mtree format compared to archive_write_set_format_mtree_classic.
mtree: As mentioned before, mtree is used to describe directory hierarchies, including file metadata like permissions, ownership, size, and checksums. It's often used for system administration tasks like installation and verification.
Modern/Extended: This version of the mtree format might include features not present in the "classic" version, such as:
Support for more metadata attributes.
Potentially a slightly different or more flexible syntax.
Better handling of extended file attributes or other modern filesystem features.
Calling archive_write_set_format_mtree(archive) configures libarchive to generate an mtree specification using a potentially more feature-rich or up-to-date syntax. You would use this when you need to create an mtree manifest and want to leverage the capabilities of a more recent mtree implementation.
You would call this function before adding the directory entries and their associated metadata that you want to include in the mtree output.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_mtree_classic

```
Integer archive_write_set_format_mtree_classic (Pointer pArchive)
```

The function archive_write_set_format_mtree_classic from the libarchive library sets the format for writing an archive to the classic mtree format.
mtree: The mtree utility and format are used to create and verify directory hierarchies. An mtree file typically contains a textual description of a directory structure, including filenames, permissions, ownership, sizes, and checksums. It's often used for system installation and integrity checking.
Classic: The "classic" variant likely refers to an earlier or more basic version of the mtree format, possibly with fewer features or a slightly different syntax compared to more extended versions.
You would typically use this when you need to generate an mtree manifest in the classic format, perhaps for compatibility with older tools or systems that expect this specific syntax. You would call this function before adding the directory entries you want to include in the mtree specification.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_pax

```
Integer archive_write_set_format_pax (Pointer pArchive)
```

The function archive_write_set_format_pax from the libarchive library sets the format for writing an archive to the full POSIX.1-2001 pax format.
pax Format: As mentioned before, PAX (Portable Archive eXchange) is a modern and flexible archive format defined by POSIX.1-2001. It overcomes many limitations of older tar formats like ustar and v7tar.
Full PAX: Unlike the "restricted" PAX format, setting the format to just pax allows libarchive to utilize the full capabilities of the PAX standard. This includes:
Support for arbitrarily long filenames.
Support for very large file sizes.
Extensive support for extended headers to store more metadata (e.g., extended timestamps, ACLs, security labels).
You would typically choose this format when you need the advanced features offered by PAX and are less concerned about compatibility with very old systems that might only fully support older tar variants. You would call this function before adding file entries to the archive.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_pax_restricted

```
Integer archive_write_set_format_pax_restricted (Pointer pArchive)
```

The function archive_write_set_format_pax_restricted from the libarchive library sets the format for writing an archive to the restricted POSIX.1-2001 pax format.
pax Format: PAX (Portable Archive eXchange) is a more modern and flexible archive format compared to ustar. It's defined by POSIX.1-2001.
Restricted: The "restricted" variant of PAX aims for greater interoperability by limiting the use of certain extended headers and features that might not be universally supported by all PAX implementations. This often means sticking to a more basic subset of the PAX standard.
You would typically call this function before adding file entries to the archive when you want the benefits of the PAX format (like support for very long filenames and larger files) while also maximizing the chances that the resulting archive can be read by a wider range of PAX-compliant tools.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_raw

```
Integer archive_write_set_format_raw (Pointer pArchive)
```

The function archive_write_set_format_raw from the libarchive library sets the format for writing an archive to the raw format.
Raw Format: In the context of libarchive writing, the "raw" format essentially means that libarchive will not add any archive-specific metadata or headers around the data you provide. It will simply write the data you feed it directly to the output.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_shar

```
Integer archive_write_set_format_shar (Pointer pArchive)
```

The function archive_write_set_format_shar from the libarchive library sets the format for writing an archive to the shar (shell archive) format.
This is similar to archive_write_set_format_shar_dump, as both produce shell archives. However, they might differ in the specific method used to encode the file data within the shell script.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_shar_dump

```
Integer archive_write_set_format_shar_dump (Pointer pArchive)
```

The function archive_write_set_format_shar_dump from the libarchive library sets the format for writing an archive to the shar dump format.
shar (shell archive): A shar file is a self-extracting archive that consists of shell scripts. When executed, these scripts recreate the original files and directories.
dump format: The "dump" part likely refers to the style in which the files are represented within the shar archive, possibly resembling the output of the dump utility in terms of how file data is encoded within the shell script.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_ustar

```
Integer archive_write_set_format_ustar (Pointer pArchive)
```

The function archive_write_set_format_ustar from the libarchive library sets the format for writing an archive to the POSIX.1-1988 (ustar) tar format.
- tar Format: As before, tar stands for tape archive, a common format for archiving files.
- ustar: This is a standardized tar format defined by POSIX.1-1988. It addressed many of the limitations of the older V7 tar format. Key improvements over V7 tar include:
- Longer filenames: Support for filenames up to 256 characters.
- Support for user and group names (beyond just IDs).
- Larger file sizes.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_warc

```
Integer archive_write_set_format_warc (Pointer pArchive)
```

The function archive_write_set_format_warc from the libarchive library sets the format for writing an archive to the Web ARChive (WARC) format.
WARC is an ISO standard (ISO 28500) archive file format used for archiving web content. It's designed to store multiple digital resources, including the payload content retrieved from the web along with associated metadata.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_write_set_format_xar

```
Integer archive_write_set_format_xar (Pointer pArchive)
```

The function archive_write_set_format_xar from the libarchive library sets the format for writing an archive to the XAR (eXtensible ARchive) format.
XAR is an open-source archive format, notably used in macOS for software installation and packaging. It's designed to be flexible and extensible.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** This archive.dll has no XAR support: the function returns ARCHIVE_WARN ("Xar not supported on this platform") and every following write fails.

Returns: `Integer`

#### archive_write_set_format_zip

```
Integer archive_write_set_format_zip (Pointer pArchive)
```

The function sets the output format to ZIP.
Its return values indicate success or failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`
