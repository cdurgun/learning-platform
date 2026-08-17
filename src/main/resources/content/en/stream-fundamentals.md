# Stream API Fundamentals & Intermediate Operations

The last two lessons covered lambda syntax and the ready-made interfaces in `java.util.function`. This lesson arrives at the reason they exist in the first place: the **Stream API**. It's the way to express operations on a collection -- "filter this, transform this, sort it like that" -- as a declarative chain, without writing a `for` loop.

## What Is a Stream?

A `Stream<T>` is a **pipeline** that processes elements from a data source (usually a `Collection`) in sequence. The critical point: a stream doesn't **store** data. It isn't a data structure like a list or a set -- it's a single-use pipe that lets you pass over the source data exactly once.

A stream pipeline has three parts: a **source** (like `list.stream()`), zero or more **intermediate operations** (like `filter()` and `map()` -- this lesson's topic), and exactly one **terminal operation** (like `toList()` and `forEach()` -- the next lesson's topic).

{{StreamCreationExample.java}}

## Why Does It Exist?

Before Java 8, filtering and transforming a collection meant a hand-written `for` loop, a temporary result list, and `if` checks inside the loop -- imperative code that spells out **how** to do it, step by step. The Stream API lets you express the same work as a declarative chain that describes **what** you want: `filter(...).map(...).toList()` tells the reader your intent directly, not the loop mechanics.

This lines up exactly with the example you shared:

```java
List<String> names = List.of("Ahmet", "Mehmet", "Ayse", "Ali");
List<String> result = names.stream()
        .filter(name -> name.startsWith("A"))
        .map(String::toUpperCase)
        .toList();
```

