# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- The ANSI code page variants are no longer wrapped. Removed: the `psXLocale` properties and the `CopyXLocale`, `SetLinkLocale` and `CopyLinkLocale` methods of `cArchiveEntry`, the `*Locale` methods of `cArchiveMatch` and `cArchiveWriter.OpenFileAnsi`. The `External_Function` declarations stay, 37 of them marked **obsolete** in `Archive*.h.pkg` and in `Help/ExternalFunctions` with the `_w` / `_utf8` function to use instead. `cArchiveEntry.AclAddEntry`, `AclToText`, `AclTextLegacy`, `AclFromText` and `CopyFFlagsText` now use the wide functions (the `...Wide` methods are gone); `cFilesArchiver` and `cArchivePath.CurrentUnixTime` use `archive_write_open_filename_w` and `archive_match_include_date_w`. `AclNext` still reads names in the ANSI code page: `archive_entry_acl_next` has no other variant.
- No library source declares a Windows API function any more (`kernel32.dll`, `ucrtbase.dll` and `ntdll.dll` declarations removed from `cArchiveEntry`, `cArchiveReader` and `cArchiveWriter`). Folder listing, file type, size and time stamps, the current time, creating folders and `DataToFile` use DataFlex file I/O and libarchive; the path separator comes from `SysConf`. `cArchiveEntry.IsValidUtf8` is a DataFlex check, ACL text is released with `Free`.
- The file system helpers of `ArchivePath.pkg` are methods of the new class `cArchivePath`; the library adds no global function. The library classes create the object when they need it.
- `cFilesArchiver.FileFolderCreationUnixDateTime` returns the last modification time as `BigInt` (a creation time is not available on every platform).
- The native DLLs are tracked once, in `Library/Programs`; `Demo` and `unittests` get them from there through a workspace override.
- Removed `cArchiveReader.ExtractAll` and `piExtractedCount`: `ExtractZipArchive` replaces it for ZIP files (preflight, limits, no overwrite, cleanup on failure). To extract other formats loop over `NextHeader` and call `ExtractCurrent`.
- `ListEntries` and `ReadEntryData` of `cArchiveReader` return a `tArchiveOperationResult` and never raise an error (new signature: `ListEntries sFile (&aEntries)`, new code `C_ARCHIVE_RESULT_ENTRY_NOT_FOUND`). Before, a failure was an empty array or `False` and could raise an error with `pbRaiseErrors`.

## [1.0.0]
- All 432 functions that `archive.dll` (libarchive 3.7.7) exports are declared as `External_Function`, each with a comment. The declarations are split over `ArchiveCommon.h.pkg`, `ArchiveRead.h.pkg`, `ArchiveReadDisk.h.pkg`, `ArchiveWrite.h.pkg`, `ArchiveEntry.h.pkg` and `ArchiveMatch.h.pkg`; `Archive.h.pkg` holds the constants and includes them.
- Corrected declarations: `archive_entry_set_pathname_utf8` (was declared as `archive_entry_set_pathname`), `archive_write_set_format_mtree_classic` (export name was missing), `archive_set_error` (variadic argument), `time_t` / `long` / `mode_t` / `size_t` parameter and return types. `archive_write_set_format_ar_gnu` is removed: the DLL does not export it. `archive_read_open_FILE` and `archive_write_open_FILE` are declared as `archive_read_open_FILE_Ptr` and `archive_write_open_FILE_Ptr` (DataFlex names are case insensitive).
- New wrapper classes: `cArchiveBase`, `cArchiveEntry`, `cArchiveReader`, `cArchiveDiskReader`, `cArchiveWriter`, `cArchiveDiskWriter`, `cArchiveMatch` and `cArchiveLinkResolver`. Together they cover everything libarchive offers except the functions that need native callbacks.
- `cFilesArchiver` no longer needs the DateAndTime library.
- Unit tests (DFUnit) in the demo workspace for every external function and every class.
- Documentation of all classes, methods, external functions and constants.
- Requires DataFlex 26.0 (workspace format); the 64 bit DLLs are included.
