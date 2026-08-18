# Arrays

`Array` is the second topic in the Java Basics category -- as fundamental as `String`, but underneath it holds the language's oldest, lowest-level data structure. Arrays are the building block used INSIDE every collection like `ArrayList`/`HashMap`; understanding them also clarifies where performance claims like O(1) access in the Collections category actually come from.

## What Is an Array?

An array is a data structure that holds a fixed number of elements of the SAME type in a CONTIGUOUS block of memory. Its size is decided at creation time and can NEVER change afterward -- this is its most fundamental difference from "dynamically sized" collections like `ArrayList`. In Java, arrays like `int[]`/`String[]` look primitive, but they are actually OBJECTS (they derive from `Object`) -- which is why `.length` is accessed as a field, and does NOT require parentheses, unlike `String.length()`.

## Why Does It Exist?

Reading/writing an element by index can be done with a direct address calculation at the hardware level, thanks to contiguous memory layout -- this makes arrays the FASTEST possible structure for O(1) index access. The O(1) `get(index)` performance claim of higher-level collections like `ArrayList` comes from exactly this: `ArrayList` wraps an array internally and copies to a new, larger array when it needs to grow. Understanding arrays directly also explains why these higher-level collections are fast or slow.

## History

Arrays have been a core part of Java since version 1.0 (1996) -- one of the oldest structures, alongside `String`. The `Arrays` utility class (with its static `sort()`/`binarySearch()`/`equals()` methods) arrived with the Collections Framework in Java 1.2 (1998). Varargs (`Type... args`, syntax that makes an array parameter convenient to use at the call site) was added in Java 5 (2004). Java 8 (2014) connected arrays directly to the Stream API with `Arrays.stream()` (see the "Stream Fundamentals" lesson).

## Basic Usage: Creation, Access, Default Values

