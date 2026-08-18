# File Writing

File Writing is the seventh topic in the Java Basics category, the WRITING half of File I/O -- a direct continuation of the "File Reading" lesson. That lesson covered the two ways to read files (`java.nio.file.Files` and the classic `java.io.BufferedReader`); here we cover WRITING to files, COPYING files, and managing directories with the same two API families.

## What Is File Writing?

Writing to a file is the mirror image of the reading APIs from the "File Reading" lesson: `Files.writeString()`/`Files.write()` (modern, `java.nio.file`) and `BufferedWriter`+`FileWriter` (classic, `java.io`, with try-with-resources). This lesson also goes beyond writing to a single file, covering file COPYING (`Files.copy()`) and directory CREATION/DELETION (`Files.createDirectories()`, `Files.walk()`).

## Why Does It Exist?

A program making its results PERSISTENT -- producing a report, keeping a log file, saving a configuration, writing a user's upload to disk -- requires File Writing. The modern `Files.writeString()`/`Files.write()` methods reduce the older `java.io` ritual of "open a stream → write → close the stream" to a SINGLE static method call; but classic classes like `BufferedWriter` are still preferred, especially when many small write operations need to be accumulated EFFICIENTLY.

## History

The SAME history from the "File Reading" lesson applies here: `java.io` (`FileWriter`/`BufferedWriter`) has existed since Java 1.0 (1996), `java.nio.file` (`Path`/`Files`) arrived in Java 7 (2011). `Files.writeString()` was added in Java 11 (2018) -- before that, writing a single `String` to a file required a conversion step, like `Files.write(path, content.getBytes())`.

## Files.writeString(): Creating and Overwriting

`Files.writeString(path, content)` is the simplest way to write -- it CREATES the file if it doesn't exist, and OVERWRITES it entirely if it does (overwriting, not accumulating). Calling it twice in a row on the same file leaves only the SECOND call's content.

{{WriteStringExample.java}}

## Appending to a File

To add to the END of existing content instead of the default overwriting behavior, `StandardOpenOption.APPEND` is passed. A critical point: `APPEND` ALONE assumes the file ALREADY EXISTS -- trying to write with only `APPEND` to a file that doesn't exist yet throws `NoSuchFileException`; if you want to both create the file AND append, `StandardOpenOption.CREATE` must be passed TOGETHER with it.

{{AppendToFileExample.java}}

> ⚠️ Warning
> Calling `Files.writeString(path, content, StandardOpenOption.APPEND)` for a file that doesn't exist yet throws `NoSuchFileException` -- `APPEND` does NOT AUTOMATICALLY include `CREATE`. Passing both together (`StandardOpenOption.CREATE, StandardOpenOption.APPEND`) works safely whether the file exists or not.

## Writing a List Line by Line

`Files.write(path, list)` takes a `List<String>` and writes each element on ITS OWN LINE -- no need to manually add line separators (`String.join("\n", list)`).

{{WriteLinesExample.java}}

## Writing with BufferedWriter

