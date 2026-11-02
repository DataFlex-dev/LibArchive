# Unit tests

The `unittests` workspace (`unittests/unittests.sws`) contains a [DFUnit](https://github.com/DataFlex-dev/DFUnit) test application, `unittests/AppSrc/LibArchiveTests.src`. It tests **every external function** of `archive.dll` (all 432 are called at least once, deprecated ones included), **every public property and method** of the wrapper classes and the ZIP preflight/extraction security checks of `cArchiveReader`: 333 tests, 7700+ assertions. It compiles the code in the `Library` folder, not a published package.

## Build and run

```
df-cli build -t LibArchiveTests.src "unittests/unittests.sws"
unittests\Programs\LibArchiveTests64.exe -c
```

| Argument | Meaning |
|---|---|
| `-c` | Console output (the program is a Windows program that attaches to the console of its parent; run it from a console) |
| `-g` | GUI test runner |
| `-o <file.xml>` | XML result file |
| `--junit-file <absolute file>` | Console output plus JUnit XML to a file (use an absolute path) |

The exit code is 0 when all tests passed. Test files are written to `unittests/Programs/TestTemp` and removed by the tests.

The `ZipReader` fixture reads adversarial ZIP files that must be generated first. To run the whole suite use `unittests\Tests\RunArchiveReaderTests.ps1`: it generates the fixtures, builds the application, runs it and removes the fixtures (`-KeepFixtures` keeps the fixtures and the result XML). When the fixtures are missing, only the `ZipReader` tests fail.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\unittests\Tests\RunArchiveReaderTests.ps1
```

## Structure

`LibArchiveTests.src` `Use`s the library classes and then the fixture packages from `unittests/AppSrc/Tests`. Classes cannot be declared inside objects, so all `Use` statements for classes come first, followed by the test application object that includes the fixtures.

| Package | Fixture | Covers |
|---|---|---|
| `TestSupport.pkg` | (class `cArchiveTestFixture`) | Temp folder, sample archive builder (4 entries incl. a Unicode name, built with raw external functions), assertion helpers |
| `TestSmoke.pkg` | Smoke | Template and round trip smoke test |
| `TestCommon.pkg` | Common | `ArchiveCommon.h.pkg`: versions, errors, format and filter information |
| `TestRead.pkg` | Read | `ArchiveRead.h.pkg`: all formats, filters, open variants, header, data, options, passphrases, extraction |
| `TestReadDisk.pkg` | ReadDisk | `ArchiveReadDisk.h.pkg` |
| `TestWrite.pkg`, `TestWriteDisk.pkg` | Write, WriteDisk | `ArchiveWrite.h.pkg`: formats, filters, open variants, encryption, options, creating files on disk |
| `TestEntry.pkg`, `TestEntryLinks.pkg` | Entry, EntryLinks | `ArchiveEntry.h.pkg`: metadata, ACL, xattr, sparse, link resolver, fflags, digest, stat |
| `TestMatch.pkg` | Match | `ArchiveMatch.h.pkg` |
| `TestWrapperBase.pkg` | WrapperBase | `cArchiveBase` |
| `TestWrapperEntry.pkg` | WrapperEntry, WrapperLinkResolver | `cArchiveEntry`, `cArchiveLinkResolver` |
| `TestWrapperMatch.pkg` | WrapperMatch | `cArchiveMatch` |
| `TestWrapperReader.pkg`, `TestWrapperDiskReader.pkg` | WrapperReader, WrapperDiskReader | `cArchiveReader`, `cArchiveDiskReader` |
| `TestWrapperWriter.pkg`, `TestWrapperDiskWriter.pkg` | WrapperWriter, WrapperDiskWriter | `cArchiveWriter`, `cArchiveDiskWriter` |
| `TestFilesArchiver.pkg` | FilesArchiver | `cFilesArchiver` |
| `TestZipReader.pkg` | ZipReader | ZIP preflight and bounded extraction of `cArchiveReader` (`InspectZipArchive`, `ExtractZipArchive`); needs the fixtures from `RunArchiveReaderTests.ps1` |

## Writing a test

A fixture is an object of class `cArchiveTestFixture` in its own package; each test is a child object of class `cTest` with a `Procedure Test`. Helpers of the fixture are reached with `Delegate Get` / `Delegate Send`. See `TestSmoke.pkg` for the pattern, and [Notes](Notes.md) for behavior that tests must account for.