An array can be created with `new Type[size]` or with a LITERAL (`{1, 2, 3}`). An uninitialized element of a primitive-type array (like `int[]`) defaults to a value like `0`/`false`; elements of a reference-type array (like `String[]`) default to `null`. Going out of bounds (`array[10]` when the array's size is 5) does NOT silently return something wrong -- it throws a real `ArrayIndexOutOfBoundsException`.

{{ArrayBasicsExample.java}}

> ⚠️ Warning
> Printing an array directly with `System.out.println(array)` does NOT show its contents -- it gives a "type@hashcode" string like `[I@7ea987ac`, because that's `Object.toString()`'s default behavior. Always use `Arrays.toString()` (one-dimensional) or `Arrays.deepToString()` (multi-dimensional) to see the actual content.

## Multi-Dimensional Arrays

A "2D array" in Java is really an ARRAY OF ARRAYS -- each "row" is its own independent array object. This means rows can have DIFFERENT lengths (called a "jagged array"); a rectangular grid is just a special case where all rows happen to be the same length.

{{MultiDimensionalArrayExample.java}}

> 💡 Tip
> `Arrays.toString()` is the WRONG tool for nested arrays -- it shows each row as another hashcode string like `[I@...`, without descending into the CONTENT. Use `Arrays.deepToString()` to properly print a multi-dimensional array.

## The Arrays Utility Class

`Arrays`, similar to `Collections` (see the "Queues & Collections Utility" lesson), is a utility class offering ready-made static methods that work on arrays: `sort()` (sorts in place), `binarySearch()` (O(log n) search on a SORTED array), `equals()` (CONTENT comparison -- unlike `==`), `fill()` (sets every element to the same value), and `copyOf()`/`copyOfRange()` (copy into a new array).

{{ArraysUtilityExample.java}}

> ⚠️ Warning
> Comparing two arrays with `==` compares REFERENCE (is it the same memory address), not CONTENT -- exactly the same trap as `==` vs `equals()` on `String` (see the "String" lesson). Use `Arrays.equals()` to check whether two arrays hold the same elements.

## Array Covariance: A Trap the Compiler Misses

Java arrays are COVARIANT: since `Integer` extends `Number`, an `Integer[]` can be assigned to a `Number[]` variable. But this opens a trap door: the compiler allows WRITING a `Double` through that `Number[]` reference (since `Double` is also a `Number`) -- but the array's REAL runtime type is still `Integer[]`, so this write fails not at compile time, but at RUNTIME, with an `ArrayStoreException`.

{{ArrayCovarianceExample.java}}

> 💡 Tip
> Generics (`List<T>`) DELIBERATELY avoid this trap: a `List<Integer>` CANNOT be assigned to a `List<Number>` variable at all (they're invariant) -- so the kind of mistake array covariance hides is caught at COMPILE time instead of runtime with generic collections. This is the answer to "why doesn't `List<Number> list = new ArrayList<Integer>();` compile?"

## Arrays vs Collections: Arrays.asList() and Conversions

`Arrays.asList()` does NOT copy the given array -- it wraps the original array in a FIXED-SIZE `List` VIEW. Writing through this view also changes the original array (and vice versa); since it's fixed-size, `add()`/`remove()` aren't supported (they throw `UnsupportedOperationException`), only `set()` (replacing an existing index) works. For a truly independent, resizable list, this view needs to be WRAPPED in `new ArrayList<>(...)`.

{{ArraysVsCollectionsExample.java}}

## Varargs: Using an Array with Convenient Call Syntax

Varargs (`Type... name`) is syntax that lets the CALLING side pass zero, one, or many arguments to a method -- INSIDE the method, that parameter is simply a regular array. A varargs parameter can only be the LAST parameter in a method signature.

{{VarargsExample.java}}

> 💡 Tip
> `System.out.printf()` and `String.format()` themselves use varargs (`Object... args`) -- that's how they can accept as many `%s`/`%d` placeholders as you need with a single method (see the "String" lesson).

## Best Practices

- **Always use `Arrays.toString()` (one-dimensional) or `Arrays.deepToString()` (multi-dimensional) to print an array's contents**, not `System.out.println(array)` directly -- that just gives a meaningless "type@hashcode" string.
- **Use `Arrays.equals()` to compare two arrays' contents**, not `==` -- `==` only compares reference, just like with `String`.
- **Use a collection like `ArrayList` if you need a collection whose size changes while the program runs**, not an array -- arrays can't be resized after creation.
- **Remember that `Arrays.asList()` is a VIEW, not a copy** -- if you need an independent, resizable list, wrap it with `new ArrayList<>(Arrays.asList(...))`.

## Common Mistakes

- **Printing an array directly and getting a meaningless output like `[I@7ea987ac`.** `Arrays.toString()`/`Arrays.deepToString()` should have been used instead.
- **Comparing two arrays with `==` and getting `false` even though the content is identical.** `Arrays.equals()` is needed for content comparison.
- **Calling `add()`/`remove()` on the list returned by `Arrays.asList()` and getting `UnsupportedOperationException`.** That view is fixed-size -- an actual `ArrayList` needs to be wrapped explicitly if a real one is needed.
- **Assuming array covariance (that an `Integer[]` can be assigned to a `Number[]` variable) is safe.** It carries a risk of `ArrayStoreException` that isn't caught at compile time -- generic collections don't carry this risk.

## Summary, Cheat Sheet, and Glossary

An array is a fundamental data structure that holds a fixed number of same-type elements in contiguous memory, providing O(1) index access -- it's the building block used inside higher-level collections like `ArrayList`. The `Arrays` utility class offers static methods like `sort()`/`binarySearch()`/`equals()`/`fill()`/`copyOf()`. Arrays are covariant, so some mistakes (unlike with generic collections) are only caught at runtime; `Arrays.asList()` is a fixed-size view wrapping the original array, not a copy.

Quick reference:

```java
int[] numbers = new int[5];                 // fixed size, default 0s
String[] fruits = {"apple", "banana"};         // creation via a literal
Arrays.toString(numbers);                        // to print the content correctly
Arrays.sort(numbers);                              // sort in place
Arrays.equals(a, b);                                 // CONTENT comparison (not ==)
Arrays.copyOf(numbers, 10);                            // a new, larger copy
List<String> view = Arrays.asList(fruits);                // FIXED-SIZE view, not a copy
List<String> real = new ArrayList<>(Arrays.asList(fruits)); // independent, resizable list
```

**Glossary**

**Array** — A fundamental data structure that holds a fixed number of same-type elements in a contiguous block of memory.

**Jagged Array** — A multi-dimensional array whose rows (sub-arrays) can have different lengths.

**Array Covariance** — The ability to assign a subtype array (`Integer[]`) to a supertype array variable (`Number[]`); can potentially lead to a runtime error (`ArrayStoreException`).

**Varargs** — Syntax that lets a method's caller pass zero or many arguments, which becomes a plain array inside the method (`Type... name`).

**Arrays** — A utility class offering ready-made static methods that work on arrays (`sort`, `equals`, `fill`, `copyOf`, etc.).
