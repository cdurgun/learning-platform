# Wrapper Classes & Autoboxing

Wrapper Classes and Autoboxing is the fourth topic in the Java Basics category -- the OBJECT counterparts of primitive types like `int`, `double`, `boolean`, and the automatic conversion the compiler performs between the two for you. It looks simple, but it hides subtle behaviors like `Integer` caching (the `==` trap) and the real `NullPointerException`s thrown by unboxing `null`.

## What Is a Wrapper Class?

Every primitive type in Java has an OBJECT counterpart: `int` → `Integer`, `double` → `Double`, `boolean` → `Boolean`, `char` → `Character`, `long` → `Long`, `short` → `Short`, `byte` → `Byte`, `float` → `Float`. These are called wrapper classes because each one "wraps" a primitive value inside an OBJECT. Autoboxing is the compiler automatically converting a primitive value into its wrapper object (`Integer i = 5;`); autounboxing is the automatic conversion in the opposite direction (`int x = i;`).

## Why Does It Exist?

Primitive types CANNOT be used directly with generics -- `List<int>` doesn't compile, because Java generics only work with reference types (see the type erasure note in the "Reflection" lesson). Wrapper classes are the bridge that makes it possible to put numbers/booleans into a collection like `List<Integer>`. Also, a primitive type can NEVER be `null` (`int x = null;` doesn't compile), but a wrapper object can -- a critical difference when you need to represent an "absent value" (for example, when a database column can be NULL). Wrapper classes also carry constants like `MAX_VALUE`/`MIN_VALUE` and helper methods like `parseInt()`.

## History

Wrapper classes have existed since Java 1.0 (1996) -- but back then, converting a primitive to a wrapper (`new Integer(5)`) or vice versa (`i.intValue()`) was done entirely MANUALLY. Autoboxing/autounboxing arrived in Java 5 (2004) alongside generics and enums -- having the compiler do this conversion automatically FOR you is what made generic collections (like `List<Integer>`) practical for everyday use. `Integer` caching (-128 to 127) was also added around this time, as a memory optimization.

## Basic Usage: Autoboxing and Autounboxing

Assigning a primitive value to a wrapper variable (`Integer i = 5;`) is equivalent to the compiler calling `Integer.valueOf(5)` behind the scenes -- this is AUTOBOXING. In the other direction, using a wrapper in an arithmetic expression (`i + 1`) is equivalent to the compiler calling `i.intValue()` -- this is AUTOUNBOXING. `parseInt()` returns a PRIMITIVE, while `valueOf()` returns a WRAPPER OBJECT (from the cache when possible).

{{WrapperBasicsExample.java}}

> 💡 Tip
> A primitive can NEVER be `null`, but a wrapper object can -- this is one of the main reasons wrapper classes exist (being able to represent an "unset" or "unknown" value).

## Integer Caching: The == Trap

The JVM CACHES `Integer` objects for values from -128 to 127 (the "Integer Cache") -- for a value in that range, `Integer.valueOf()` (which autoboxing calls internally) returns the SAME cached object every time, instead of creating a new one. OUTSIDE that range, every autoboxing operation creates a NEW object -- which is why `==` sometimes (by coincidence) returns `true`, and sometimes `false`.

{{IntegerCachingExample.java}}

> ⚠️ Warning
> This is EXACTLY the same logic as the string pool `==` vs `equals()` trap in the "String" lesson -- only the trigger is different (a value range of -128..127 instead of literal vs. `new String(...)`). Same rule: NEVER use `==` when COMPARING wrapper objects, always use `equals()` (or unbox to a primitive first).

## Autoboxing's Hidden Danger: null Unboxing

Using a `null` wrapper in an arithmetic expression causes the compiler to call `.intValue()` (or similar) behind the scenes -- AUTOUNBOXING -- but since the object is `null`, this doesn't silently produce `0`, it throws a real `NullPointerException`. This trap is especially common with methods like `Map.get()` that return `null` when a key isn't found.

{{AutoboxingNullPointerExample.java}}

> ⚠️ Warning
> `Map<String, Integer>.get(key)` returns `null` if the key doesn't exist -- assigning that result directly to an `int` variable (`int x = map.get(key);`) SILENTLY performs unboxing and throws `NullPointerException` when the key isn't found. The safe pattern: keep the result as an `Integer` (wrapper) and check for `null`, or use `getOrDefault()`.

## The Performance Cost of Autoboxing

