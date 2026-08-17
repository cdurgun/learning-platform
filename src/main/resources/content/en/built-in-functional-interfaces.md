# Built-in Functional Interfaces & Method References

The `java.util.function` package exists so you don't have to define a custom functional interface for every shape a lambda might need. Types like `Predicate<T>`, `Function<T,R>`, `Consumer<T>`, and `Supplier<T>` cover nearly all everyday lambda use; method references are a way to write those same types even shorter than a lambda, by pointing directly at a method that already exists.

## What Are Built-in Functional Interfaces?

In the "Interface" lesson's "Functional Interfaces and Lambdas" section and in the "Lambda Expressions" lesson, you saw how to define your own functional interface: an interface with exactly one abstract method, optionally marked with `@FunctionalInterface`. In practice, though, needs like "check a condition on a value," "transform a value," and "do something with a value" repeat so often that the JDK ships ready-made, general-purpose interfaces for them. These interfaces in the `java.util.function` package are called **built-in functional interfaces**.

This lesson isn't about writing your own interface -- it's about using the ones the JDK already gives you, in the right place.

## Why Does It Exist?

Defining a brand-new interface for every need bloats a codebase for no reason. If a method just needs "a behavior that takes a `String` and returns a `boolean`," there's no need to write a `StringChecker` interface for it -- `Predicate<String>` already expresses exactly that. Built-in functional interfaces provide:

- A **shared vocabulary**: seeing `Predicate` tells everyone "condition check," seeing `Function` tells everyone "transformation."
- **Interoperability across APIs**: `Stream.filter()` and a method you write yourself can both accept the same `Predicate<T>` type.
- **Combinator methods** (default methods like `and()`, `or()`, `andThen()`, `compose()`) that you don't have to reinvent in your own interface every time.

## History

The `java.util.function` package arrived with Java 8 (2014), alongside lambda expressions and the Stream API. The goal was to collect the common types the Stream API (and the functional style more broadly) needed into one place: `Stream.filter()` expects a `Predicate`, `Stream.map()` expects a `Function` -- without these shared types, every method would define its own interface, and the Stream API would be incompatible with third-party code.

## Predicate&lt;T&gt;: Representing a Condition

`Predicate<T>` is an interface whose single abstract method is `boolean test(T t)`: it takes a value and answers a yes/no question about it. A method reference like `String::isBlank`, or a lambda like `s -> s.length() > 5`, can both be assigned to `Predicate<String>`.

`Predicate` provides default methods -- `negate()`, `and()`, `or()` -- that combine existing predicates into new ones, so you don't have to write a fresh lambda from scratch every time.

{{PredicateExample.java}}

## Function&lt;T,R&gt;: Representing a Transformation

`Function<T, R>` is an interface whose single abstract method is `R apply(T t)`: it takes a value of type `T` and returns a value of type `R` -- the input and output types can differ. `String::length` (takes a `String`, returns an `Integer`) is a typical example.

`Function` provides `andThen()` and `compose()` default methods for chaining two of them together. `f.andThen(g)` runs `f` first, then feeds its result into `g`. `f.compose(g)` runs `g` first, then feeds its result into `f` -- `compose()` is the mirror image of `andThen()`.

{{FunctionExample.java}}

## Consumer&lt;T&gt; and Supplier&lt;T&gt;: Side Effects and Production

`Consumer<T>` is an interface whose single abstract method is `void accept(T t)`: it takes a value and performs a **side effect** with it (printing, adding to a list, writing to a file), returning nothing. `System.out::println` is the most common example.

`Supplier<T>` is an interface whose single abstract method is `T get()`: it **produces** a value with no input at all. The key property of `Supplier` is that nothing happens until `get()` is actually called -- ideal for deferring a computation that might be expensive, or might not even be needed (this is exactly why methods like `orElseGet()` expect a `Supplier`).

{{ConsumerSupplierExample.java}}

## UnaryOperator&lt;T&gt; and BinaryOperator&lt;T&gt;: Special Cases of Function/BiFunction

`UnaryOperator<T>` extends `Function<T, T>`: input and output are the **same** type. `BinaryOperator<T>` extends `BiFunction<T, T, T>`: both inputs and the output are the same type.

Technically, `Function<T, T>` or `BiFunction<T, T, T>` would compile just as well as these two types -- they exist purely for readability and to express intent: a clearer way of saying "this function transforms a value into another value of its own type." `BinaryOperator` also provides `maxBy()`/`minBy()` static factory methods that build a `BinaryOperator` from a `Comparator`.

{{UnaryBinaryOperatorExample.java}}

## Method References: A Shortcut for Lambdas

When a lambda's body does nothing but call a single method (like `s -> s.length()`), you can write the same thing more concisely by pointing directly at that method by name: `String::length`. This is called a **method reference**.

