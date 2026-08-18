# Scanner

`Scanner` is the third topic in the Java Basics category -- the most common way to read input from the console, parse a file, or break apart (tokenize) a piece of text you already have. It looks like a simple utility class, but it hides subtle behaviors like the `nextInt()`/`nextLine()` mix-up -- a classic trap almost every Java student falls into at least once.

## What Is Scanner?

`Scanner`, defined in the `java.util` package, is a class that splits a text source (console input, a `File`, a `String`, or any `InputStream`/`Readable`) into TOKENS and lets you read those tokens by converting them into primitive types (`int`, `double`, `boolean`, etc.) or `String`. By default, tokens are separated by WHITESPACE characters (space, tab, newline), but this behavior can be changed with a custom regex.

## Why Does It Exist?

Reading raw bytes/characters one at a time from an `InputStream` or `BufferedReader` and manually parsing them with methods like `Integer.parseInt()` is tedious and error-prone. `Scanner` reduces that parsing work to a single method call (`nextInt()`, `nextDouble()`, etc.) -- especially in simple console applications ("enter a number", "enter your name"), it's the most practical way to read user input.

## History

`Scanner` arrived with Java 5 (2004) -- part of the language's largest feature set at the time, alongside generics, enums, varargs, and autoboxing. Before that, reading console input generally meant wrapping `BufferedReader` + `InputStreamReader` and parsing manually -- `Scanner` reduced that to a much more convenient API. Internally it uses a regex-based matching engine; this gives it flexibility (defining any regex delimiter via `useDelimiter()`) but makes it slower than raw reading (see the "Scanner vs BufferedReader" section).

## Basic Usage: Reading Tokens

`Scanner` works with the same API on any text source (a `String`, `System.in`, a `File`). `next()` reads a word, `nextInt()` reads an integer, `nextDouble()` reads a decimal number -- each method CONVERTS the token it reads into the expected type. Methods like `hasNext()`/`hasNextInt()` let you check a token WITHOUT consuming it -- that's how you safely loop over an unknown number of tokens.

{{ScannerBasicsExample.java}}

## The Classic nextInt() + nextLine() Trap

`nextInt()` (or `nextDouble()`, `next()`, etc.) only consumes the number/word ITSELF -- it does NOT consume the newline character (`\n`) right after it, leaving it in the input stream. If you call `nextLine()` right afterward, that call reads up to that leftover `\n` -- meaning it returns an EMPTY string, NOT the next line you expected.

{{ScannerNextIntNextLinePitfallExample.java}}

> ⚠️ Warning
> This is a classic trap almost every Java student falls into at least once: in a flow like "read an age, then read a name", the `nextLine()` right after `nextInt()` unexpectedly returns an empty string. The fix is simple: consume the leftover newline with an extra `nextLine()` call right after `nextInt()`, BEFORE the real `nextLine()` call.

## Custom Delimiters

The default whitespace delimiter can be changed to ANY regex with `useDelimiter(regex)` -- this turns `Scanner` into a simple CSV parser or a tokenizer for custom-formatted text.

{{ScannerDelimiterExample.java}}

> 💡 Tip
> The regex you pass to `useDelimiter()` isn't limited to a single character -- in the example above, `"[^0-9]+"` (one or more non-digit characters) is used to extract only the numbers out of a messy piece of text. This gives far richer parsing power than simple single-character delimiters.

## Reading from a File

`Scanner` has a constructor that takes a `File` object directly -- which means reading a file uses the SAME API as reading a `String`/`System.in`. Since `Scanner` holds a file handle underneath, it MUST be closed once you're done -- the safest way to do that is try-with-resources.

{{ScannerFileExample.java}}

> ⚠️ Warning
> `Scanner`'s `File`-accepting constructor can throw `FileNotFoundException` (a CHECKED exception) -- meaning you MUST handle a normal, expected condition like the file path being wrong. Also, forgetting to `close()` a `Scanner` leaves its underlying file resource open -- try-with-resources guarantees this automatically.

## Scanner vs BufferedReader: Performance