Doing `+=` on a wrapper object (like `Long`) requires THREE steps every time: unboxing, adding, and re-boxing into a NEW wrapper object -- doing `+=` on a primitive (`long`) allocates no object at all. This difference becomes a real performance cost, especially in tight loops.

{{AutoboxingPerformanceExample.java}}

Real measurement (warmed up -- both paths were run 2 million times before timing): summing 20 million numbers in a loop, the primitive `long` accumulator consistently took ~7 ms, while the boxed `Long` accumulator took ~35-39 ms (consistent across multiple runs) -- confirming the real cost of the hidden object allocation autoboxing performs on every loop iteration.

## Wrapper Classes' Utility Methods

Every numeric wrapper class offers a `parseXxx()` (text → primitive), `compare()` (comparison without unboxing), and base-conversion methods (`toBinaryString()`, `toHexString()`). `Character` carries its own family of classification helpers like `isDigit()`/`isLetter()`/`isWhitespace()`.

{{WrapperUtilityMethodsExample.java}}

> 💡 Tip
> `Integer.parseInt()` throws `NumberFormatException` when called with invalid text -- it does NOT silently return `0`. When parsing user input, this exception needs to be handled (see the parallel with `InputMismatchException` in the "Scanner" lesson).

## Wrapper Classes and Collections

Generic collections (like `List<T>`) only work with REFERENCE types -- `List<int>` doesn't compile. Wrapper classes are the bridge that makes it possible to put numbers into a `List<Integer>`: adding a primitive automatically BOXES it, and reading with an enhanced for loop (`for (int x : list)`) automatically UNBOXES it.

{{WrapperInCollectionsExample.java}}

## Best Practices

- **Always use `equals()` when comparing wrapper objects, never `==`** -- due to `Integer` caching, `==` happens to give the right answer for some values, but it isn't reliable.
- **Don't assign a result that could be `null` (like `Map.get()`) directly to a primitive variable** -- check for `null` first, or use `getOrDefault()`.
- **Use primitive types instead of wrapper types in tight loops (especially accumulators/counters)** -- avoid the hidden object allocation on every `+=`.
- **Don't forget to handle `NumberFormatException` when parsing a number from text** -- user input is never guaranteed to be valid.

## Common Mistakes

- **Comparing two `Integer` objects with `==` and getting `true` in the -128..127 range but `false` outside it.** This is inconsistent behavior caused by `Integer` caching -- `equals()` should always be used instead.
- **Using a `null` wrapper in an arithmetic expression and getting an unexpected `NullPointerException`.** Especially common when assigning a `Map.get()` result directly to a primitive variable.
- **Using a wrapper type (`Long`, `Integer`) in a tight loop and taking a performance hit.** Every `+=` silently means unboxing + boxing + a new object allocation -- primitive types should be used instead.
- **Assuming `Integer.parseInt()` returns `0` for invalid input.** It actually throws `NumberFormatException` -- this needs to be handled.

## Summary, Cheat Sheet, and Glossary

Wrapper classes are the OBJECT counterpart of each primitive type (`int` → `Integer`, etc.) -- they make it possible to use primitives in generic collections and represent `null`. Autoboxing/autounboxing is the compiler automatically performing the primitive ↔ wrapper conversion. `Integer` caching (-128..127) makes `==` comparison unreliable -- `equals()` should always be used. Unboxing a `null` wrapper throws `NullPointerException`; using wrapper types in tight loops carries a hidden performance cost.

Quick reference:

```java
Integer boxed = 5;                          // autoboxing (Integer.valueOf(5))
int unboxed = boxed + 1;                      // autounboxing (boxed.intValue())

Integer a = 100, b = 100;                       // within -128..127 -- from the cache
a == b;                                           // true (but DON'T rely on this, coincidence)
a.equals(b);                                        // true -- always use this instead

Integer nullable = null;
int x = nullable + 1;                                // NullPointerException!

int fromText = Integer.parseInt("42");                 // text -> primitive
List<Integer> list = new ArrayList<>();                  // wrappers required in generics
list.add(5);                                                // autoboxing
```

**Glossary**

**Wrapper Class** — The object counterpart of a primitive type (e.g. `Integer` for `int`).

**Autoboxing** — The compiler automatically converting a primitive value into its wrapper object.

**Autounboxing** — The compiler automatically converting a wrapper object back into its primitive value.

**Integer Cache** — The pool of shared `Integer` objects the JVM caches for values from -128 to 127.

**NullPointerException** — A runtime exception thrown when, among other cases, unboxing is attempted on a `null` wrapper.
