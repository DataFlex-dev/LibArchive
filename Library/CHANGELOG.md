# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0]
- All 432 functions that `archive.dll` (libarchive 3.7.7) exports are declared as `External_Function`, each with a comment. The declarations are split over `ArchiveCommon.h.pkg`, `ArchiveRead.h.pkg`, `ArchiveReadDisk.h.pkg`, `ArchiveWrite.h.pkg`, `ArchiveEntry.h.pkg` and `ArchiveMatch.h.pkg`; `Archive.h.pkg` holds the constants and includes them.
- Corrected declarations: `archive_entry_set_pathname_utf8` (was declared as `archive_entry_set_pathname`), `archive_write_set_format_mtree_classic` (export name was missing), `archive_set_error` (variadic argument), `time_t` / `long` / `mode_t` / `size_t` parameter and return types. `archive_write_set_format_ar_gnu` is removed: the DLL does not export it. `archive_read_open_FILE` and `archive_write_open_FILE` are declared as `archive_read_open_FILE_Ptr` and `archive_write_open_FILE_Ptr` (DataFlex names are case insensitive).
- New wrapper classes: `cArchiveBase`, `cArchiveEntry`, `cArchiveReader`, `cArchiveDiskReader`, `cArchiveWriter`, `cArchiveDiskWriter`, `cArchiveMatch` and `cArchiveLinkResolver`. Together they cover everything libarchive offers except the functions that need native callbacks.
- `cFilesArchiver` no longer needs the DateAndTime library.
- Unit tests (DFUnit) in the demo workspace for every external function and every class.
- Documentation of all classes, methods, external functions and constants.
- Requires DataFlex 26.0 (workspace format); the 64 bit DLLs are included.