Here, `filter` expects a `Predicate<String>` (the `Predicate` from the "Built-in Functional Interfaces" lesson), `map` expects a `Function<String,String>` (the same lesson's `Function`), and `name -> name.startsWith("A")` and `String::toUpperCase` are a lambda and a method reference respectively (the "Lambda Expressions" and "Built-in Functional Interfaces" lessons). This chain is exactly where the last three lessons -- the functional interface foundation from "Interface", "Lambda Expressions", "Built-in Functional Interfaces" -- come together.

## History

The Stream API arrived alongside the `java.util.function` package in Java 8 (2014). The two are tightly coupled: Stream API methods like `filter()`, `map()`, and `reduce()` expect parameters of exactly the types in `java.util.function` (`Predicate`, `Function`, `BinaryOperator`). Without the Stream API, most of these interfaces wouldn't be used nearly as often; without these interfaces, the Stream API's methods couldn't be defined in a type-safe way.

## From a Collection to a Stream: stream() and of()

The most common source is any `Collection`'s (`List`, `Set`, ...) `stream()` method. Beyond that, `Stream.of(...)` builds a stream from literal values, `Arrays.stream(array)` from an array, and `Stream.iterate(...)` from a generation rule -- since `iterate()` has no natural end, it's usually bounded with `limit()`.

## The Stream Pipeline: Source, Intermediate, Terminal

A stream pipeline has three stages: the **source** determines where data comes from, the **intermediate operations** (this lesson's topic -- `filter`, `map`, `flatMap`, `distinct`, `sorted`, `peek`, `limit`, `skip`) transform the data step by step, and exactly one **terminal operation** (next lesson) triggers the pipeline and produces a result. Every intermediate operation returns a `Stream` -- that's what makes method chaining possible.

## filter(): Filtering

`filter(Predicate<T>)` keeps only the elements matching the given condition; the stream can get **shorter**, but element type doesn't change. `Predicate` was covered in detail in the "Built-in Functional Interfaces" lesson -- here it's used directly.

## map() and flatMap(): Transforming and Flattening

`map(Function<T,R>)` transforms each element into exactly one other value; the stream's **length doesn't change**, but element type/value can.

`flatMap()` solves a trap `map()` falls into: if the mapping function itself returns a `Stream`/collection, `map()` produces a "stream of streams" -- an awkward, nested structure. `flatMap()` turns each element into a stream and **merges those streams into a single flat stream**. Typical use: flattening a "list of lists" into a single list, or splitting each sentence into words and collecting all of them into one flat list of words.

{{FilterMapExample.java}}

{{FlatMapExample.java}}

## distinct(), sorted(), peek()

`distinct()` removes duplicate elements based on `equals()`. `sorted()` orders elements either by natural ordering (`Comparable`) or by a given `Comparator`. `peek()` runs a `Consumer` on each element **without changing** the stream -- it exists purely to observe, most often for debugging; relying on `peek()` for a side effect in production code isn't recommended (see Common Mistakes).

{{DistinctSortedPeekExample.java}}

## limit() and skip()

`limit(n)` keeps at most the first `n` elements and then stops the pipeline early. `skip(n)` discards the first `n` elements and keeps the rest. Together, they're the building blocks of pagination: `skip((page - 1) * pageSize).limit(pageSize)`.

{{LimitSkipExample.java}}

## Lazy Evaluation: When Do Intermediate Operations Actually Run?

Intermediate operations are **lazy**: calling `filter()` or `map()` doesn't run anything yet -- it just adds a step to the pipeline's description. Real work only starts once a **terminal operation** is called -- and even then, it proceeds element by element, in a single pass (each element flows through every intermediate operation in turn before the next element starts).

A stream is also **single-use**: once a terminal operation runs, the stream is closed, and trying to reuse the same stream reference throws `IllegalStateException`.

{{LazyEvaluationExample.java}}

## Best Practices

- **Keep the chain small and readable.** Putting one operation per line (`filter` on its own line, `map` on its own line) makes a chain easy to scan.
- **Apply `filter()` as early as possible.** Placing a cheap `filter()` before an expensive `map()` means `map()` runs on fewer elements.
- **Use `peek()` only for observation/debugging**, not as part of production logic -- the next section spells out why.
- **Use a stream once, then let it go.** Don't store a stream in a variable and try to reuse it across multiple terminal operations; instead, build a fresh stream from the source (`list.stream()`) whenever you need one.

## Common Mistakes

- **Using `peek()` to produce a side effect.** The documentation explicitly describes `peek()` as "primarily for debugging" -- JVM optimizations may skip `peek()` calls in some situations, so relying on it as a dependable side-effect mechanism is fragile.
- **Confusing `map()` and `flatMap()`.** If the transformation function returns a `Stream`/`List` and you used `map()`, you're left with a useless "stream of streams" -- what you needed was `flatMap()`.
- **Trying to reuse an already-consumed stream.** Applying another operation to the same `Stream` reference after a terminal operation has run throws `IllegalStateException` -- get a fresh stream from the source whenever you need one.
- **Calling `Stream.iterate()` without `limit()`.** Failing to bound a generation rule that has no natural end causes the pipeline to run forever (or until memory runs out).

## Summary, Cheat Sheet, and Glossary

A `Stream` is a single-pass pipeline over a source that doesn't store data: a **source** (`collection.stream()`, `Stream.of()`, `Arrays.stream()`), zero or more **intermediate operations** (`filter`, `map`, `flatMap`, `distinct`, `sorted`, `peek`, `limit`, `skip` -- all lazy, all returning a `Stream`), and exactly one **terminal operation**. A stream is single-use; it can't be reused once consumed.

Quick reference:

```java
list.stream()
    .filter(x -> ...)     // filter, stream can get shorter
    .map(x -> ...)          // transform, length unchanged
    .flatMap(x -> ...)      // transform + flatten
    .distinct()               // remove duplicates
    .sorted()                  // order elements
    .peek(x -> ...)             // observe, no change
    .limit(n)                    // first n elements
    .skip(n)                      // skip first n elements
```

**Glossary**

**Stream** — A single-use pipeline that processes elements from a data source in sequence, without storing data.

**Source** — Where a stream pipeline gets its data from (`collection.stream()`, `Stream.of()`, and similar).

**Intermediate operation** — A lazily-evaluated pipeline step that takes a `Stream` and returns a `Stream` (`filter`, `map`, `flatMap`, `distinct`, `sorted`, `peek`, `limit`, `skip`).

**Terminal operation** — The step that triggers the pipeline and produces a result, consuming the stream; covered in the next lesson.

**Lazy evaluation** — Intermediate operations doing no work until a terminal operation is called.

**flatMap** — An operation that turns each element into a stream and merges those streams into a single flat stream.
