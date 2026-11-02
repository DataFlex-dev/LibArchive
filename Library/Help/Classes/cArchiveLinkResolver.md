# cArchiveLinkResolver

`Use cArchiveLinkResolver.pkg` — `Class cArchiveLinkResolver is a cObject`

Wrapper around a libarchive `struct archive_entry_linkresolver`. While entries are written to an archive, the resolver recognises files that are hard links of each other (same device and inode, link count greater than 1) and rewrites the entries according to the rules of the archive format, so that the data of a hard linked file is stored only once.

## Usage

1. `SetStrategy` with the format code of the archive that is written (`ARCHIVE_FORMAT_TAR`, `ARCHIVE_FORMAT_CPIO_SVR4_NOCRC`, ...). The resolver is created when needed (`CreateResolver`).
2. Pass every entry through `Linkify` before writing it, and write the entries it returns.
3. After the last entry call `Flush` until it returns False and write those entries too.
4. Optionally call `PartialLinks` to find files whose other links were never seen.
5. `FreeResolver` (or destroy the object) releases the resolver.

## Strategies

`SetStrategy` selects the behaviour from the format:

| Format | Behaviour of `Linkify` |
|---|---|
| tar, shar, xar, iso9660 (`ARCHIVE_FORMAT_TAR*`, `_SHAR*`, `_XAR`, `_ISO9660*`) | The first file of a link group is returned unchanged (and remembered). Later links are returned as hard link entries (`psHardlink` points to the first file, size unset, no data). |
| mtree | Like tar, but the size is kept. |
| SVR4 cpio (`ARCHIVE_FORMAT_CPIO_SVR4_NOCRC`, `_SVR4_CRC`) | Entries are deferred until the last link arrives: the first calls return no entry. The last call returns two entries: the earlier link as a hard link entry without data, and the final link in the second output (it carries the data). Deferred entries of incomplete groups come back from `Flush`. |
| zip, 7zip, ar, other cpio formats, unknown | Entries are returned unchanged. |

Entries with a link count of 1, directories and devices are always returned unchanged.

## Ownership

- `Linkify` **takes over the entry** of its input object: after the call the object is empty (`HasEntry` is False). If the input entry is *borrowed* (`pbOwnsEntry` False, for example an entry of a reader) it is cloned first and the original stays untouched.
- The entries that `Linkify`, `Flush` and `PartialLinks` return are stored in `cArchiveEntry` objects **supplied by the caller**. These objects own what they receive (`pbOwnsEntry` True) and free their previous entry. The caller creates these objects once (as normal child objects) and reuses them. Pass 0 for an output you do not need; the entry is then freed.
- Entries that the resolver keeps for later (cpio strategy) belong to the resolver until a later call returns them. `FreeResolver` frees entries still held. (libarchive 3.7.7 frees deferred entries twice when the resolver is freed; `FreeResolver` therefore takes them out and frees them itself first.)
- libarchive cannot call back into DataFlex and the resolver has no callbacks.

## Properties

| Property | Type | Access | Description |
|---|---|---|---|
| `ppResolver` | `Pointer` | read/write | The libarchive resolver (`struct archive_entry_linkresolver *`); 0 when there is none. |

## Methods

| Method | Description | libarchive function |
|---|---|---|
| `Function HasResolver Returns Boolean` | True when the object has a resolver. | |
| `Procedure CreateResolver` | Frees the current resolver and creates a new one. | `archive_entry_linkresolver_new` |
| `Procedure SetStrategy Integer eFormat` | Selects the strategy of an archive format (`ARCHIVE_FORMAT_*`); creates the resolver when there is none. | `archive_entry_linkresolver_set_strategy` |
| `Function Linkify Handle hoEntry Handle hoOutEntry Handle hoSparseEntry Returns Integer` | Passes the entry of `hoEntry` through the resolver and returns how many entries have to be written: 0, 1 or 2. The first is stored in `hoOutEntry`, the second (cpio: the last link) in `hoSparseEntry`. `hoEntry` = 0 flushes. Raises an error when there is no resolver. | `archive_entry_linkify` |
| `Function Flush Handle hoOutEntry Returns Boolean` | Retrieves one entry the resolver deferred; True while there is one. | `archive_entry_linkify` (no entry) |
| `Function PartialLinks Handle hoOutEntry Integer ByRef iLinks Returns Boolean` | Retrieves the next entry of a file whose links were not all seen; `iLinks` receives the number of links never seen. Call it repeatedly until False. | `archive_entry_partial_links` |
| `Procedure FreeResolver` | Frees the resolver and the entries it holds. Safe without a resolver. | `archive_entry_linkresolver_free` |

## Example

```
Use cArchiveEntry.pkg
Use cArchiveLinkResolver.pkg

Object oResolver is a cArchiveLinkResolver
End_Object
Object oIn is a cArchiveEntry
End_Object
Object oOut is a cArchiveEntry
End_Object
Object oLast is a cArchiveEntry
End_Object

Integer iCount iLinks
Boolean bMore

Send SetStrategy of oResolver ARCHIVE_FORMAT_CPIO_SVR4_NOCRC

// for every file: fill oIn (CreateEntry, psPathname, piDev, piIno, piNlink, piSize, ...)
Get Linkify of oResolver oIn oOut oLast to iCount
If (iCount >= 1) Begin
    // write the entry of oOut (archive_write_header, data unless it is a hard link)
End
If (iCount = 2) Begin
    // write the entry of oLast
End

// after the last file
Repeat
    Get Flush of oResolver oOut to bMore
    If bMore Begin
        // write the entry of oOut
    End
Until (not (bMore))

Send FreeResolver of oResolver
```

## Notes

- Entries must have `piDev`, `piIno` and `piNlink` set for links to be recognised; entries read from disk by [cArchiveDiskReader](cArchiveDiskReader.md) do.
- With the tar strategy the returned hard link entry has no size: write it without data.
- `PartialLinks` entries are the remembered first entries of incomplete groups (a copy of the whole entry for tar, mtree). They are owned by the object that receives them.