`Scanner` does REGEX MATCHING internally when reading each token -- this provides a convenient API for parsing typed tokens (`nextInt()`, `nextDouble()`), but it comes at a cost in raw speed. `BufferedReader.readLine()` reads only raw lines without any parsing -- it's much faster if all you need is the text itself (no number/word parsing).

{{ScannerVsBufferedReaderPerformanceExample.java}}

Real measurement (warmed up -- both paths were run 50 times before timing): reading a 50,000-line text, `Scanner.nextLine()` consistently took ~6 ms, while `BufferedReader.readLine()` took ~1 ms -- confirming that `Scanner`'s regex-based flexibility has a real speed cost.

## Exception Handling

Calling `nextInt()` (or similar) for a token that isn't the expected type throws a REAL `InputMismatchException` -- it does NOT silently return `0` or `null`. A critical point: when this exception is thrown, that "mismatched" token is NOT consumed -- it stays in the input stream, so you can recover by reading it as a plain string with `next()`. When there are no tokens left at all, `NoSuchElementException` is thrown instead -- the safe pattern is always checking with `hasNext()`/`hasNextInt()` first (exactly like the difference between `offer()`/`poll()` and `add()`/`remove()` in the "Queues & Collections Utility" lesson).

{{ScannerExceptionHandlingExample.java}}

## Best Practices

- **If you're going to call `nextLine()` after `nextInt()`/`nextDouble()`, add an extra `nextLine()` to consume the leftover newline in between** -- this avoids the most classic `Scanner` mistake.
- **When looping over an unknown number of tokens, check with `hasNext()`/`hasNextInt()` first**, don't call `next()`/`nextInt()` directly and risk `NoSuchElementException`.
- **Always close a `Scanner` once you're done with it (`close()`)** -- use try-with-resources, especially when working with a file or stream.
- **Use `BufferedReader` if you only need raw text lines (no number/token parsing needed)** -- `Scanner`'s regex flexibility is an unnecessary performance cost unless it's actually worth its simplicity for your use case.

## Common Mistakes

- **Calling `nextLine()` right after `nextInt()` and unexpectedly getting an empty string.** `nextInt()` doesn't consume the newline that follows it -- it needs to be cleared with an extra `nextLine()`.
- **Calling `next()`/`nextInt()` without checking `hasNext()`/`hasNextInt()` first and getting `NoSuchElementException`.** Whether input has run out should always be checked first.
- **Forgetting to close a `Scanner`.** Especially with file/stream-backed `Scanner`s, this leads to a resource leak.
- **Assuming the "mismatched" token is consumed after an `InputMismatchException`.** It's actually still in the input stream -- it can be recovered by reading it with `next()`, otherwise the next call will fail on the SAME token again.

## Summary, Cheat Sheet, and Glossary

`Scanner` is a class that splits a text source (console, file, string) into tokens and lets you read them by converting them into primitive types/`String`. `nextInt()` not consuming the newline that follows it is the most classic `Scanner` trap. Custom delimiters can be defined with `useDelimiter()`; reading a file uses the same API as reading a `String`/`System.in`. `Scanner` is slower than `BufferedReader` (due to regex-based parsing), but offers a much more convenient typed-reading API.

Quick reference:

```java
Scanner scanner = new Scanner(System.in);        // reading from the console
int age = scanner.nextInt();
scanner.nextLine();                                 // CLASSIC TRAP: consume the leftover \n
String name = scanner.nextLine();

Scanner csv = new Scanner(text);                       // custom delimiter
csv.useDelimiter(",");

try (Scanner file = new Scanner(new File("data.txt"))) {  // reading from a file
    while (file.hasNextLine()) {
        String line = file.nextLine();
    }
}

if (scanner.hasNextInt()) { ... }                            // safe check
```

**Glossary**

**Scanner** — A `java.util` class that splits a text source into tokens and reads them as primitive types/`String`.

**Token** — A single readable unit (word, number, etc.) that `Scanner` splits based on a delimiter (default: whitespace).

**Delimiter** — The regex that separates tokens from each other, customizable via `useDelimiter()`.

**InputMismatchException** — The exception thrown when a typed `next...()` method is called for a token that doesn't match the expected type.

**BufferedReader** — A class that reads raw text lines (without parsing), a faster alternative to `Scanner`.