A method reference isn't an alternative to a lambda -- it's a **shortcut** that can stand in for one in certain situations. The compiler converts a method reference into a lambda by looking at its target type (which functional interface it's being assigned to) at that point in the code, exactly the same target-typing mechanism described in the "Lambda Expressions" lesson's "The Lambda-to-Functional-Interface Connection: Target Typing" section.

## Three Forms: Class::method, object::method, Class::instanceMethod

There are three forms of method reference that point at a method that already exists:

**`Class::staticMethod`** -- points at a static method; the functional interface's parameter list maps directly onto the static method's own parameter list. Example: `Integer::parseInt`.

**`object::instanceMethod`** ("bound") -- points at an instance method on a specific, already-existing object; that object is captured by the method reference, just like a lambda capturing a variable from its enclosing scope. Example: `greeting::concat` (where `greeting` is an already-existing `String` object).

**`Class::instanceMethod`** ("unbound") -- points at an instance method with no specific receiver; the functional interface's **first parameter** becomes the receiver the method is called on, and the remaining parameters become the method's own arguments. Example: when `String::startsWith` is assigned to a `BiFunction<String, String, Boolean>`, the first `String` argument becomes the object `startsWith()` is called on, and the second argument becomes the parameter passed to `startsWith()`.

{{MethodReferenceExample.java}}

## Class::new: Constructor Reference

The fourth and final method reference form is `Class::new`: it points not at a method, but at a **constructor**. Which overload gets picked (no-arg, one-arg, two-arg...) is decided by target typing, exactly like the other method reference forms.

This form works for your own types too -- a record's canonical constructor can be referenced with `Class::new` just like any other constructor.

{{ConstructorReferenceExample.java}}

## Best Practices

- **Prefer the built-in type with the more meaningful name.** Writing `UnaryOperator<T>` instead of `Function<T, T>` tells the reader your intent more clearly.
- **Use a method reference where it improves readability.** `String::length` is short and clear compared to `s -> s.length()`; but if a method reference makes the code harder to parse (for example, when it's unclear which form is being used), a plain lambda can be the better choice.
- **Reach for `Supplier` when you genuinely need lazy evaluation.** That's exactly the difference between `orElseGet(Supplier)` and `orElse(value)`: the value passed to `orElse()` is always computed, while the `Supplier` passed to `orElseGet()` is only invoked if it's actually needed.
- **Compose small functions with `andThen()`/`compose()`** rather than writing one large lambda. This makes each step independently testable and nameable.

## Common Mistakes

- **Mixing up `andThen()` and `compose()`.** `f.andThen(g)` runs `f` first; `f.compose(g)` runs `g` first. Getting the order backwards -- especially when both functions have side effects -- leads to silent, hard-to-spot bugs.
- **Confusing the bound (`object::instanceMethod`) and unbound (`Class::instanceMethod`) forms.** Both look like "a type or object followed by `::`," but one captures a specific object while the other uses the functional interface's first parameter as the receiver. Missing this distinction leads to confusing "why is there an extra/missing parameter" compile errors.
- **Forcing a method reference everywhere.** If a method reference is less readable than the lambda it replaces (for example, when it's unclear where each parameter goes), forcing the conversion makes the code worse, not better.
- **Always writing `Function`/`BiFunction` instead of `UnaryOperator`/`BinaryOperator`.** Both compile fine, but the more specific type gives the reader the "input and output are the same type" information for free.

## Summary, Cheat Sheet, and Glossary

The `java.util.function` package offers ready-made interfaces for the most common functional shapes: `Predicate<T>` represents a condition (`test`), `Function<T,R>` represents a transformation (`apply`), `Consumer<T>` represents a side effect (`accept`), and `Supplier<T>` represents lazy production (`get`). `UnaryOperator<T>` and `BinaryOperator<T>` are specialized forms of `Function`/`BiFunction` where input and output share a type. Method references (`Class::staticMethod`, `object::instanceMethod`, `Class::instanceMethod`, `Class::new`) are a shorter way to write a lambda by pointing at a method or constructor that already exists; target typing decides which form applies and which overload gets picked.

Quick reference:

```java
Predicate<T>      boolean test(T t)          // check a condition
Function<T,R>     R apply(T t)               // transform a value
Consumer<T>       void accept(T t)           // side effect with a value
Supplier<T>       T get()                    // produce a value, no input
UnaryOperator<T>  T apply(T t)                // same-type transformation
BinaryOperator<T> T apply(T t1, T t2)         // combine two same-type values

Integer::parseInt        // Class::staticMethod
greeting::concat         // object::instanceMethod (bound)
String::startsWith       // Class::instanceMethod (unbound)
ArrayList::new           // Class::new (constructor reference)
```

**Glossary**

**Built-in functional interface** — A general-purpose functional interface the JDK provides ready-made in the `java.util.function` package.

**Predicate** — A function abstraction that checks a value and returns a `boolean`.

**Method reference** — A shortcut, written with the `::` operator, that stands in for a lambda by pointing by name at a method or constructor that already exists.

**Bound method reference** — A method reference that points at an instance method on a specific, already-existing object (`object::method`).

**Unbound method reference** — A method reference with no specific object, where the first parameter is used as the receiver (`Class::method`).

**Constructor reference** — A method reference that points at a constructor (`Class::new`).
