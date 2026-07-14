# Demo directory

This directory should include a demo DataFlex workspace that uses the library in the `Library` directory.

## Overview

The workspace contains the archive-writer GUI and the headless security tests for `cArchiveReader`.

## Structure

- `AppSrc/`: Contains the source code for the demo application.
- `Data/`: Includes any sample data files required for the demo.
- `DDSrc/`: Contains Data Dictionary source files.
- `Programs/`: Compiled executable files for the demo application.
- `Tests/RunArchiveReaderTests.ps1`: Generates adversarial ZIP fixtures, compiles the test project, and runs it.

## Getting Started

1. Ensure that the library in the `Library` directory is properly set up.
2. Open the demo workspace in DataFlex.
3. Compile and run the demo application to see the library in action.

To exercise inspection and bounded extraction directly:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Tests\RunArchiveReaderTests.ps1
```

Pass `-KeepFixtures` to retain generated archives and extracted output for debugging. The runner uses `df-cli build` with the DataFlex 25 x64 toolchain by default; override these with `-DfCli` or `-Toolchain` when needed.

## DLLs
The programs folder contains 7 64 bit DLL files. At this moment there is no plan to make 32 bit DLLs.
The archive.dll file is the main file, the others are used when needed.
These files, when you use the library in your own environment, need to be present as well in your programs folder. The files are plain DLLs, it is not COM, no regsvr32 can and should be used.

## Requirements

- DataFlex development environment
- The library from the `Library` directory

See the repository and library READMEs for the reader API, deployment requirements, and security boundary.
