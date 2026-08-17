# Primitive & Parallel Streams

This is the final topic in the **Functional Interfaces & Streams** category. It brings together two separate but related subjects: streams specialized for primitive types like `int`/`long`/`double`, and parallel streams, which spread a pipeline's work across multiple threads.

## What Is a Primitive Stream?

A `Stream<Integer>` holds each element as an `Integer` **object** -- every `int` value gets automatically wrapped (autoboxed) into an object. `IntStream` (and its counterparts `LongStream`, `DoubleStream`) are specialized stream types that skip that wrapping entirely, working directly on primitive values.

## Why Does It Exist?

Autoboxing isn't free -- wrapping every `int` into an `Integer` object means extra memory allocation and a layer of indirection. Across a stream with millions of elements, that cost becomes noticeable. `IntStream`/`LongStream`/`DoubleStream` eliminate it entirely, and also expose methods that only make sense for numbers -- `sum()`, `average()` -- which a plain `Stream<T>` doesn't have directly.

## History

Primitive stream types arrived alongside the Stream API in Java 8 (2014) -- the result of a deliberate decision by the designers to make avoiding autoboxing cost a core part of the API. There are three types: `IntStream`, `LongStream`, `DoubleStream` -- there's no separate stream type for `short`, `byte`, or `float`; those are widened to `int`/`double` when needed.

## Creating an IntStream: range(), rangeClosed(), of()

`IntStream.range(start, end)` produces a range that **excludes** the end (`[start, end)`); `IntStream.rangeClosed(start, end)` **includes** it. `IntStream.of(...)` builds a stream from literal values -- the primitive counterpart of `Stream.of(...)`.

{{IntStreamCreationExample.java}}

## Methods Specific to Primitive Streams: sum(), average(), max(), min()

`sum()` returns a plain `int`/`long`/`double` directly (`0` for an empty stream). `average()`, `min()`, and `max()` return `OptionalInt`/`OptionalLong`/`OptionalDouble` instead of `Optional<T>` -- separate, unboxed `Optional` variants for primitive types. These methods aren't directly available on a plain `Stream<Integer>`; this is exactly one of the reasons `IntStream` exists.

## Boxing and Unboxing: mapToObj() and boxed()

`mapToObj()` converts a primitive stream (like `IntStream`) into a `Stream<T>` of any object type. `boxed()` goes the same direction but is a special case: it converts an `IntStream` directly into a `Stream<Integer>` -- wrapping each primitive value into its corresponding boxed type. This comes up often when moving into an API that only works with object streams, like `collect()`/`Collectors` (the previous lesson).

## From an Object Stream to a Primitive Stream: mapToInt(), mapToLong(), mapToDouble()

The bridge in the opposite direction from `boxed()`: `mapToInt()`, `mapToLong()`, and `mapToDouble()` convert a `Stream<T>` into the corresponding primitive stream -- typically used when you want a numeric aggregate like `sum()`/`average()` from an object stream.

{{BoxingMapToIntExample.java}}

## What Is a Parallel Stream? parallelStream() and stream().parallel()

A `Collection`'s `parallelStream()` method (or calling `.parallel()` on any stream) splits the pipeline's work across multiple threads in the common `ForkJoinPool`, instead of a single thread. For an associative operation, the result is **identical** -- only the execution strategy changes. The example below directly observes both that the result stays the same and that multiple threads are genuinely used (by collecting the thread names).

{{ParallelBasicsExample.java}}

## Ordering: forEach() vs. forEachOrdered()

On a parallel stream, `forEach()` processes elements **not** by encounter order, but in whatever order each thread happens to pick them up -- there's no ordering guarantee. `forEachOrdered()` forces the result back into encounter order, at a cost: it gives up most of the speed benefit parallelism provides. The example below directly observes, on the same 10-element list, that `forEach()` genuinely breaks the order while `forEachOrdered()` preserves it.

{{ParallelOrderingExample.java}}

## A Common Pitfall: Non-Thread-Safe Shared State

Writing into a plain (non-thread-safe) structure like an `ArrayList` from inside a parallel `forEach()` creates a genuine data race. The example below demonstrates this with a 100,000-element list: writing to `ArrayList::add` in parallel can, **without throwing any exception**, silently produce fewer elements than expected -- real runs observed sizes ranging from 96,901 to the full 100,000 (some runs happened to come out correct by luck, which makes the bug even more dangerous). The correct fix is `collect(Collectors.toList())` -- it handles thread-safety internally, without leaking any shared state into your own code.

{{ParallelPitfallExample.java}}

## When Should You Use It?

