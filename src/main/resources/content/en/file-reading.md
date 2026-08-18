# File Reading

File I/O is the sixth topic in the Java Basics category -- split into two topics: this one covers READING (`File Reading`), and the next one covers WRITING (`File Writing`). This split is the reverse of the "combine short, independent sub-topics into a SINGLE topic" practice used in the `functional-interfaces-streams` and `collections` categories -- here, a single subject (File I/O) turned out to be BROAD enough that it was SPLIT into two topics instead.

## What Is File I/O?

File I/O (file input/output) is a program interacting with files on disk -- reading, writing, copying, deleting. Java uses TWO different APIs together for this: the older `java.io` package (STREAM-based classes like `FileReader`, `BufferedReader`, `FileWriter`, `BufferedWriter`) and the modern `java.nio.file` package (PATH-based classes like `Path`, `Files`, which reduce most operations to single-line static methods).

## Why Does It Exist?

A program that can't read/write persistent data isn't very useful in the real world -- log files, configuration files, CSV reports, user-uploaded documents, all of it requires File I/O. `java.nio.file` (NIO.2) was designed to fix some of the older `java.io`'s annoyances (the complexity of checked-exception handling, lack of symbolic link support, difficulty accessing filesystem metadata) -- but some `java.io` classes like `BufferedReader` are still widely used, especially when line-by-line processing is needed.

## History

The `java.io` package has been part of Java since version 1.0 (1996) -- the classic stream-based model. `java.nio` (Non-blocking I/O) arrived in Java 1.4 (2002), but the actual filesystem API, `java.nio.file` (`Path`/`Files`, also known as "NIO.2"), was added in Java 7 (2011) -- offering a more readable API, real exception types (like `NoSuchFileException`), and static methods that directly support filesystem operations (copying, moving, symbolic links). Java 11 (2018) further simplified reading/writing an entire file as a single `String` with `Files.readString()`/`Files.writeString()`.

## Path and Files Basics

`Path.of(...)` creates an object that REPRESENTS a file location -- but it does NOT touch the FILESYSTEM, it's just an "address". Methods like `Files.exists()` actually check the filesystem. `Files.readAllLines(path)` reads the entire file into memory and returns a `List<String>` with each line as an element -- the simplest way to read a small-to-medium text file.

{{PathAndFilesBasicsExample.java}}

## Reading Line by Line with BufferedReader

`BufferedReader` is the classic `java.io` way -- it WRAPS a `FileReader` and BUFFERS reads internally, which is much faster than reading one character at a time. `readLine()` returns `null` exactly ONCE, when there's nothing left to read -- that's the loop's natural termination condition. `BufferedReader` holds a real file handle, so it MUST be used INSIDE try-with-resources.

{{BufferedReaderExample.java}}

> 💡 Tip
> The pattern `while ((line = reader.readLine()) != null) { ... }` combines the assignment AND the comparison in a single expression -- a common, idiomatic reading loop pattern in Java.

## Counting Lines: readAllLines() vs Files.lines()

There are two ways to find the number of lines in a file: `Files.readAllLines(path).size()` (loads the entire file into memory, fine for small files) or `Files.lines(path).count()` (LAZY -- returns a `Stream<String>` that reads without loading the ENTIRE file into memory at once, scalable for very large files).

{{FileReadingStreamAndCountExample.java}}

> ⚠️ Warning
> The `Stream<String>` returned by `Files.lines()` holds a real file handle underneath -- meaning it needs to be CLOSED (`close()`), just like a `Scanner` or `BufferedReader`. Using it WITHOUT try-with-resources (a one-liner like `Files.lines(path).count()`) leaks the file handle -- forgetting that `Stream` is `Closeable` is a common mistake.

## Searching a File for a Word

Combining `Files.readAllLines()` with the Stream API (see the "Stream Fundamentals" lesson) reduces searching a file for a keyword to a single line: FILTER the lines, keep only the ones containing the word.

{{SearchWordInFileExample.java}}

## Reading the Entire File as a String

`Files.readString()` (Java 11+) reads the ENTIRE file into a single `String` -- line separators INCLUDED. Unlike `Files.readAllLines()` (which strips line separators and returns a `List`), `readString()` is the better fit when you need the raw text itself (for example, to pass to a JSON parser or display as-is).

