# LibArchive library

Add `LibArchive.sws` as a DataFlex library, deploy the required 64-bit DLLs beside the consuming executable, and `Use cArchiveReader.pkg` for untrusted ZIP input.

## Reader API

`cArchiveReader` has two public functions:

- `InspectZipArchive String sArchivePath Returns tArchiveOperationResult`
- `ExtractZipArchive String sArchivePath String sDestination Returns tArchiveOperationResult`

`ExtractZipArchive` includes the inspection pass; callers do not need to invoke both. The result contains success, a stable application result code, an internal diagnostic, archive/central-directory byte sizes, entry/path-component counts, declared uncompressed bytes, and bytes actually written.

Configure positive values for:

- `piMaxEntryUncompressedBytes`
- `piMaxTotalUncompressedBytes`
- `piMaxArchiveBytes`
- `piMaxCentralDirectoryBytes` (up to 64 MiB)
- `piMaxEntries` (up to 65,534)
- `piMaxPathLength` (1-259)
- `piMaxPathComponents`
- `piReadBlockSize` (4 KiB-1 MiB)

Defaults are 100 MiB for the archive, each entry, and the extracted total; 8 MiB of central-directory metadata; 10,000 entries; 240 relative-path characters; 100,000 aggregate path components; and 64 KiB read blocks.

The detailed result message is intended for trusted logs. Server endpoints should map every failure to the same generic push error.

## Required caller guarantees

- Enforce the compressed upload limit before parsing.
- Keep the source file immutable until extraction finishes.
- Supply a destination that does not exist.
- Use an existing, application-owned, non-reparse destination parent that untrusted processes cannot modify.
- Keep the native libarchive DLL and its dependencies current.

The reader accepts only plain, single-volume, non-ZIP64 seekable ZIP files whose entries use stored or deflate compression. It requires matching local and central compression metadata, rejects encryption markers in either header, and validates the end record, every bounded central-directory record, and each compressed-data extent before libarchive can allocate or rescan seekable data. It deliberately avoids `archive_read_extract`; application-owned block writes allow actual decompressed bytes to be checked before they reach disk.

## Tests

`LibArchive.sws` contains the DFUnit-based `ArchiveReaderTests` project. From the repository root, generate its adversarial ZIP fixtures, build it with the DataFlex 26 x64 toolchain, and run it in console mode with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Demo\Tests\RunArchiveReaderTests.ps1
```

The script returns a failing process exit code when the build or any DFUnit test fails. Pass `-KeepFixtures` only when the generated archives or JUnit-compatible XML report are needed for debugging.
