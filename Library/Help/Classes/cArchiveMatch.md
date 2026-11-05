# cArchiveMatch

`Use cArchiveMatch.pkg` — `Class cArchiveMatch is a cArchiveBase`

Wrapper around a libarchive `struct archive_match`: tests archive entries against path patterns, time conditions and owner conditions. It decides which entries of an archive to extract, list or skip, for example for `tar` style include/exclude options, "newer than" updates or "only files of user X".

The class derives from [cArchiveBase](cArchiveBase.md): `ppArchive` holds the matcher handle, `pbRaiseErrors`, `piLastResult`, `psLastError`, `psErrorString` and the other shared members work as documented there. `FreeHandle` is overridden to call `archive_match_free`.

## Ownership

- The handle is created by `CreateMatch` (`archive_match_new`) or **automatically by the first method that needs it** (`EnsureHandle`), so `CreateMatch` is optional. It is released by `FreeHandle` or when the object is destroyed. `FreeHandle` followed by a method call starts a fresh matcher without any condition.
- Entries are passed as [cArchiveEntry](cArchiveEntry.md) **object handles**; the matcher only reads them and does not keep them (an exception: `ExcludeEntry` copies path and times of the entry). An entry object that has no entry raises a DataFlex error.
- libarchive cannot call back into DataFlex and the matcher has no callbacks.

## How the conditions combine

- **Path patterns** are shell wildcard patterns (`*`, `?`, `[a-z]`). An entry that matches an exclusion pattern is excluded. If inclusion patterns exist, an entry that matches none of them is excluded. Exclusion wins over inclusion. With inclusion recursion (default) an included directory pattern also includes everything below it.
- **Time conditions** (`IncludeTime`, `IncludeDate`, `IncludeFileTime`) include only entries whose mtime or ctime is newer, older or equal (as flagged) to the given time. `ExcludeEntry` excludes entries *with the same path name* as a reference entry when their time compares as flagged.
- **Owner conditions** (`IncludeUid`, `IncludeGid`, `IncludeUname`, `IncludeGname`): when owner conditions exist, an entry that matches none of them is excluded.
- `IsExcluded` combines path, time and owner conditions; `IsPathExcluded`, `IsTimeExcluded` and `IsOwnerExcluded` test one kind.

Time flags (combine with `ior`): `ARCHIVE_MATCH_MTIME` or `ARCHIVE_MATCH_CTIME` selects the time of the entry, `ARCHIVE_MATCH_NEWER`, `ARCHIVE_MATCH_OLDER` and `ARCHIVE_MATCH_EQUAL` the comparison. `ARCHIVE_MATCH_NEWER` alone means strictly newer.

## Strings

Patterns, names, date texts and file names are passed as **wide strings** (the `*_w` libarchive functions), so every character survives.

## Properties

| Property | Type | Access | libarchive function |
|---|---|---|---|
| `pbInclusionRecursion` | `Boolean` | read/write | `archive_match_set_inclusion_recursion` — True (default): the content of an included directory is included too. libarchive has no getter; the value is the one last set. A new handle starts with True. |
| `pbInclusionRecursionState` | `Boolean` | private | Internal storage of the value last given to `pbInclusionRecursion`; use `pbInclusionRecursion` instead. |
| `ppArchive`, `pbRaiseErrors`, `piLastResult`, `psLastError`, `psErrorString`, ... | | | Inherited from [cArchiveBase](cArchiveBase.md). |

## Methods

Methods that call libarchive return the result code (`ARCHIVE_OK`, ...) unless noted; failures (`ARCHIVE_FAILED` or worse) raise a DataFlex error when `pbRaiseErrors` is True.

### Handle

| Method | Description | libarchive function |
|---|---|---|
| `Procedure CreateMatch` | Frees the current matcher and creates a new empty one. | `archive_match_new` |
| `Function EnsureHandle Returns Pointer` | Returns the handle, creating the matcher when there is none. | `archive_match_new` |
| `Procedure FreeHandle` | Releases the matcher. Safe without a handle. | `archive_match_free` |

### Tests

| Method | Description | libarchive function |
|---|---|---|
| `Function IsExcluded Handle hoEntry Returns Boolean` | True when the entry is excluded by the path, time or owner conditions. | `archive_match_excluded` |
| `Function IsPathExcluded Handle hoEntry Returns Boolean` | True when the path name is excluded by the path patterns. | `archive_match_path_excluded` |
| `Function IsTimeExcluded Handle hoEntry Returns Boolean` | True when the entry is excluded by the time conditions. | `archive_match_time_excluded` |
| `Function IsOwnerExcluded Handle hoEntry Returns Boolean` | True when the entry is excluded by the owner conditions. | `archive_match_owner_excluded` |

