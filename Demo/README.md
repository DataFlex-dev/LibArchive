# Demo Directory

This directory should include a demo DataFlex workspace that uses the library in the `Library` directory.

## Overview

The purpose of this demo workspace is to provide examples and usage scenarios for the library located in the `Library` directory. It helps developers understand how to integrate and utilize the library in their own projects.

## Structure

- `AppSrc/`: Contains the source code for the demo application.
- `Data/`: Includes any sample data files required for the demo.
- `DDSrc/`: Contains Data Dictionary source files.
- `Programs/`: Compiled executable files for the demo application.

## Getting Started

1. Ensure that the library in the `Library` directory is properly set up.
2. Open the demo workspace in DataFlex.
3. Compile and run the demo application to see the library in action.

## DLLs
The programs folder contains 7 64 bit DLL files. At this moment there is no plan to make 32 bit DLLs.
The archive.dll file is the main file, the others are used when needed.
These files, when you use the library in your own environment, need to be present as well in your programs folder. The files are plain DLLs, it is not COM, no regsvr32 can and should be used.

## Requirements

- DataFlex development environment
- The library from the `Library` directory

## Support

For any issues or questions, please refer to the documentation in the `Library` directory or contact the support team.

## Unit tests

The unit tests are in the separate `unittests` workspace at the same level as this directory. See `../unittests/README.md`.