Parallel streams pay off when all of these hold together: the dataset is large enough (thousands or millions of elements), the operation is CPU-intensive (real computation per element, not just a fast I/O wait), and the operation is **associative/stateless** -- the order elements are processed in, or any state shared across elements, must not affect the result.

## Why Isn't It Always Faster?

Parallelizing has a real cost: splitting the work, coordinating threads through the `ForkJoinPool`, and merging partial results all take time. For a small dataset or a cheap operation, that cost can easily outweigh the benefit.

A single-shot `nanoTime()` measurement can't show this **correctly**, though -- the JVM interprets code before its JIT compiler kicks in, so whichever path runs **first** looks unfairly slow purely from warmup cost, not from sequential-vs-parallel execution itself. The example below runs both paths thousands of times first to warm them up, and only **then** takes a real measurement -- in a typical run on this sandbox, for a small 100-element list, the sequential path took about 15ms and the parallel path about 41ms (the exact numbers vary run to run, but the direction -- sequential winning for small data/cheap operations -- was consistent).

{{ParallelOverheadExample.java}}

## Best Practices

- **Default to sequential (`stream()`), and only switch to parallel after measuring.** If the conditions in "When Should You Use It?" aren't met, `parallelStream()` usually adds complexity without a performance gain.
- **Never write into a shared, non-thread-safe structure from inside a parallel `forEach()`** -- always use a `collect()`/`Collectors` instead (demonstrated with a real example above).
- **Use `forEachOrdered()` where order matters** -- but knowing it cancels out most of the benefit of parallelism; when order is required, plain sequential `stream()` is often the simpler choice anyway.
- **Back up any real performance claim with a warmed-up, repeated measurement** -- a single-shot `nanoTime()` difference can be misleading.

## Common Mistakes

- **Adding elements to a non-thread-safe collection (like `ArrayList`) inside a parallel `forEach()`.** This creates a real race condition -- the result size can come out **silently** smaller than expected, with no exception thrown at all (genuinely observed in the example above: some runs delivered only about 96,900-99,200 of the expected 100,000 elements). The fact that the bug doesn't happen every time makes it even more dangerous -- it can slip past testing unnoticed.
- **Assuming "more threads always means faster."** As shown in "Why Isn't It Always Faster?", parallel streams are often slower for small data or cheap operations.
- **Relying on ordering in a parallel stream.** `forEach()` doesn't preserve it; use `forEachOrdered()` or plain `stream()` if order is required.
- **Using `IntStream`/`LongStream`/`DoubleStream` where it isn't needed.** With only a handful of elements, or no numeric aggregation involved, the autoboxing cost is negligible; unnecessary `mapToInt()`/`boxed()` chains just add complexity.

## Summary, Cheat Sheet, and Glossary

Primitive streams (`IntStream`, `LongStream`, `DoubleStream`) eliminate autoboxing cost and expose numeric methods like `sum()`/`average()`/`max()`/`min()` directly; `mapToInt()`/`mapToLong()`/`mapToDouble()` bridge from an object stream to a primitive stream, and `boxed()`/`mapToObj()` bridge back the other way. Parallel streams (`parallelStream()`/`.parallel()`) split a pipeline's work across multiple threads -- useful for large, CPU-intensive, associative operations, but they have a real cost and can produce silent data races when combined with non-thread-safe shared state.

Quick reference:

```java
IntStream.range(0, 5)            // 0..4, end excluded
IntStream.rangeClosed(0, 5)        // 0..5, end included
IntStream.of(1, 2, 3)                // literal values

intStream.sum() / .average() / .max() / .min()     // numeric aggregates

stream.mapToInt(fn)                      // object -> primitive stream
intStream.boxed() / .mapToObj(fn)          // primitive -> object stream

collection.parallelStream()                  // run in parallel
stream.forEach(x -> ...)                       // no ordering guarantee (parallel)
stream.forEachOrdered(x -> ...)                  // ordering guaranteed
```

**Glossary**

**Primitive stream** — A stream type specialized for a primitive type like `int`/`long`/`double`, with no autoboxing cost (`IntStream`, `LongStream`, `DoubleStream`).

**Autoboxing** — Automatically wrapping a primitive value (`int`) into its corresponding object type (`Integer`).

**Parallel stream** — A stream that splits its pipeline's work across multiple threads in the common `ForkJoinPool`.

**Race condition** — An unpredictable, often silent bug caused by multiple threads writing to the same shared state without synchronization.

**Warmup** — The repeated-execution time a JVM's JIT compiler needs before it compiles frequently-run code into machine code; an un-warmed-up measurement can be misleading.
