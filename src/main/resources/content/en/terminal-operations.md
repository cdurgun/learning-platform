# Terminal Operations

The "Stream API Fundamentals" lesson covered the three stages of a stream pipeline: source, intermediate operations, and exactly one terminal operation. That lesson focused on intermediate operations; this one covers the **terminal operations** that actually run the pipeline and produce a result.

## What Is a Terminal Operation?

A terminal operation is the final step that **consumes** a stream pipeline and produces a result -- a value, a collection, or nothing at all (`void`). As noted in "The Stream Pipeline: Source, Intermediate, Terminal", a pipeline has exactly one terminal operation; the moment it's called, every intermediate operation runs in a chain, element by element.

This lesson covers `forEach()`, `reduce()`, `count()`, `min()`/`max()`, `findFirst()`/`findAny()`, `anyMatch()`/`allMatch()`/`noneMatch()`, and `toList()`/`toArray()`, in that order. The full power of `collect()` (especially the `Collectors` class) is the next lesson's topic.

## Why Does It Exist?

Intermediate operations are lazy (Lazy Evaluation, "Stream API Fundamentals" lesson) -- on their own they produce nothing, they just add a step to the pipeline's description. When you actually need a result (a number, a list, a `boolean`), you need something to **trigger** that description: that's a terminal operation's job. Without one, a stream pipeline is just a description that never runs.

## History

Most terminal operations arrived with the Stream API in Java 8 (2014). `toList()` is an exception -- until Java 16 (2021), the only way to turn a stream into a list was `collect(Collectors.toList())`; `toList()` was added later as a convenience method to shorten this extremely common pattern.

## forEach(): Applying a Side Effect

`forEach(Consumer<T>)` runs a side effect on every element and returns `void` -- the terminal-operation counterpart of a for-each loop. Since it returns nothing, it can only **end** a pipeline, never continue one.

{{ForEachExample.java}}

## count(): The Number of Elements

`count()` returns how many elements reached the terminal operation, as a `long`. As the peek()/lazy-evaluation-related section below shows, `count()`'s behavior is more interesting than it looks.

## reduce(): Reducing Elements to a Single Value

`reduce()` combines all elements into a **single value**, by repeatedly applying a `BinaryOperator` that combines two values into one. It has three overloads, differing mainly in whether a starting value (identity) is given:

- `reduce(identity, accumulator)`: starts from `identity`, always returns a value, even for an empty stream (it just returns the identity).
- `reduce(accumulator)`: no starting value -- since an empty stream would have no value to return, this overload returns `Optional<T>` instead of `T`.
- The three-argument `reduce(identity, accumulator, combiner)` (not used in this example) merges partial results for parallel streams.

{{ReduceExample.java}}

## min() and max(): Extremes via a Comparator

`min()` and `max()` require a `Comparator` -- there's no parameterless overload, since a stream's element type isn't guaranteed to be `Comparable`. For the same reason as `reduce(accumulator)`, both return `Optional<T>`: an empty stream has neither a minimum nor a maximum.

{{CountMinMaxExample.java}}

## findFirst() and findAny(): The First or Any Match

