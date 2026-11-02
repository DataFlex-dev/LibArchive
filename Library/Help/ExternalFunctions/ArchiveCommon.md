# ArchiveCommon.h.pkg

Version, error, format and filter information functions that work on any archive handle.

Source: `Library/AppSrc/ArchiveCommon.h.pkg`. All functions are declared with `External_Function <name> "<export>" archive.dll`; the DataFlex name equals the DLL export unless noted. Pointers to libarchive objects are `Pointer`; strings are passed as `Pointer` to a NUL terminated string (`AddressOf (sValue)`) and returned as `Pointer` (use `PointerToString`).

## Index


**Version information**

- [`archive_version_number`](#archive_version_number)
- [`archive_version_string`](#archive_version_string)
- [`archive_version_details`](#archive_version_details)
- [`archive_zlib_version`](#archive_zlib_version)
- [`archive_liblzma_version`](#archive_liblzma_version)
- [`archive_bzlib_version`](#archive_bzlib_version)
- [`archive_liblz4_version`](#archive_liblz4_version)
- [`archive_libzstd_version`](#archive_libzstd_version)

**Errors**

- [`archive_errno`](#archive_errno)
- [`archive_error_string`](#archive_error_string)
- [`archive_clear_error`](#archive_clear_error)
- [`archive_set_error`](#archive_set_error)
- [`archive_copy_error`](#archive_copy_error)

**Archive information**

- [`archive_file_count`](#archive_file_count)
- [`archive_format`](#archive_format)
- [`archive_format_name`](#archive_format_name)
- [`archive_filter_count`](#archive_filter_count)
- [`archive_filter_bytes`](#archive_filter_bytes)
- [`archive_filter_code`](#archive_filter_code)
- [`archive_filter_name`](#archive_filter_name)
- [`archive_free`](#archive_free)

**Deprecated**

- [`archive_position_compressed`](#archive_position_compressed)
- [`archive_position_uncompressed`](#archive_position_uncompressed)
- [`archive_compression_name`](#archive_compression_name)
- [`archive_compression`](#archive_compression)

## Reference

### Version information

#### archive_version_number

```
Integer archive_version_number ()
```

Version of the loaded DLL as a number: major*1000000 + minor*1000 + patch (3007007 = 3.7.7).

Returns: `Integer`

#### archive_version_string

```
Pointer archive_version_string ()
```

Pointer to a zero-terminated string such as "libarchive 3.7.7". Read it with PointerToString.

Returns: `Pointer`

#### archive_version_details

```
Pointer archive_version_details ()
```

Pointer to a string with the libarchive version followed by the versions of the libraries it was built with (zlib, liblzma, ...).

Returns: `Pointer`

#### archive_zlib_version

```
Pointer archive_zlib_version ()
```

Pointer to the zlib version string, or 0 if libarchive was built without zlib.

Returns: `Pointer`

#### archive_liblzma_version

```
Pointer archive_liblzma_version ()
```

Pointer to the liblzma version string, or 0 if libarchive was built without liblzma.

Returns: `Pointer`

#### archive_bzlib_version

```
Pointer archive_bzlib_version ()
```

Pointer to the bzlib version string, or 0 if libarchive was built without bzlib.

Returns: `Pointer`

#### archive_liblz4_version

```
Pointer archive_liblz4_version ()
```

Pointer to the liblz4 version string, or 0 if libarchive was built without liblz4.

Returns: `Pointer`

#### archive_libzstd_version

```
Pointer archive_libzstd_version ()
```

Pointer to the libzstd version string, or 0 if libarchive was built without libzstd.

Returns: `Pointer`

### Errors

#### archive_errno

```
Integer archive_errno (Pointer pArchive)
```

archive_errno is a function in the libarchive library that returns the error number associated with the last operation performed on the given archive handle.

When an archive operation (like reading a header, reading data, or opening an archive) fails, libarchive typically sets an internal error code. You can retrieve this error code using archive_errno().

The value returned by archive_errno() is similar to the standard C library's errno, and the possible error codes are defined within libarchive. These error codes indicate the specific reason for the failure.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_error_string

```
Pointer archive_error_string (Pointer pArchive)
```

The function archive_error_string from the libarchive library is used to retrieve a human-readable error message associated with the most recent error that occurred on a given archive handle.

You pass the archive handle (either for reading or writing) that you suspect might have encountered an error.
Returns a pointer points to a null-terminated string containing the error message. If no error has occurred, or if the archive handle is invalid, it might return NULL or an empty string (though typically it will return a message if an error flag is set on the archive object).
You would typically call archive_error_string(archive) after a libarchive function returns an error indication (e.g., a non-ARCHIVE_OK return code). This allows you to get more detailed information about why the operation failed.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Pointer`

#### archive_clear_error

```
Void_Type archive_clear_error (Pointer pArchive)
```

archive_clear_error(struct archive *) is a function in the libarchive library that clears any pending error conditions associated with the specified archive handle.

When an error occurs during an archive operation, libarchive stores an error code and an associated error message within the struct archive object. Calling archive_clear_error(a) resets these internal error indicators for the archive handle a.

Here's why you might use archive_clear_error():

Attempting recovery: If an error occurs during processing (e.g., while reading entries), you might want to clear the error and attempt to continue with the next operation.
Avoiding false positives: After handling an error, you might want to clear the error status so that subsequent checks for errors reflect the outcome of the following operations, not the previous one.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Void_Type`

#### archive_set_error

```
Void_Type archive_set_error (Pointer pArchive, Integer iErrorNumber, Pointer pFormat, Pointer pArgument)
```

Sets the error number and error message of the archive handle (printf style format plus one string argument).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iErrorNumber` | `Integer` |
| `pFormat` | `Pointer` |
| `pArgument` | `Pointer` |

> **Note:** The C function is printf style variadic. It is declared with exactly one variadic argument: pass "%s" as pFormat and a pointer to the message text as pArgument.

Returns: `Void_Type`

#### archive_copy_error

```
Void_Type archive_copy_error (Pointer pDest, Pointer pSource)
```

Copies the error number and error message from the source archive handle to the destination archive handle.

| Parameter | Type |
|---|---|
| `pDest` | `Pointer` |
| `pSource` | `Pointer` |

Returns: `Void_Type`

### Archive information

#### archive_file_count

```
Integer archive_file_count (Pointer pArchive)
```

Number of entries (headers) processed so far on this archive handle.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

> **Note:** Stays 0 on an archive_read_disk handle.

Returns: `Integer`

#### archive_format

```
Integer archive_format (Pointer pArchive)
```

Format code (ARCHIVE_FORMAT_*) of the current entry; for readers it is updated by archive_read_next_header.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_format_name

```
Pointer archive_format_name (Pointer pArchive)
```

Pointer to a zero-terminated, human readable name of the format of the current entry (for example "POSIX pax interchange format").

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Pointer`

#### archive_filter_count

```
Integer archive_filter_count (Pointer pArchive)
```

Number of filters in the filter pipeline of the archive. Filter 0 is the one closest to the format; -1 is the last filter (the I/O layer).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_filter_bytes

```
BigInt archive_filter_bytes (Pointer pArchive, Integer iFilterIndex)
```

Number of bytes read from or written to the filter with the given index (-1 = last filter).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFilterIndex` | `Integer` |

Returns: `BigInt`

#### archive_filter_code

```
Integer archive_filter_code (Pointer pArchive, Integer iFilterIndex)
```

Filter code (ARCHIVE_FILTER_*) of the filter with the given index (-1 = last filter).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFilterIndex` | `Integer` |

Returns: `Integer`

#### archive_filter_name

```
Pointer archive_filter_name (Pointer pArchive, Integer iFilterIndex)
```

Pointer to the zero-terminated name of the filter with the given index (-1 = last filter).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFilterIndex` | `Integer` |

Returns: `Pointer`

#### archive_free

```
Integer archive_free (Pointer pArchive)
```

Simplified cleanup interface;This calls archive_read_free() or archive_write_free() as needed.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

### Deprecated

#### archive_position_compressed

```
BigInt archive_position_compressed (Pointer pArchive)
```

Deprecated alias for archive_filter_bytes (a, -1).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `BigInt`

#### archive_position_uncompressed

```
BigInt archive_position_uncompressed (Pointer pArchive)
```

Deprecated alias for archive_filter_bytes (a, 0).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `BigInt`

#### archive_compression_name

```
Pointer archive_compression_name (Pointer pArchive)
```

Deprecated alias for archive_filter_name (a, 0).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Pointer`

#### archive_compression

```
Integer archive_compression (Pointer pArchive)
```

Deprecated alias for archive_filter_code (a, 0).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`
