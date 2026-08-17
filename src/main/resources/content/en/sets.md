# Sets

The `List` interface you saw in the "Lists" lesson allowed duplicate elements and preserved insertion order. Sometimes you want the opposite: a guarantee that an element appears **only once** in the collection, and order usually doesn't matter at all -- think unique user IDs in a system, the distinct words in a piece of text, or a mathematical set. That's what Java's `Set` interface is for.

## What Is a Set?

`Set<E>` is an interface that extends `java.util.Collection` and makes one guarantee: **no element can appear more than once**. Unlike `List`, it doesn't offer index-based access (`get(index)`) -- an element can only be reached via `contains()` or by iterating. It has three main implementations: `HashSet` (hash table, no ordering guarantee, the fastest), `LinkedHashSet` (`HashSet` plus a linked list that remembers insertion order), and `TreeSet` (a red-black tree that always keeps elements sorted).

## Why Does It Exist?

Manually preventing duplicates in a `List` requires checking with `contains()` before every `add()` -- easy to forget, and slow on large lists because `List.contains()` does a linear (O(n)) scan. `Set` embeds the "is this element already here" check directly inside `add()` and does it much faster (depending on the implementation) -- it also directly signals to the reader that "duplicates don't matter here, uniqueness does."

## History

Like `List`, the `Set` interface is part of the Collections Framework that arrived in Java 1.2 (1998). `HashSet` is implemented internally using a `HashMap` (storing only the keys). `LinkedHashSet` and `TreeSet` arrived in the same initial release; `TreeSet` is built on top of `TreeMap`, a sorted structure -- just as `HashSet` is built on top of `HashMap`.

## Basic Set Operations

`Set`'s basic methods look a lot like `List`'s -- `add()`, `remove()`, `contains()`, `size()` -- but with two important differences: there's no index-based access, and `add()` silently returns `false` (rather than throwing) if you try to add an element that's already present.

{{SetBasicsExample.java}}

> ⚠️ Warning
> `HashSet`'s iteration order is **unrelated to insertion order** -- it's determined by the elements' positions in the internal hash table, and that order can vary across JDK versions or even between runs. Never rely on `HashSet`'s iteration order in code where order matters.

## LinkedHashSet: Preserving Insertion Order

While `HashSet`'s iteration order is unpredictable, sometimes you want "remove duplicates, but also keep insertion order." `LinkedHashSet` does exactly that: it preserves all of `HashSet`'s behavior while adding a thin doubly-linked list on top to remember insertion order -- at a small memory and performance cost that's negligible in most applications.

{{LinkedHashSetExample.java}}

## TreeSet: A Sorted Set

`TreeSet` always keeps its elements **sorted**, regardless of insertion order -- by natural ordering (`Comparable`) by default, or by a `Comparator` passed to the constructor. It also implements `NavigableSet`, offering ordering-specific methods like `first()`/`last()`, `higher()`/`lower()` (strictly greater/less), `ceiling()`/`floor()` (greater-or-equal/less-or-equal), and `headSet()`/`tailSet()` (the sub-set before/after a given point).

{{TreeSetExample.java}}

> 💡 Tip
> `TreeSet`'s `add()`/`contains()`/`remove()` operations are slower than `HashSet`'s (O(log n) vs. O(1)) -- if you don't actually need sorting, `HashSet` (when order doesn't matter) or `LinkedHashSet` (when insertion order matters) is a better default.

## The equals() and hashCode() Contract

`HashSet`'s "is this element already here" check relies on the elements' `hashCode()` and `equals()` methods. If a class you write doesn't override these, `Object`'s default is used -- which means "equality" collapses to just **same reference** (`==`). The result: two different objects with seemingly identical values are treated as DIFFERENT by `HashSet`.

{{HashSetEqualsHashCodeExample.java}}

> ⚠️ Warning
> If you're going to use a class in a `HashSet` (or as a `HashMap` key), you MUST override `hashCode()` whenever you override `equals()` -- the two must stay consistent (two objects for which `equals()` returns `true` must also have the same `hashCode()`). Overriding only one leads to exactly the kind of silent, hard-to-spot bugs shown in the example above.

## Set Operations: Union, Intersection, Difference

