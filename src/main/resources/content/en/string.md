# String

`String` is the first topic in the Java Basics category -- probably the very first class every Java programmer runs into. It looks simple, but underneath it hides an IMMUTABLE design, a special memory optimization called the "string pool", and the difference between `==` and `equals()`, which is one of the most common traps for beginners.

## What Is String?

`String`, defined in the `java.lang` package, is a class that represents a sequence of characters. In Java, strings are NOT a primitive type like `char[]` -- they are full-fledged OBJECTS -- but the language makes it possible to use them almost like a primitive type, with syntax like `String s = "hello";`. Its most critical property: `String` objects are IMMUTABLE -- once created, their content never changes; every method that looks like it "modifies" the string (`toUpperCase()`, `substring()`, `replace()`, etc.) actually returns a NEW `String` object.

## Why Does It Exist?

Working with text -- reading user input, building a file path, printing an error message -- is a basic need of almost every program. `String` being immutable is a deliberate design decision: immutable objects are THREAD-SAFE (multiple threads can safely share the same `String`, since no one can change it), its `hashCode()` value can be computed once and cached (which is why using `String` as a `HashMap` key is common and fast), and the JVM can share identical text through a "string pool" instead of storing it as separate objects over and over (saving memory).

## History

The `String` class has been part of Java since version 1.0 (1996) -- one of the oldest, most fundamental pieces of the language. The string pool (intern table) concept has also existed from the start. Java 7 (2011) changed `substring()`'s old implementation: previously, a `substring()` call shared the ORIGINAL character array (saving memory but carrying a hidden memory-leak risk -- a small substring could keep a huge original array alive in memory); from Java 7 onward, every `substring()` creates its own independent copy. Java 9 (2017) introduced "Compact Strings", storing strings that only contain Latin-1 (single-byte) characters as a `byte[]` instead of a `char[]` internally, reducing memory usage. Java 11 (2018) added methods like `strip()`/`isBlank()`/`repeat()`, and Java 15 (2020) added text blocks (`"""`) and the `formatted()` method.

## Basic Usage and Immutability

The most common way to create a `String` is writing a LITERAL (like `"hello"`). Basic inspection methods include `length()`, `charAt()`, `substring()`, `indexOf()`, `contains()`. The critical point: calling a method like `toUpperCase()` does NOT modify the original `String` -- it returns a new `String`, and the original stays the same.

{{StringBasicsExample.java}}

> 💡 Tip
> If you don't ASSIGN a `String` method's return value to a variable, the call has no effect at all (`greeting.toUpperCase();` on its own does nothing) -- this is one of the most common beginner mistakes related to immutability.

## The String Pool and == vs equals()

Java shares string LITERALS that have the same text through a "string pool" -- two separate `"hello"` literals are actually the SAME object in memory. But a string created with `new String(...)` is ALWAYS a new, separate object, even if it has the same text as a value already in the pool. The `==` operator compares object IDENTITY (is it the same memory address), while `equals()` compares CONTENT -- confusing the two leads to mysterious bugs that "sometimes work, sometimes don't".

{{StringPoolAndEqualityExample.java}}

> ⚠️ Warning
> Comparing string content with `==` is a CLASSIC mistake -- in some cases (two literals) it happens to give the right answer, but with `new String(...)` or a string concatenated at runtime, it SILENTLY produces the wrong result. Always use `equals()` (or `equalsIgnoreCase()` for case-insensitive comparison) for content comparison.

## String Concatenation and Performance

Concatenating strings with `+` reads comfortably, but since `String` is immutable, every `+=` call creates a NEW `String` object -- `result += "x"` repeated N times in a loop means roughly O(n²) total work (all the previous content gets copied again at every step). `StringBuilder` keeps a SINGLE mutable character array, reducing that cost to amortized O(1).

{{StringConcatenationPerformanceExample.java}}

Real measurement (warmed up -- both paths were run thousands of times before timing): building a string out of 30,000 pieces, the `+` operator inside a loop consistently took tens of milliseconds (~63-80 ms, varying between runs), while `StringBuilder.append()` was too fast to measure at this scale (0 ms) -- confirming the expected O(n²)/O(n) difference with a real run.

## Building Mutable Strings with StringBuilder

`StringBuilder` is `String`'s mutable sibling -- methods like `append()`, `insert()`, `replace()`, `delete()`, `reverse()` modify the SAME object in place, they don't return a new one. If you're building a string piece by piece, especially in a loop, `StringBuilder` is the right tool; once you're done, `toString()` converts it into an immutable `String`.

