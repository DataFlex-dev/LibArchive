# ArchiveMatch.h.pkg

Functions to match entries against path, time and owner conditions (archive_match_*).

Source: `Library/AppSrc/ArchiveMatch.h.pkg`. All functions are declared with `External_Function <name> "<export>" archive.dll`; the DataFlex name equals the DLL export unless noted. Pointers to libarchive objects are `Pointer`; strings are passed as `Pointer` to a NUL terminated string (`AddressOf (sValue)`) and returned as `Pointer` (use `PointerToString`).

## Index

- [`archive_match_new`](#archive_match_new)
- [`archive_match_free`](#archive_match_free)
- [`archive_match_excluded`](#archive_match_excluded)
- [`archive_match_path_excluded`](#archive_match_path_excluded)
- [`archive_match_set_inclusion_recursion`](#archive_match_set_inclusion_recursion)
- [`archive_match_exclude_pattern`](#archive_match_exclude_pattern)
- [`archive_match_exclude_pattern_w`](#archive_match_exclude_pattern_w)
- [`archive_match_exclude_pattern_from_file`](#archive_match_exclude_pattern_from_file)
- [`archive_match_exclude_pattern_from_file_w`](#archive_match_exclude_pattern_from_file_w)
- [`archive_match_include_pattern`](#archive_match_include_pattern)
- [`archive_match_include_pattern_w`](#archive_match_include_pattern_w)
- [`archive_match_include_pattern_from_file`](#archive_match_include_pattern_from_file)
- [`archive_match_include_pattern_from_file_w`](#archive_match_include_pattern_from_file_w)
- [`archive_match_path_unmatched_inclusions`](#archive_match_path_unmatched_inclusions)
- [`archive_match_path_unmatched_inclusions_next`](#archive_match_path_unmatched_inclusions_next)
- [`archive_match_path_unmatched_inclusions_next_w`](#archive_match_path_unmatched_inclusions_next_w)
- [`archive_match_time_excluded`](#archive_match_time_excluded)
- [`archive_match_include_time`](#archive_match_include_time)
- [`archive_match_include_date`](#archive_match_include_date)
- [`archive_match_include_date_w`](#archive_match_include_date_w)
- [`archive_match_include_file_time`](#archive_match_include_file_time)
- [`archive_match_include_file_time_w`](#archive_match_include_file_time_w)
- [`archive_match_exclude_entry`](#archive_match_exclude_entry)
- [`archive_match_owner_excluded`](#archive_match_owner_excluded)
- [`archive_match_include_uid`](#archive_match_include_uid)
- [`archive_match_include_gid`](#archive_match_include_gid)
- [`archive_match_include_uname`](#archive_match_include_uname)
- [`archive_match_include_uname_w`](#archive_match_include_uname_w)
- [`archive_match_include_gname`](#archive_match_include_gname)
- [`archive_match_include_gname_w`](#archive_match_include_gname_w)
- [`archive_utility_string_sort`](#archive_utility_string_sort)

## Reference

#### archive_match_new

```
Pointer archive_match_new ()
```

Allocates a new archive_match object that tests entries against path, time and owner conditions.

Returns: `Pointer`

#### archive_match_free

```
Integer archive_match_free (Pointer pArchive)
```

Releases an archive_match object.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_match_excluded

```
Integer archive_match_excluded (Pointer pArchive, Pointer pEntry)
```

Convenience test: 1 when the entry is excluded by path, time or owner conditions.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_match_path_excluded

```
Integer archive_match_path_excluded (Pointer pArchive, Pointer pEntry)
```

1 when the pathname of the entry is excluded by the path patterns.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_match_set_inclusion_recursion

```
Integer archive_match_set_inclusion_recursion (Pointer pArchive, Integer iEnable)
```

Controls whether the content of an included directory is included too (default on).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iEnable` | `Integer` |

Returns: `Integer`

#### archive_match_exclude_pattern

```
Integer archive_match_exclude_pattern (Pointer pArchive, Pointer pPattern)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_exclude_pattern_w` instead. The wrapper classes do not call this function.

Adds an exclusion pathname pattern.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPattern` | `Pointer` |

Returns: `Integer`

#### archive_match_exclude_pattern_w

```
Integer archive_match_exclude_pattern_w (Pointer pArchive, Pointer pPattern)
```

Adds an exclusion pathname pattern (wide string).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPattern` | `Pointer` |

Returns: `Integer`

#### archive_match_exclude_pattern_from_file

```
Integer archive_match_exclude_pattern_from_file (Pointer pArchive, Pointer pFileName, Integer iNullSeparator)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_exclude_pattern_from_file_w` instead. The wrapper classes do not call this function.

Adds exclusion patterns read from a text file; patterns are separated by a null byte instead of a newline when iNullSeparator is not 0.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `iNullSeparator` | `Integer` |

Returns: `Integer`

#### archive_match_exclude_pattern_from_file_w

```
Integer archive_match_exclude_pattern_from_file_w (Pointer pArchive, Pointer pFileName, Integer iNullSeparator)
```

Wide file name variant of archive_match_exclude_pattern_from_file.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `iNullSeparator` | `Integer` |

Returns: `Integer`

#### archive_match_include_pattern

```
Integer archive_match_include_pattern (Pointer pArchive, Pointer pPattern)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_include_pattern_w` instead. The wrapper classes do not call this function.

Adds an inclusion pathname pattern.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPattern` | `Pointer` |

Returns: `Integer`

#### archive_match_include_pattern_w

```
Integer archive_match_include_pattern_w (Pointer pArchive, Pointer pPattern)
```

Adds an inclusion pathname pattern (wide string).

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pPattern` | `Pointer` |

Returns: `Integer`

#### archive_match_include_pattern_from_file

```
Integer archive_match_include_pattern_from_file (Pointer pArchive, Pointer pFileName, Integer iNullSeparator)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_include_pattern_from_file_w` instead. The wrapper classes do not call this function.

Adds inclusion patterns read from a text file; patterns are separated by a null byte instead of a newline when iNullSeparator is not 0.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `iNullSeparator` | `Integer` |

Returns: `Integer`

#### archive_match_include_pattern_from_file_w

```
Integer archive_match_include_pattern_from_file_w (Pointer pArchive, Pointer pFileName, Integer iNullSeparator)
```

Wide file name variant of archive_match_include_pattern_from_file.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pFileName` | `Pointer` |
| `iNullSeparator` | `Integer` |

Returns: `Integer`

#### archive_match_path_unmatched_inclusions

```
Integer archive_match_path_unmatched_inclusions (Pointer pArchive)
```

Number of inclusion patterns that matched nothing so far.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |

Returns: `Integer`

#### archive_match_path_unmatched_inclusions_next

```
Integer archive_match_path_unmatched_inclusions_next (Pointer pArchive, Pointer ppPattern)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_path_unmatched_inclusions_next_w` instead. The wrapper classes do not call this function.

Stores a pointer to the next unmatched inclusion pattern in the variable pointed to; returns ARCHIVE_EOF when there are no more.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `ppPattern` | `Pointer` |

Returns: `Integer`

#### archive_match_path_unmatched_inclusions_next_w

```
Integer archive_match_path_unmatched_inclusions_next_w (Pointer pArchive, Pointer ppPattern)
```

Wide string variant of archive_match_path_unmatched_inclusions_next.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `ppPattern` | `Pointer` |

Returns: `Integer`

#### archive_match_time_excluded

```
Integer archive_match_time_excluded (Pointer pArchive, Pointer pEntry)
```

1 when the entry is excluded by the time conditions.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_match_include_time

```
Integer archive_match_include_time (Pointer pArchive, Integer iFlag, BigInt iSeconds, Integer iNanoSeconds)
```

Sets an inclusion time. iFlag combines ARCHIVE_MATCH_MTIME or _CTIME with ARCHIVE_MATCH_NEWER, _OLDER and/or _EQUAL.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlag` | `Integer` |
| `iSeconds` | `BigInt` |
| `iNanoSeconds` | `Integer` |

Returns: `Integer`

#### archive_match_include_date

```
Integer archive_match_include_date (Pointer pArchive, Integer iFlag, Pointer pDateString)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_include_date_w` instead. The wrapper classes do not call this function.

Sets an inclusion time from a date string. iFlag as for archive_match_include_time.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlag` | `Integer` |
| `pDateString` | `Pointer` |

Returns: `Integer`

#### archive_match_include_date_w

```
Integer archive_match_include_date_w (Pointer pArchive, Integer iFlag, Pointer pDateString)
```

Wide string variant of archive_match_include_date.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlag` | `Integer` |
| `pDateString` | `Pointer` |

Returns: `Integer`

#### archive_match_include_file_time

```
Integer archive_match_include_file_time (Pointer pArchive, Integer iFlag, Pointer pPathName)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_include_file_time_w` instead. The wrapper classes do not call this function.

Sets an inclusion time from the time stamps of a file. iFlag as for archive_match_include_time.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlag` | `Integer` |
| `pPathName` | `Pointer` |

Returns: `Integer`

#### archive_match_include_file_time_w

```
Integer archive_match_include_file_time_w (Pointer pArchive, Integer iFlag, Pointer pPathName)
```

Wide string variant of archive_match_include_file_time.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlag` | `Integer` |
| `pPathName` | `Pointer` |

Returns: `Integer`

#### archive_match_exclude_entry

```
Integer archive_match_exclude_entry (Pointer pArchive, Integer iFlag, Pointer pEntry)
```

Excludes entries that are newer, older or equal to the given entry; iFlag as for archive_match_include_time.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iFlag` | `Integer` |
| `pEntry` | `Pointer` |

> **Note:** The match is by path name: it excludes entries with the same path whose time is newer, older or equal as flagged, not any newer or older entry.

Returns: `Integer`

#### archive_match_owner_excluded

```
Integer archive_match_owner_excluded (Pointer pArchive, Pointer pEntry)
```

1 when the entry is excluded by the owner (uid, gid, uname, gname) conditions.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pEntry` | `Pointer` |

Returns: `Integer`

#### archive_match_include_uid

```
Integer archive_match_include_uid (Pointer pArchive, BigInt iUserId)
```

Adds a user id to the inclusion list.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iUserId` | `BigInt` |

Returns: `Integer`

#### archive_match_include_gid

```
Integer archive_match_include_gid (Pointer pArchive, BigInt iGroupId)
```

Adds a group id to the inclusion list.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `iGroupId` | `BigInt` |

Returns: `Integer`

#### archive_match_include_uname

```
Integer archive_match_include_uname (Pointer pArchive, Pointer pUserName)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_include_uname_w` instead. The wrapper classes do not call this function.

Adds a user name to the inclusion list.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pUserName` | `Pointer` |

Returns: `Integer`

#### archive_match_include_uname_w

```
Integer archive_match_include_uname_w (Pointer pArchive, Pointer pUserName)
```

Wide string variant of archive_match_include_uname.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pUserName` | `Pointer` |

Returns: `Integer`

#### archive_match_include_gname

```
Integer archive_match_include_gname (Pointer pArchive, Pointer pGroupName)
```

> **Obsolete:** uses the ANSI code page of the system. Use `archive_match_include_gname_w` instead. The wrapper classes do not call this function.

Adds a group name to the inclusion list.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pGroupName` | `Pointer` |

Returns: `Integer`

#### archive_match_include_gname_w

```
Integer archive_match_include_gname_w (Pointer pArchive, Pointer pGroupName)
```

Wide string variant of archive_match_include_gname.

| Parameter | Type |
|---|---|
| `pArchive` | `Pointer` |
| `pGroupName` | `Pointer` |

Returns: `Integer`

#### archive_utility_string_sort

```
Integer archive_utility_string_sort (Pointer pStrings)
```

Sorts a zero-terminated array of char pointers in place.

| Parameter | Type |
|---|---|
| `pStrings` | `Pointer` |

Returns: `Integer`
