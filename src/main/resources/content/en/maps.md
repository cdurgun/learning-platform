# Maps

In the "Sets" lesson you saw `Set`, which guarantees that each element appears only once in a collection. `Map` takes this idea a step further: it guarantees that each **key** appears only once, but maps each key to a **value**. Storing a word-to-definition relationship in a dictionary, a user ID to a user profile, or how many times a word appears in a text -- these are all natural use cases for `Map`.

## What Is a Map?

`Map<K, V>` is an interface that holds key-value pairs -- note: it does NOT extend `Collection`, it's a separate branch of the Collections Framework. Every key (`K`) is unique, but values (`V`) can repeat. It has three main implementations, very similar to `Set`'s: `HashMap` (hash table, no ordering guarantee, the fastest), `LinkedHashMap` (`HashMap` plus remembering insertion order), and `TreeMap` (always keeps keys sorted).

## Why Does It Exist?

Doing a lookup like "find the user with this ID" in a `List` requires scanning it from start to end (O(n)). `Map` offers direct access by key -- `map.get(id)` is O(1) on average for `HashMap`, returning almost instantly regardless of how large the map is. Whenever you need "find Y given X" -- an extremely common need in programming -- `Map` is the right tool.

## History

Like `List` and `Set`, the `Map` interface is part of the Collections Framework that arrived in Java 1.2 (1998) -- but it lives OUTSIDE `Collection`, in its own separate hierarchy (because it needs a two-parameter shape, `Map<K,V>`, rather than `Iterable<E>`). `HashMap` came in the same release as the modern counterpart to the old `Hashtable` class, without its synchronization overhead. Java 8 (2014) added powerful default methods to `Map` -- `getOrDefault()`, `putIfAbsent()`, `computeIfAbsent()`, `merge()` -- which we'll see later in this lesson.

## Basic Map Operations

`Map`'s basic methods are: `put(key, value)` (inserts or overwrites), `get(key)` (reads, returns `null` if the key is missing -- doesn't throw), `remove(key)`, `containsKey()`, `containsValue()`, `size()`. The most natural way to iterate a `Map` is `entrySet()` -- it gives you both the key and the value in a single step per entry.

{{MapBasicsExample.java}}

> ⚠️ Warning
> Classes used as `Map` keys must have a consistent `equals()`/`hashCode()` -- exactly the same rule described for `HashSet` in the "Sets" lesson's "The equals() and hashCode() Contract" section. If a class doesn't override these methods correctly, `HashMap` may treat two keys that look "the same by value" as DIFFERENT, unexpectedly creating two separate entries.

## LinkedHashMap: Preserving Insertion Order

While `HashMap`'s iteration order is unpredictable, `LinkedHashMap` preserves all of `HashMap`'s behavior and adds a thin linked list on top that remembers insertion order.

{{LinkedHashMapExample.java}}

> 💡 Tip
> A lesser-known use of `LinkedHashMap` is building a simple LRU (least-recently-used) cache -- when constructed with `accessOrder=true` and `removeEldestEntry()` overridden, `LinkedHashMap` starts tracking most-recently-accessed order and can automatically evict the oldest entry.

## TreeMap: A Sorted Map

`TreeMap` is `TreeSet`'s counterpart for `Map` -- it always keeps its keys sorted regardless of insertion order and implements the `NavigableMap` interface: `firstKey()`/`lastKey()`, `higherKey()`/`lowerKey()`, `ceilingKey()`/`floorKey()`, `headMap()`/`tailMap()`.

{{TreeMapExample.java}}

## Immutable Maps: Map.of(), Map.entry(), Collections.unmodifiableMap()

Just like `List`/`Set`, `Map` has immutable variants: `Map.of(...)` offers a short syntax for up to 10 pairs; for more pairs or when building entries dynamically, use `Map.ofEntries(Map.entry(...), ...)`; `Collections.unmodifiableMap()` returns a read-only VIEW of an existing map; `Map.copyOf()` creates an independent COPY.

{{ImmutableMapExample.java}}

## Modern Map API: getOrDefault(), computeIfAbsent(), merge()

These methods, added in Java 8, collapse extremely common "map patterns" into a single line. `getOrDefault()` returns a default value instead of `null` when the key is missing. `putIfAbsent()` only inserts if the key isn't already present. `merge()` is the classic way to implement a counting/accumulating pattern (like counting words) -- it uses a starting value if the key is missing, or combines it with the given function if it exists. `computeIfAbsent()` is the classic way to implement a grouping pattern (producing a `Map<K, List<V>>`) -- it creates a fresh container if the key is missing.