`findFirst()` returns the **first** element by encounter order, `findAny()` returns **any** element, both as `Optional<T>`. Since this course only uses sequential streams, they behave identically here; the difference only shows up with parallel streams (`findAny()` can be faster there, since it doesn't have to wait for the first result specifically).

## anyMatch(), allMatch(), noneMatch(): Short-Circuiting Checks

These three methods ask a yes/no question about the stream using a `Predicate`, and return a plain `boolean`: `anyMatch()` asks if at least one element matches, `allMatch()` if every element matches, `noneMatch()` if no element matches.

{{FindMatchExample.java}}

## toList() and toArray(): Converting to a Simple Collection

`toList()` (Java 16) is a shorthand for `collect(Collectors.toList())` -- with one important difference: the list `toList()` returns is **unmodifiable**, while `collect(Collectors.toList())`'s is mutable. `toArray()` converts the stream into an array instead of a `List`; to produce an array of the right element type, it usually takes a constructor reference like `String[]::new` (the `Class::new` form from the "Built-in Functional Interfaces" lesson).

{{ToListToArrayExample.java}}

## Short-Circuiting and count()'s Surprising Behavior

Some terminal operations **short-circuit**: they stop the pipeline the moment the answer is clear, without processing the remaining elements. `anyMatch()` stops at the first match; `findFirst()` stops once it finds one result.

`count()` is a separate, genuinely surprising case: in some situations, the JDK can compute the count directly from the source's known size, and skip running the pipeline **at all**. When that happens, intermediate operations along the way -- even `peek()` -- are never invoked. This is explicitly documented, intentional behavior, not a bug. The example below observes this with a real `count()` call: the print statement inside `peek()` **never runs**.

{{ShortCircuitExample.java}}

## Best Practices

- **Don't build assumptions on `peek()` (from the previous lesson) or side effects.** As the `count()` example shows, the JDK may skip some intermediate operations entirely; use `forEach()` or a plain loop for side effects instead.
- **Remember that `reduce(accumulator)`/`min()`/`max()` return `Optional<T>`** -- you always need a way to handle the empty-stream case, like `orElse()`/`orElseThrow()` (Optional gets its own dedicated lesson later).
- **Use `findAny()` only when you genuinely don't care which element you get** -- `findFirst()` communicates intent more clearly and doesn't gain any extra performance on sequential streams.
- **Remember that `toList()`'s result is unmodifiable** -- if you need a mutable list, consider `collect(Collectors.toCollection(ArrayList::new))` (next lesson's topic) or wrapping the result in a new `ArrayList`.

## Common Mistakes

- **Forgetting `reduce()`'s empty-stream behavior.** `reduce(accumulator)` returns `Optional.empty()` for an empty stream; unwrapping it directly with `.get()` throws `NoSuchElementException`.
- **Unwrapping `min()`/`max()`'s result without checking.** The same risk applies to `min()`/`max()` -- both return an empty `Optional` for an empty stream.
- **Assuming `count()` always processes every element.** As shown above, that's not true; this is exactly why `count()` can unexpectedly produce no output when you're debugging with `peek()`.
- **Trying to add an element to the list `toList()` returns.** It throws `UnsupportedOperationException` -- the same immutability constraint as the lists returned by `List.of()`.

## Summary, Cheat Sheet, and Glossary

A terminal operation consumes a stream pipeline and produces a result: `forEach()` applies a side effect, `reduce()` reduces elements to a single value, `count()` returns the element count (but sometimes without running the pipeline at all), `min()`/`max()` find extremes according to a `Comparator`, `findFirst()`/`findAny()` return a match as `Optional<T>`, `anyMatch()`/`allMatch()`/`noneMatch()` answer yes/no questions with a `boolean`, and `toList()`/`toArray()` convert the result into a simple collection. Some operations like `anyMatch()` and `findFirst()` short-circuit; `count()` has a special source-size optimization.

Quick reference:

```java
stream.forEach(x -> ...)        // side effect, returns void
stream.count()                   // long, sometimes computed directly from the source
stream.reduce(id, op)             // T, always returns a value
stream.reduce(op)                   // Optional<T>
stream.min(cmp) / .max(cmp)          // Optional<T>
stream.findFirst() / .findAny()       // Optional<T>
stream.anyMatch(p) / .allMatch(p)      // boolean, short-circuits
stream.noneMatch(p)                     // boolean, short-circuits
stream.toList() / .toArray(gen)          // List<T> (unmodifiable) / T[]
```

**Glossary**

**Terminal operation** — The final step that consumes a stream pipeline and triggers it to produce a result.

**Short-circuiting** — A terminal operation stopping the pipeline as soon as the answer is clear, without processing the remaining elements.

**reduce** — A terminal operation that reduces all elements to a single value by repeatedly applying a binary combining function.

**Optional** — A wrapper that expresses the possibility of an absent value in the type system; returned by `reduce(accumulator)`, `min()`, `max()`, `findFirst()`, and `findAny()` (covered in its own dedicated lesson).

**Encounter order** — The order in which a stream's elements are processed; `findFirst()` returns the first element by this order.