{{ReadFileAsStringExample.java}}

## Exception Handling: NoSuchFileException vs FileNotFoundException

In the modern `java.nio.file` API (`Files.readString()`, `Files.readAllLines()`, etc.), a missing file throws `NoSuchFileException` -- NOT the classic `java.io`'s `FileNotFoundException`. The two are UNRELATED sibling exception classes, even though both extend `IOException`. `FileNotFoundException` comes from classic `java.io` classes like `FileReader`/`FileInputStream`.

{{FileReadingExceptionHandlingExample.java}}

> ⚠️ Warning
> Writing `catch (FileNotFoundException | NoSuchFileException e)` for `Files.readString()`/`Files.readAllLines()` COMPILES, but the `FileNotFoundException` branch never actually FIRES for that call -- because `Files.*` methods never throw it, only `NoSuchFileException`. It matters to catch the CORRECT exception type based on which API (java.io or java.nio.file) you're using; when in doubt, catching the general `IOException` is always safe.

## Best Practices

- **Use `Files.readAllLines()`/`Files.readString()` for small-to-medium files** -- they offer a simple, readable, one-line API; prefer `Files.lines()` (INSIDE try-with-resources) for very large files.
- **Use every resource that holds a file handle (`BufferedReader`, `Files.lines()`, etc.) INSIDE try-with-resources** -- forgetting to close it leads to a resource leak.
- **Catch `NoSuchFileException` when using the `java.nio.file` API, NOT `FileNotFoundException`** -- catching the wrong exception type leads to a silent bug, since that branch never fires.
- **Use the `Files.readAllLines().stream().filter(...)` pattern when searching/filtering a file** -- readable, and leverages the power of the Stream API.

## Common Mistakes

- **Catching `FileNotFoundException` for `Files.readString()`/`Files.readAllLines()` and not noticing it never fires.** These APIs throw `NoSuchFileException` -- the correct exception type needs to be caught.
- **Using `Files.lines()` without try-with-resources.** The `Stream` it returns holds a real file handle underneath -- if not closed, the resource leaks.
- **Trying to read a very large file with `Files.readAllLines()` and running into an out-of-memory situation.** `Files.lines()` (lazy) should be preferred for large files.
- **Forgetting to close a `BufferedReader`.** Without try-with-resources, its underlying file handle stays open.

## Summary, Cheat Sheet, and Glossary

Java has two APIs for reading files: the classic `java.io` (`BufferedReader`+`FileReader`, for line-by-line reading) and the modern `java.nio.file` (`Path`+`Files`, reducing most operations to a single line with `readAllLines()`/`readString()`/`lines()`). `Files.lines()` is LAZY and `Closeable` -- it requires try-with-resources. For missing files, the modern API throws `NoSuchFileException`, the classic API throws `FileNotFoundException` -- these are UNRELATED classes.

Quick reference:

```java
Path path = Path.of("data.txt");                          // build a path (doesn't touch the file)
List<String> lines = Files.readAllLines(path);               // read the whole file as a List
String content = Files.readString(path);                       // read the whole file as one String

try (Stream<String> s = Files.lines(path)) {                      // LAZY, try-with-resources REQUIRED
    long count = s.count();
}

try (BufferedReader r = new BufferedReader(new FileReader(path.toFile()))) {  // classic line-by-line reading
    String line;
    while ((line = r.readLine()) != null) { ... }
}

try { Files.readString(path); }
catch (NoSuchFileException e) { ... }                             // java.nio.file -- CORRECT exception
```

**Glossary**

**Path** — An object that represents a file location without touching the filesystem (`java.nio.file.Path`).

**Files** — The `java.nio.file` package's class offering static helper methods for file operations.

**BufferedReader** — A classic `java.io` class that wraps a reading source (e.g. `FileReader`) and buffers reads.

**NoSuchFileException** — The exception the `java.nio.file` API throws for a missing file (a DIFFERENT class from the classic `FileNotFoundException`).

**Try-with-Resources** — Java syntax that guarantees a resource (like a file handle) is automatically closed at the end of a block.