`BufferedWriter` is the writing counterpart to `BufferedReader` (see the "File Reading" lesson) -- it wraps a `FileWriter`, buffering writes internally. `write()` does NOT add a line separator BY ITSELF -- `newLine()` must be called explicitly for that (it uses the platform's correct separator: `\n` on Linux/macOS, `\r\n` on Windows).

{{BufferedWriterExample.java}}

> 💡 Tip
> Whether to call `newLine()` after the last line is YOUR decision -- in the example above, `newLine()` was NOT called after the third line, so the file ends right after `"Line 3"`, without a trailing line separator.

## File Copying and Directory Management

`Files.createDirectories()` creates a directory AND any missing parent directories along the way (like `mkdir -p`) -- it does NOT fail if the directory already exists. `Files.copy()` copies a file's content in a single call -- but by DEFAULT it throws `FileAlreadyExistsException` if the destination already exists; `StandardCopyOption.REPLACE_EXISTING` makes it overwrite instead. To DELETE an entire directory tree, you first need to WALK it (`Files.walk()`) and delete starting from the DEEPEST entries (files, then subdirectories) -- a non-empty directory can't be deleted directly.

{{CopyAndDirectoryExample.java}}

> ⚠️ Warning
> The pattern `Files.walk(dir).sorted(Comparator.reverseOrder()).forEach(Files::delete)` is the STANDARD way to delete a directory tree -- `reverseOrder()` is CRITICAL, because a directory can't be deleted before the files/subdirectories INSIDE it are deleted. Trying to delete without `Comparator.reverseOrder()` (in natural, shallow-to-deep order) throws an exception for non-empty directories.

## Writing a CSV File

Writing a structured text file (like CSV) combines string-joining basics (see the "String" lesson) with File I/O: `String.join(",", array)` builds each line, all lines are gathered in a `StringBuilder`, and the whole thing is written to disk with a SINGLE `Files.writeString()` call -- more EFFICIENT than making a separate write call for every line.

{{WriteCsvExample.java}}

## Best Practices

- **Use `Files.writeString()`/`Files.write()` for one-off, simple writes** -- short and readable; prefer `BufferedWriter` if you're accumulating many small writes.
- **When using `APPEND` and you're not sure whether the file exists, pass `StandardOpenOption.CREATE` together with it** -- `APPEND` alone throws `NoSuchFileException` if the file doesn't exist.
- **Always add `StandardCopyOption.REPLACE_EXISTING` when calling `Files.copy()` if you want the destination overwritten** -- otherwise you get an exception if the destination already exists.
- **Use the `Files.walk().sorted(Comparator.reverseOrder())` pattern when deleting a directory tree** -- trying to delete in natural order fails on non-empty directories.

## Common Mistakes

- **Using `StandardOpenOption.APPEND` on a file that doesn't exist yet and getting `NoSuchFileException`.** `CREATE` needs to be passed together with it.
- **Calling `Files.copy()` without `REPLACE_EXISTING` and getting `FileAlreadyExistsException` when the destination already exists.** This option should be added if overwriting is intended.
- **Trying to delete a directory tree in natural order (shallow-to-deep) and getting a non-empty-directory error.** Deletion should go from deep to shallow with `Comparator.reverseOrder()`.
- **Assuming `BufferedWriter.write()` automatically adds a line separator.** `write()` only writes the text -- `newLine()` must be called separately for a line break.

## Summary, Cheat Sheet, and Glossary

There are also two APIs for writing files: the modern `Files.writeString()`/`Files.write()` (one line, customizable behavior via `StandardOpenOption`) and the classic `BufferedWriter`+`FileWriter` (line-by-line writing, explicit line-break control with `newLine()`). `Files.copy()` copies files (may need `REPLACE_EXISTING`), `Files.createDirectories()` creates directories, and deleting a directory tree requires `Files.walk()` plus reverse sorting.

Quick reference:

```java
Files.writeString(path, "content");                                // create/overwrite
Files.writeString(path, "\nmore", StandardOpenOption.APPEND);         // append (file must EXIST)
Files.writeString(path, "content",
        StandardOpenOption.CREATE, StandardOpenOption.APPEND);          // create if missing + append
Files.write(path, listOfStrings);                                         // List<String> -> line by line

try (BufferedWriter w = new BufferedWriter(new FileWriter(path.toFile()))) {  // classic writing
    w.write("line");
    w.newLine();                                                                // EXPLICIT line break
}

Files.createDirectories(dirPath);                                            // directory (+ parents)
Files.copy(source, dest, StandardCopyOption.REPLACE_EXISTING);                 // copy, overwrite

Files.walk(dirPath)
    .sorted(Comparator.reverseOrder())                                          // deep to shallow
    .forEach(p -> { try { Files.delete(p); } catch (IOException e) {} });         // delete the tree
```

**Glossary**

**BufferedWriter** — A classic `java.io` class that wraps a writing destination (e.g. `FileWriter`) and buffers writes.

**StandardOpenOption** — An enum that customizes `Files.writeString()`/`Files.write()`'s behavior (overwrite, append, create) (`APPEND`, `CREATE`, etc.).

**StandardCopyOption** — An enum that customizes `Files.copy()`'s behavior (e.g. `REPLACE_EXISTING`).

**Files.walk()** — A method that walks ALL files/subdirectories in a directory tree, returning a `Stream<Path>`.

**FileAlreadyExistsException** — The exception thrown when a method like `Files.copy()` tries to write to a destination that ALREADY EXISTS without permission to overwrite.
