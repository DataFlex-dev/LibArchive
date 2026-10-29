# Third-party components

The DataFlex source of this package is licensed under the BSD 3-Clause license (see `LICENSE`). The package also ships the following 64 bit DLLs in `Programs`. They are not part of the DataFlex source and keep their own licenses.

| File | Component | Version | License |
|---|---|---|---|
| `archive.dll` | [libarchive](https://www.libarchive.org) | 3.7.7 | BSD 2-Clause (some files are public domain or BSD 3-Clause) |
| `zlib1.dll` | [zlib](https://zlib.net) | 1.3.1 | zlib license |
| `bz2.dll` | [bzip2](https://sourceware.org/bzip2/) | 1.0.8 | bzip2 license (BSD-style) |
| `liblzma.dll` | [XZ Utils](https://tukaani.org/xz/) | 5.6.3 | 0BSD / public domain |
| `lz4.dll` | [LZ4](https://github.com/lz4/lz4) | 1.10.0 | BSD 2-Clause (library) |
| `zstd.dll` | [Zstandard](https://github.com/facebook/zstd) | 1.5.6 | BSD 3-Clause (dual licensed BSD / GPLv2; used here under BSD) |
| `libcrypto-3-x64.dll` | [OpenSSL](https://www.openssl.org) | 3.4.0 | Apache License 2.0 |

The versions are the ones reported by `archive_version_details` and the DLL version information. Check the license texts of the upstream projects before redistributing the DLLs in your own product.