{{StringBuilderExample.java}}

> 💡 Tip
> `StringBuffer` has the exact same API as `StringBuilder`, but every method is synchronized (thread-safe) -- it has existed since Java 1.0, while `StringBuilder` (Java 5) does the same job without that synchronization OVERHEAD. `StringBuilder` should be preferred except in the rare case where multiple threads genuinely share the SAME builder instance.

## Formatting: String.format() and Text Blocks

`String.format()` (or Java 15's `formatted()` instance method) provides printf-style formatting with placeholders like `%s`/`%d`/`%.2f`. Text blocks (`"""..."""`, Java 15+) let you define multi-line strings (like JSON, SQL, HTML) without the hassle of writing `\n` at the end of every line and `\"` around every quote.

{{StringFormattingExample.java}}

> ⚠️ Warning
> `String.format("%.2f", ...)` ROUNDS the decimal number, it doesn't truncate it -- in the example above, `19.999` with `%.2f` becomes `"20.00"` (standard rounding, not truncation). Also, in text blocks, whether the closing `"""` is on its own line or right after the last line of text affects whether a trailing newline (`\n`) is included -- in the example above, the two strings' lengths differ because of this (18 vs. 17).

## Searching, Splitting, and Other Helper Methods

`split()` breaks a string into pieces based on a regex delimiter, and `String.join()` does the opposite (joins pieces together with a delimiter). `replace()` replaces ALL occurrences of a substring (literal, not regex); `replaceAll()`/`replaceFirst()` use regex instead. `trim()` only strips ASCII whitespace, while `strip()` (Java 11+) is Unicode-aware and is now generally preferred.

{{StringSearchSplitExample.java}}

## Best Practices

- **Always use `equals()`/`equalsIgnoreCase()` when comparing string content, never `==`** -- `==` only compares object identity, and while it may happen to give the right answer in some cases, it isn't reliable.
- **Use `StringBuilder` if you're concatenating many strings in a loop**, not `+`/`+=` -- `+` is fine for one-off, short concatenations (which the compiler can optimize), but leads to O(n²) cost inside a loop.
- **Don't hesitate to use `String` as a `HashMap` key** -- thanks to immutability and a cached `hashCode()`, this is a safe and fast thing to do.
- **Use a text block (`"""`) for long, multi-line text (JSON, SQL, HTML)** -- it's far more readable than a single-line string full of escape characters (`\"`, `\n`).

## Common Mistakes

- **Comparing string content with `==` and sometimes getting the right answer, sometimes not.** Two string literals being `==` equal is a coincidence (thanks to the string pool), not a general rule -- `equals()` should always be used.
- **Forgetting to assign a `String` method's return value to a variable.** `str.trim();` on its own does nothing -- you need `str = str.trim();`, because `String` is immutable.
- **Accumulating a string with `+`/`+=` inside a loop.** Unnoticeable at a small scale, but leads to O(n²) cost in large loops -- `StringBuilder` should be used instead.
- **Assuming `String.format("%.2f", ...)` truncates.** It actually performs standard rounding (`19.999` → `"20.00"`), which can sometimes lead to unexpected results.

## Summary, Cheat Sheet, and Glossary

`String` is an IMMUTABLE class in Java that represents a sequence of characters -- every "modifying" method actually returns a new `String`. The JVM shares string literals through a "string pool"; because of this, `==` sometimes (misleadingly) gives the right answer, but `equals()` should always be used for content comparison. `StringBuilder` should be preferred when frequent string concatenation is needed; `String.format()`/`formatted()` can be used for formatting, and text blocks for multi-line text.

Quick reference:

```java
String a = "hello";                          // literal -- shared via the string pool
String b = new String("hello");               // always a new, separate object
a.equals(b);                                    // CONTENT comparison -- true
a == b;                                           // IDENTITY comparison -- false

StringBuilder sb = new StringBuilder();             // mutable, for concatenation in a loop
sb.append("x").append("y");

String.format("%s: %.2f", "total", 19.999);            // "total: 20.00" (rounded)

String multi = """
        multi-line
        text""";                                        // text block (Java 15+)
```

**Glossary**

**String** — An immutable class in Java that represents a sequence of characters.

**Immutable** — A design where an object's content never changes once created; every "modifying" operation returns a new object instead.

**String Pool** — A special memory area (intern table) where the JVM stores and shares string literals with the same text.

**StringBuilder** — `String`'s mutable sibling, used for building a string piece by piece.

**Text Block** — Multi-line string literal syntax delimited by `"""`, introduced in Java 15.