`Set` supports the mathematical set operations through three methods: `addAll()` computes the **union**, `retainAll()` computes the **intersection** (keeping only elements present in both sets), and `removeAll()` computes the **difference** (removing elements present in the other set).

{{SetOperationsExample.java}}

> ⚠️ Warning
> All three of these methods modify the set they're called on **in place** -- if you want to keep the original intact, you need to make a copy first (as in the example above) and perform the operation on the copy.

## Performance: List, HashSet, and TreeSet Compared

Let's confirm `Set`'s reason for existing (the "Why Does It Exist?" section) with a real measurement: calling `contains()` thousands of times on the same 20,000-element collection takes milliseconds on `List`, while on `HashSet`/`TreeSet` it's too fast to measure. At this scale, the difference between `HashSet` (O(1)) and `TreeSet` (O(log n)) doesn't show up either -- to actually see it, you need a much larger collection and far more repetitions, which is what the second measurement shows.

{{SetPerformanceExample.java}}

Real results: calling `contains()` 2,000 times on a 20,000-element collection takes roughly 70-90 ms on `List`, versus 0 ms (too fast to measure) on `HashSet`/`TreeSet`. Scaling up to 200,000 elements and 200,000 repetitions reveals the difference: `HashSet` takes about 9-10 ms, `TreeSet` about 15-21 ms -- both are incomparably faster than `List`, but the theoretical O(1) vs. O(log n) gap becomes genuinely measurable at scale.

## Best Practices

- **If you know a collection shouldn't have duplicates, use a `Set` from the start** -- a `List` plus a manual `contains()` check is both slower and more error-prone.
- **Prefer `HashSet` when order doesn't matter** -- it's the fastest option. Use `LinkedHashSet` when insertion order matters, and `TreeSet` when you need to iterate in sorted order.
- **Always override `equals()` and `hashCode()` together for any class you'll use in a `HashSet`/as a `HashMap` key** -- using your IDE's auto-generation feature is safer than writing them by hand.
- **Make a copy before a set operation (`addAll`/`retainAll`/`removeAll`) if you need to preserve the original** -- these methods mutate in place.

## Common Mistakes

- **Assuming `HashSet`'s iteration order matches insertion order.** This isn't guaranteed and can vary by JDK version -- use `LinkedHashSet` if order matters.
- **Putting a custom class into a `HashSet` and forgetting to override `equals()`/`hashCode()`.** The result: objects that look equal by value get added as duplicates, because the `Set` considers them different.
- **Overriding only `equals()` (or only `hashCode()`).** When the two are inconsistent, `HashSet`'s behavior becomes unpredictable.
- **Using `TreeSet` when you don't need sorting.** It's slower than `HashSet` (O(log n) vs. O(1)) -- reach for it only when you genuinely need sorted iteration.

## Summary, Cheat Sheet, and Glossary

`Set<E>` is a collection interface that doesn't allow duplicate elements. `HashSet` is the fastest but unordered, `LinkedHashSet` preserves insertion order, and `TreeSet` always keeps elements sorted (via `NavigableSet` methods). `HashSet` working correctly depends on elements having a consistent `equals()`/`hashCode()`. `addAll()`/`retainAll()`/`removeAll()` compute the union/intersection/difference respectively.

Quick reference:

```java
Set<String> hash = new HashSet<>();          // fastest, no ordering guarantee
Set<String> linked = new LinkedHashSet<>();   // preserves insertion order
Set<String> tree = new TreeSet<>();            // always sorted (natural or Comparator)
set.add(x);                                     // returns false if already present, no exception
Set<String> union = new HashSet<>(a); union.addAll(b);       // union
Set<String> intersection = new HashSet<>(a); intersection.retainAll(b); // intersection
Set<String> difference = new HashSet<>(a); difference.removeAll(b);     // difference
```

**Glossary**

**Set** — A `Collection` sub-interface that does not allow duplicate elements.

**HashSet** — The `Set` implementation backed by a hash table; the fastest (O(1)) but with no ordering guarantee.

**LinkedHashSet** — A `HashSet` variant that additionally remembers insertion order.

**TreeSet** — A `Set` implementation that always keeps elements sorted, implementing the `NavigableSet` interface.

**hashCode()/equals() contract** — The rule stating that two objects for which `equals()` returns `true` must also have equal `hashCode()`; `HashSet`/`HashMap` correctness depends on it.
