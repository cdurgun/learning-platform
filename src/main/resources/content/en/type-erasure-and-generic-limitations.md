Every lesson in this series so far has focused on what generics let you DO. This closing lesson explains WHY a handful of things you might reasonably expect to work simply don't — `new T()`, `new T[10]`, a static field of type `T`, an `instanceof` check against `List<String>`. All of these trace back to a single design decision made when generics were added to Java: type erasure.

## What Is Type Erasure?

Type erasure is the way the Java compiler implements generics: type parameters and type arguments are used to check your code at COMPILE time, and then thrown away — ERASED — before the code becomes runtime bytecode. `List<String>` and `List<Integer>` are both compiled down to the exact same raw `List` bytecode; the compiler inserts casts where needed and verifies everything is consistent beforehand, but none of that type information survives into the running program.

## Why Does It Exist?

When generics were introduced in Java 5 (2004), an enormous amount of existing Java code and already-compiled `.class` files used raw types like `List`. Erasure was the design choice that let generic code interoperate with all of that pre-existing, non-generic code and bytecode without breaking it — a new `List<String>` compiles down to something a pre-Java-5 JVM (and pre-Java-5 code calling into it) could still run. The trade-off is exactly what this lesson covers: several things that feel like they should work at runtime don't, because the information they'd need was erased.

## What Happens to Generic Types at Runtime

Since the type argument doesn't survive compilation, two collections built with different type arguments are, at runtime, indistinguishable.

{{TypeErasureRuntimeInspectionExample.java}}

`strings.getClass()` and `integers.getClass()` return the exact same `Class` object — there is no runtime trace of `String` or `Integer` left anywhere to tell them apart. `instanceof List<String>` doesn't even compile, for the same reason: there's no such runtime information as "a `List` of `String`" to check against — only the raw `instanceof List<?>` is legal.

## Why `new T()` Is Not Allowed

Creating an instance requires the JVM to know a real, concrete class to call a constructor on. Because of erasure, at runtime the JVM has no idea what `T` actually is — so `new T()` has no real class to instantiate.

{{GenericMethodConstructionWorkaroundExample.java}}

The standard workaround: since only the CALLER of a generic method actually knows what `T` is at that point, have the caller supply a way to create one — here, a `Supplier<T>` (often a constructor reference like `String::new`) plays that role instead of the method trying to `new T()` itself.

## Generic Arrays: Why You Can't Create Them Directly

Unlike a `List`, a Java array remembers its element type at RUNTIME — but erasure means there's no real `T` to give an array at runtime either, so `new T[10]` doesn't compile.

{{GenericArrayWorkaroundExample.java}}

The common workaround inside a generic class: build a plain `Object[]`, then cast it to `T[]`. This produces an "unchecked" compiler warning, since the cast can't truly be verified — it's safe here only because the array is never exposed outside the class as a real `T[]`, only ever accessed through methods that hand back individual `T` values.

> ⚠️ Warning
> An `@SuppressWarnings("unchecked")` cast like the one in `SimpleStack` is a promise YOU are making to the compiler, not something the compiler has verified for you. Only use it when you can actually reason through why the underlying operation is safe, exactly as `SimpleStack` keeping its array private demonstrates.

## Static Members and Generics

A `static` field or method belongs to the CLASS itself, shared across every instance — but a class's type parameter is only known PER INSTANCE (`Container<String>` and `Container<Integer>` can coexist), so there's no single, consistent `T` a static member could refer to.

{{StaticMembersAndGenericsExample.java}}

Neither a `static T sharedDefault` field nor a `static void printDefault(T value)` method can refer to `Container`'s `T` — there is no one `Container` instance's `T` a static context could mean. What a static method CAN do, exactly as covered in "Generic Methods," is declare its own, entirely independent type parameter — `singletonList`'s `U` has nothing to do with `Container`'s `T` at all.

## Runtime Limitations in Practice

The limitations covered so far aren't just theoretical — a raw type (a generic type used with no type argument at all) can still slip past compile-time checking entirely, exactly the way pre-generics code always did.

{{UncheckedWarningHeapPollutionExample.java}}

`pollute(...)` takes a raw `List`, so the compiler applies none of the type checking the rest of this series relies on — inserting a `String` into what's really a `List<Integer>` compiles fine. The failure doesn't happen at the insertion, though; it happens later, at the read, when the compiler-inserted cast to `Integer` finally runs and throws a `ClassCastException` — far from where the actual mistake was made. This is precisely the situation "Introduction to Generics" opened this whole series with, still reachable today whenever a raw type is used.

## Best Practices

- Never use a raw type in code you write — the moment you do, you lose every compile-time guarantee this series has covered, exactly as `pollute(...)` shows.
- When a generic method genuinely needs to construct a `T`, accept a factory (like `Supplier<T>`) from the caller instead of trying to `new T()`.
- If you must build a generic array internally, keep the underlying `Object[]` completely private, and only ever expose individual `T` elements through it, never the raw array itself.
- Reach for a `static` generic method with its own type parameter when class-level state genuinely isn't needed — it sidesteps the static/generics limitation entirely.

## Common Mistakes

- Writing `new T()` or `new T[size]` and being confused by the compiler error instead of recognizing it as a direct consequence of erasure.
- Trying `instanceof List<String>` and expecting it to work, instead of the only legal form, `instanceof List<?>`.
- Declaring a `static` field or method that references a class's own type parameter, not realizing static context has no particular instance's `T` to draw on.
- Ignoring an "unchecked" compiler warning as boilerplate noise, when it's often flagging exactly the kind of erasure-related unsafety `UncheckedWarningHeapPollutionExample` demonstrates.

## Summary, Cheat Sheet, and Glossary

**Summary**

- Type erasure removes type arguments after compile-time checking, so generic type information doesn't exist at runtime.
- Erasure exists to let generic code interoperate with the pre-generics code and bytecode that existed before Java 5.
- Two collections with different type arguments share the same runtime class; only a raw `instanceof` check is legal.
- `new T()` and `new T[]` don't compile, because erasure leaves no real class for the JVM to instantiate at runtime.
- A class's static members can't reference its type parameter, since a static context has no particular instance's type argument to use.

**Cheat Sheet**

```java
// Runtime erasure
List<String> a = new ArrayList<>();
List<Integer> b = new ArrayList<>();
a.getClass() == b.getClass(); // true

// instanceof: only the raw form is legal
if (obj instanceof List<?>) { ... }

// new T() workaround: caller supplies a factory
static <T> T createDefault(Supplier<T> factory) { return factory.get(); }

// Generic array workaround (inside the class only)
@SuppressWarnings("unchecked")
T[] elements = (T[]) new Object[10];

// Static members can't use the class's T, but CAN declare their own
static <U> List<U> singletonList(U value) { ... }
```

**Glossary**

- **Type erasure**: the compiler's implementation strategy for generics -- checking type arguments at compile time, then discarding them before runtime.
- **Raw type**: a generic type used with no type argument, receiving none of generics' compile-time checking.
- **Heap pollution**: a situation where a variable of a parameterized type refers to an object that isn't actually of that parameterized type, usually via a raw type or an unchecked cast.
- **Unchecked warning**: a compiler warning marking a cast or operation the compiler can't fully verify is type-safe, due to erasure.