{{ModernMapMethodsExample.java}}

> ⚠️ Warning
> The old approach that predates `merge()`/`computeIfAbsent()` -- `if (!map.containsKey(key)) map.put(key, ...)` followed by `map.put(key, map.get(key) + 1)` -- is both longer and does TWO separate dictionary lookups (`containsKey` + `get`) for the same key. The modern methods do the job with a single lookup.

## Iteration Performance: entrySet() vs. keySet() + get()

If you need both the key and the value while iterating a `Map`, it might be tempting to iterate over `keySet()` and additionally call `get(key)` at each step -- but this performs an UNNECESSARY second lookup per element. `entrySet()` gives you the key and the value in a single step, with a single lookup.

{{MapIterationPerformanceExample.java}}

Real measurement: summing all the values in a 200,000-entry `HashMap` 50 times takes roughly 120-145 ms with `entrySet()`, versus roughly 140-170 ms with `keySet() + get()` -- `entrySet()` is consistently faster because it doesn't perform an unnecessary second lookup per element.

## Best Practices

- **Use a `Map` whenever you need fast lookup by key** -- it's almost always faster and more readable than manually scanning a `List`.
- **Iterate with `entrySet()` when you need both the key and the value**, not the `keySet()` + `get()` combination -- this avoids an unnecessary second lookup.
- **Use `merge()` for counting/accumulating patterns, and `computeIfAbsent()` for grouping patterns** -- both are shorter and less error-prone than a hand-written `containsKey()`/`get()`/`put()` sequence.
- **Always override `equals()`/`hashCode()` together for any custom class you'll use as a `Map` key** -- otherwise `HashMap`'s behavior becomes unpredictable.

## Common Mistakes

- **Forgetting that `get()` can return `null` and using the result directly.** If the key is missing, `get()` returns `null` (it doesn't throw) -- use `getOrDefault()` or check for `null`.
- **Iterating `keySet()` and additionally calling `get()` at each step.** This performs an unnecessary second lookup per element -- use `entrySet()` instead.
- **Using a class that doesn't override `equals()`/`hashCode()` as a `HashMap` key.** The result: keys that look "the same by value" are treated as different, producing unexpected duplicate entries.
- **Hand-writing the `containsKey()` + `get()` + `put()` sequence for a counting pattern.** `merge()` does the same job in one line with a single lookup.

## Summary, Cheat Sheet, and Glossary

`Map<K, V>` is an interface that maps unique keys to values (it doesn't extend `Collection`). `HashMap` is the fastest but unordered, `LinkedHashMap` preserves insertion order, and `TreeMap` always keeps keys sorted. `Map.of()`/`Map.copyOf()` create immutable maps. `getOrDefault()`/`putIfAbsent()`/`computeIfAbsent()`/`merge()` collapse common map patterns into one line. While iterating, `entrySet()` is faster than `keySet()` + `get()`.

Quick reference:

```java
Map<String, Integer> hash = new HashMap<>();          // fastest, no ordering guarantee
Map<String, Integer> linked = new LinkedHashMap<>();   // preserves insertion order
Map<String, Integer> tree = new TreeMap<>();            // always sorted by key
map.getOrDefault(key, 0);                                 // read with a default value
map.putIfAbsent(key, value);                                // insert only if absent
map.merge(key, 1, Integer::sum);                              // counting/accumulating pattern
map.computeIfAbsent(key, k -> new ArrayList<>()).add(value);    // grouping pattern
for (Map.Entry<String, Integer> e : map.entrySet()) { ... }      // the correct way to iterate
```

**Glossary**

**Map** — A separate Collections Framework interface, not extending `Collection`, that maps unique keys to values.

**HashMap** — The `Map` implementation backed by a hash table; the fastest (O(1)) but with no ordering guarantee.

**LinkedHashMap** — A `HashMap` variant that additionally remembers insertion order.

**TreeMap** — A `Map` implementation that always keeps its keys sorted, implementing the `NavigableMap` interface.

**entrySet()** — Returns all of a `Map`'s key-value pairs as `Map.Entry<K,V>` objects; the most efficient way to iterate.
