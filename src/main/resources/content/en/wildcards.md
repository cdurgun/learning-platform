"Bounded Type Parameters" restricted what a type parameter like `T` could be filled in with. Wildcards solve a related but different problem: what to do at a USE SITE — a method parameter, a field, a variable — when you want to accept a generic type without committing to exactly which type argument it was built with. This is one of the most commonly misunderstood parts of Java generics, so this lesson takes it slowly.

## What Is a Wildcard?

A wildcard, written `?`, stands in for an UNKNOWN type argument at a specific use of a generic type — `List<?>` means "a `List` of some type, I'm not saying which." Unlike a type parameter (`T`), a wildcard never gets a name and is never used to declare new generic classes or methods — it only appears where a generic type is being USED, like a parameter type.

## Why Do They Exist?

Java generics are INVARIANT: even though `Integer` IS-A `Number`, `List<Integer>` is NOT a `List<Number>` — they're treated as two completely unrelated types.

{{WildcardMotivationExample.java}}

`sumNumbers(List<Number> numbers)` only accepts a parameter that is EXACTLY `List<Number>` — a `List<Integer>`, however closely related its element type is, is rejected outright. Without some other tool, you'd need a separate overload for every possible element type just to sum a list of numbers. Wildcards exist to let a method accept a whole FAMILY of related type arguments through one single, flexible parameter type. ("Generics with Collections" looks at this same invariance rule again, specifically from the angle of collections like `List` and `Map`.)

## Unbounded Wildcard: `<?>`

`List<?>` accepts a `List` of any element type whatsoever — the right tool when a method genuinely doesn't care what the elements are, and only needs operations that work no matter what.

{{UnboundedWildcardExample.java}}

`printSize(...)` works on a `List<String>`, a `List<Integer>`, or anything else — it never needs to know the element type, since it only calls `size()` and reads elements as `Object`.

## Upper Bounded Wildcard: `<? extends T>`

`List<? extends Number>` accepts a `List` of `Number` OR any of its subtypes — `List<Integer>`, `List<Double>`, `List<Number>` itself, all qualify.

{{UpperBoundedWildcardProducerExample.java}}

`sum(...)` only ever READS from the list — every element, whatever its exact type, is guaranteed to be at least a `Number`, so `n.doubleValue()` is always safe to call. What ISN'T safe is adding to it: the compiler has no way to know the list's real element type (it could specifically be a `List<Double>`), so it refuses to let you insert anything, even an `Integer`.

## Lower Bounded Wildcard: `<? super T>`

`List<? super Integer>` accepts a `List` of `Integer` OR any of its SUPERTYPES — `List<Integer>`, `List<Number>`, `List<Object>` all qualify.

{{LowerBoundedWildcardConsumerExample.java}}

`addOneToFive(...)` only ever WRITES into the list — an `Integer` is always safe to insert, no matter which supertype of `Integer` the list actually holds. What ISN'T safe is reading a specific type back out: the compiler only guarantees the list holds SOME supertype of `Integer`, which could be as broad as `Object`, so a read can only be treated as `Object`.

## Comparing the Three: What get and add Actually Allow

Placed side by side, the pattern behind all three forms becomes concrete.

{{WildcardGetPutRestrictionsExample.java}}

`<? extends Number>` lets you `get` safely but never `add` (except `null`, which fits any type). `<? super Integer>` lets you `add` an `Integer` safely but only `get` back an `Object`. Plain `<?>` allows neither a meaningful `get` beyond `Object` nor any `add` at all. This "get vs. put" behavior is the entire reason the next section's rule works.

## PECS: Producer Extends, Consumer Super

PECS is a memorable rule of thumb for choosing which wildcard form to reach for: if a parameterized type only PRODUCES values for you (you only read from it), use `extends`; if it only CONSUMES values from you (you only write into it), use `super`. This is exactly what the previous two examples already showed — `sum(...)` only reads (`extends`), `addOneToFive(...)` only writes (`super`).

{{PecsCopyExample.java}}

`copy(...)` needs BOTH roles at once: `src` is read from (a producer, so `extends`), and `dest` is written into (a consumer, so `super`). Neither wildcard form alone could do this job — `src` couldn't be `List<? super T>` (you can't reliably read a `T` back out of it), and `dest` couldn't be `List<? extends T>` (you can't add a `T` into it).

> 💡 Tip
> If a parameter needs BOTH reading and writing of the same specific type, wildcards can't help — that parameter needs a plain, unbounded type parameter like `List<T>` instead, not a wildcard at all. Wildcards only apply when a parameter's role, as either a producer or a consumer, is clear-cut.

## Best Practices

- Apply PECS directly: `extends` when a parameter only produces (you read from it), `super` when it only consumes (you only write into it).
- Reach for `<?>` when a method genuinely doesn't touch the element type at all — don't default to it out of uncertainty about which bound to use.
- Never add a wildcard to a return type — a method returning `List<? extends Number>` forces every caller to deal with an unknown type, with none of PECS's benefit, since there's no "reading" or "writing" happening at a return type.
- When a parameter needs to be both read from and written to with the same type, don't force a wildcard onto it — use an ordinary type parameter instead.

## Common Mistakes

- Trying to `add(...)` to a `List<? extends T>` and being surprised the compiler rejects it — this is the single most common wildcard mistake, and it's PECS's `extends` rule working exactly as designed.
- Trying to read a specific type (not `Object`) back out of a `List<? super T>` — the compiler only guarantees a supertype of `T`, never anything narrower.
- Reaching for `<?>` when the method actually only reads (should be `? extends`) or only writes (should be `? super`) a specific type — this throws away information the compiler could otherwise use to catch mistakes.
- Confusing a wildcard (`?`, used only where a generic type is USED) with a type parameter (`T`, declared on a class or method) — a wildcard is never declared and never gets a name.

## Summary, Cheat Sheet, and Glossary

**Summary**

- A wildcard (`?`) stands for an unknown type argument at a use of a generic type, unlike a named type parameter.
- Generics are invariant, so `List<Integer>` is not a `List<Number>` — wildcards exist to let a parameter accept a whole family of related type arguments.
- `<?>` (unbounded) accepts any element type but allows no meaningful reads or writes.
- `<? extends T>` (upper bounded) allows safe reads as `T` but no writes (except `null`).
- `<? super T>` (lower bounded) allows safe writes of `T` but only reads as `Object`.
- PECS: use `extends` for a producer (you read), `super` for a consumer (you write).

**Cheat Sheet**

```java
// Unbounded: don't care about the element type
void printSize(List<?> list) { ... }

// Upper bounded: producer, only reads -- PECS: extends
double sum(List<? extends Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    return total;
}

// Lower bounded: consumer, only writes -- PECS: super
void addOneToFive(List<? super Integer> list) {
    for (int i = 1; i <= 5; i++) list.add(i);
}

// Both roles at once -- PECS in full
static <T> void copy(List<? extends T> src, List<? super T> dest) {
    for (T item : src) dest.add(item);
}
```

**Glossary**

- **Wildcard**: `?`, standing for an unknown type argument at a use of a generic type.
- **Unbounded wildcard**: `<?>`, accepting any type argument at all.
- **Upper bounded wildcard**: `<? extends T>`, accepting `T` or any of its subtypes; safe to read, unsafe to write.
- **Lower bounded wildcard**: `<? super T>`, accepting `T` or any of its supertypes; safe to write, unsafe to read as anything but `Object`.
- **PECS**: "Producer Extends, Consumer Super" — the rule for choosing between `extends` and `super` based on whether a parameter is read from or written to.