### Path patterns

| Method | Description | libarchive function |
|---|---|---|
| `Function ExcludePattern String sValue Returns Integer` | Adds an exclusion pattern. | `archive_match_exclude_pattern_w` |
| `Function IncludePattern String sValue Returns Integer` | Adds an inclusion pattern. | `archive_match_include_pattern_w` |
| `Function ExcludePatternFromFile String sFileName Boolean bNullSeparator Returns Integer` | Adds the exclusion patterns of a text file, one per line, or separated by a zero byte when `bNullSeparator`. | `archive_match_exclude_pattern_from_file_w` |
| `Function IncludePatternFromFile String sFileName Boolean bNullSeparator Returns Integer` | Adds the inclusion patterns of a text file. | `archive_match_include_pattern_from_file_w` |
| `Function UnmatchedInclusions Returns Integer` | Number of inclusion patterns that matched nothing so far (0 without handle). | `archive_match_path_unmatched_inclusions` |
| `Function UnmatchedInclusionPatterns Returns String[]` | Those patterns as an array (wide). Can be called repeatedly. | `archive_match_path_unmatched_inclusions_next_w` |

### Time conditions

| Method | Description | libarchive function |
|---|---|---|
| `Function IncludeTime Integer iFlag BigInt iSeconds Integer iNanoSeconds Returns Integer` | Includes entries by comparing with a Unix time. | `archive_match_include_time` |
| `Function IncludeDate Integer iFlag String sDate Returns Integer` | Same with a date text such as `"2023-11-14 22:13:20 UTC"`; an unparsable date is `ARCHIVE_FAILED`. | `archive_match_include_date_w` |
| `Function IncludeFileTime Integer iFlag String sFileName Returns Integer` | Same with the time stamps of a file. | `archive_match_include_file_time_w` |
| `Function ExcludeEntry Integer iFlag Handle hoEntry Returns Integer` | Excludes entries with the same path name as `hoEntry` whose time is newer, older or equal (`iFlag`). | `archive_match_exclude_entry` |

### Owner conditions

| Method | Description | libarchive function |
|---|---|---|
| `Function IncludeUid BigInt iUserId Returns Integer` | Adds a user id. | `archive_match_include_uid` |
| `Function IncludeGid BigInt iGroupId Returns Integer` | Adds a group id. | `archive_match_include_gid` |
| `Function IncludeUname String sValue Returns Integer` | Adds a user name (wide). | `archive_match_include_uname_w` |
| `Function IncludeGname String sValue Returns Integer` | Adds a group name (wide). | `archive_match_include_gname_w` |

### Helper

| Method | Description | libarchive function |
|---|---|---|
| `Function SortStrings String[] asStrings Returns String[]` | Returns the strings sorted by a byte wise comparison of their UTF-8 text. Needs no handle; the input array is unchanged. | `archive_utility_string_sort` |
| `Function EntryPointer Handle hoEntry Returns Pointer` | Returns the `ppEntry` of an entry object; raises an error when it has none. | |
| `Function ExcludedResult Integer iResult String sOperation Returns Boolean` | Turns a libarchive "excluded" result into a Boolean. | |

## Example

Extract only the text files of the user "alice" that changed after a date, except the ones below `tmp/`:

```
Use cArchiveMatch.pkg
Use cArchiveEntry.pkg

Object oMatch is a cArchiveMatch
End_Object

Object oEntry is a cArchiveEntry
End_Object

Integer iResult
Move (IncludePattern (oMatch, "*.txt")) to iResult
Move (ExcludePattern (oMatch, "tmp/*")) to iResult
Move (IncludeUname (oMatch, "alice")) to iResult
Move (IncludeDate (oMatch, (ARCHIVE_MATCH_MTIME ior ARCHIVE_MATCH_NEWER), "2023-11-14 22:13:20 UTC")) to iResult

// for every entry the reader returns:
Send AttachEntry of oEntry pEntry False
If (not (IsExcluded (oMatch, oEntry))) Begin
    // extract it
End
```

## Notes

- `IncludePattern` patterns are only "matched" when an entry that matches them was tested with `IsPathExcluded` or `IsExcluded`; use `UnmatchedInclusions` / `UnmatchedInclusionPatterns` after processing an archive to report patterns that matched no entry (the `tar` "Not found in archive" message).
- `ExcludeEntry` works by path name: it is meant to skip archive members that are not newer than the file already on disk.
- Setting `pbInclusionRecursion` creates the handle when there is none; `FreeHandle` resets the value to True.
