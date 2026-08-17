# Lambda Expressions

In the "Interface" lesson's "Functional Interfaces and Lambdas" section we met lambdas
briefly: a functional interface (an interface with exactly one abstract method) being
instantiated directly with an expression, with no named class needed. This lesson is the
first topic of the Java course's new category, **Functional Interfaces & Streams** -- and
it opens up the syntax that section deliberately kept short: how parameters are written,
the two shapes a body can take, when `return` is mandatory, and how a lambda reaches
variables in its enclosing scope. This category's code examples are a bit different from
the rest of this course -- since `java.util.function`/`java.util.stream` are pure JDK
(unlike Spring Boot), no external dependency is required.

## What Is a Lambda Expression?

A lambda expression is a short, nameless function definition that can be assigned
directly to a variable or passed as an argument to a method. Functions can't exist
independently of classes in Java -- a lambda isn't really a class either, it's, as we saw
in "Functional Interfaces and Lambdas", an **instance, on the spot**, of a functional
interface with exactly one abstract method. This short `parameter -> body` syntax gives
Java the ability (many other languages already had) to **carry functions around as
data** -- you can hold a function in a variable, add it to a list, or pass it to another
method.

## Why Does It Exist?

Before lambdas, the only tool for "passing a piece of behavior as a parameter" was the
anonymous inner class -- even a single line of logic needed five or six lines of
boilerplate around it:

```java
// Before lambdas: a whole anonymous inner class skeleton for a single line
// of comparison logic
Comparator<String> byLength = new Comparator<String>() {
    @Override
    public int compare(String a, String b) {
        return a.length() - b.length();
    }
};
```

The same logic collapses to one line with a lambda:

```java
Comparator<String> byLength = (a, b) -> a.length() - b.length();
```

This isn't just "less typing" -- the code's actual **intent** (compare two strings by
length) no longer gets buried under mandatory but meaning-free repetition like
`@Override`/`public int compare(...)`. We'll see in "Anonymous Inner Classes vs. Lambdas"
that this difference isn't just visual either -- `this` behaves differently too.

## History

Lambda expressions arrived in Java with **Java 8** (2014) -- carried out under the name
"Project Lambda", one of the biggest language changes in Java's history up to that point.
Java itself had been a purely object-oriented language since 1995; the idea of "carrying
functions around as data," which had existed for a long time in functional languages
(Lisp, and later newer languages like Scala and Haskell), was relatively easy to
integrate into Java precisely because single-method interfaces like `Comparator`/
`Runnable` were already widely used -- the compiler could infer which interface a lambda
should become an instance of purely from the shape of that interface (the signature of
its one abstract method). The Stream API, which arrived in the same Java 8 release (the
later topics in this category), is the API that revealed what lambdas were really for --
the two were designed together, and can't really be thought of separately.

## Parameters: Zero, One, or Multiple

The parameter portion of lambda syntax looks different depending on how many parameters
there are:

{{LambdaSyntaxAndReturnExample.java}}

For zero parameters, parentheses are **mandatory** -- you can't write an empty lambda
without `() -> ...`. For exactly one parameter, parentheses are **optional** (both
`name -> ...` and `(name) -> ...` compile), but for two or more parameters, parentheses
become **mandatory again** -- `a, b -> ...` doesn't compile, you have to write
`(a, b) -> ...`. You almost never need to write a parameter's type (the compiler infers
it, as we'll see in "The Lambda-to-Functional-Interface Connection: Target Typing", from
the target interface's method) -- but you're free to spell it out explicitly, like
`(String name) -> ...`, if you want to.

## The Body: Expression Body vs. Block Body

As you saw in the same example, a lambda's body can take one of two shapes. An
**expression body** is a single expression -- `name -> "Hi, " + name` -- no braces, no
`return`, no semicolon; the expression's value **is** the return value directly. A
**block body** is one or more statements wrapped in `{ }` -- the moment you need more
than one line you have to switch to this shape, and the instant you're in a block body,
`return` becomes **explicit and mandatory** on every path that produces a value. This
distinction looks small, but it's a common source of mistakes -- we'll come back to it in
"Common Mistakes".

## The Lambda-to-Functional-Interface Connection: Target Typing

A lambda has no type of its own -- the compiler assigns it one by looking at the
**context** it appears in (its "target type"):

{{TargetTypingExample.java}}

The expression `(a, b) -> a.length() - b.length()` doesn't say anything on its own -- it
becomes a `Comparator<String>` when assigned to a variable of that type, and a
`BiFunction<String, String, Integer>` when assigned to that type instead; since both
interfaces' single abstract method has the exact same shape (two `String`s in, one result
out), the exact **same** lambda expression fits both. The same mechanism is at work when
we pass a lambda directly into `List.sort(...)` -- the target type comes from the
parameter's declared type, `Comparator<? super E>`. This is also the foundation of why
the ready-made types we'll see in "Built-in Functional Interfaces & Method References" --
`Predicate`, `Function`, `Consumer` -- turn out to be so useful: one ready-made interface
with a given shape can serve many completely different scenarios.

## Capturing Variables: Effectively Final

A lambda can read local variables from its enclosing scope -- but only if that variable
is **effectively final**, meaning it's never reassigned after its first assignment, even
if it's never explicitly marked `final`:

{{EffectivelyFinalExample.java}}

`prefix` is never reassigned, so the lambda can capture it without any trouble; if there
were a line `prefix = "..."` anywhere after `label` is defined, you'd get a compile
error -- and that error happens even if you write that reassignment **after** the lambda,
because the rule isn't "not reassigned after being captured," it's "never reassigned
across the variable's entire lifetime." The usual way around this, as the example shows,
is to change the **contents** an object points to rather than the reference itself --
`collected` itself is never reassigned (still effectively final), but the list it points
to can change via `add(...)`.

> 💡 Tip
> The reason for the effectively-final rule isn't thread safety (a lambda doesn't
> necessarily have to run on another thread) -- the real reason is that a lambda captures
> a variable by **copying** it. If the variable could be reassigned, the lambda's own
> copy and the real value in the enclosing scope would silently drift apart; the compiler
> prevents that up front, at compile time.

## Anonymous Inner Classes vs. Lambdas

Beyond the syntax difference we saw in "Why Does It Exist?", there's a real behavioral
difference between the two as well -- what `this` actually refers to:

{{AnonymousClassVsLambdaExample.java}}

An anonymous inner class produces a real, **separate** class (in its compiled form you'll
see a name like `AnonymousClassVsLambdaExample$1`) -- `this` inside it refers to that
anonymous class's own instance. A lambda, on the other hand, behaves as if it **doesn't**
produce a new class at all -- `this` inside it refers to the **enclosing object**, exactly
as if the lambda's body had been pasted directly into the surrounding method. That
difference is small-looking but it's the entire reason writing `this.owner` inside a
lambda reaches the enclosing class's field directly (inside an anonymous class you'd have
had to write `OuterClass.this.owner` to do the same thing).

## Best Practices

- **Keep a lambda's body short** -- a block body running more than a few lines is usually
  a sign it should be extracted into a named method (or its own class); a lambda's power
  comes from its brevity.
- **Don't write parameter types, let the compiler infer them** -- as we saw in
  "Parameters: Zero, One, or Multiple", an explicit type is almost never necessary and
  just adds noise.
- **Treat the effectively-final restriction as a design signal, not an obstacle** -- as we
  saw in "Capturing Variables: Effectively Final", a lambda needing to reassign an outer
  variable is usually a sign that logic should actually be a named method, not a lambda.
- **Prefer a lambda for a single line of logic, and an anonymous class (or a named class)
  when you need several related methods** -- as we saw in "Anonymous Inner Classes vs.
  Lambdas," functional interfaces are single-method by definition.
- **Check the `java.util.function` package before writing your own functional
  interface** (a principle we also touched on in "Interface"'s "Functional Interfaces and
  Lambdas" section) -- this category's next topic is dedicated entirely to that package.

## Common Mistakes

**1. Forgetting `return` inside a block body.** Writing something like
`{ "Hi, " + name }` out of expression-body habit doesn't compile -- as we saw in "The
Body: Expression Body vs. Block Body," the moment you open braces, `return` becomes
mandatory.

**2. Being inconsistent about parentheses on single-parameter lambdas across a
codebase.** Both compile (see "Parameters: Zero, One, or Multiple"), but picking one
convention and sticking to it within a file/team improves readability.

**3. Not understanding a compile error caused by capturing a variable that isn't
effectively final.** As we saw in "Capturing Variables: Effectively Final", the error
usually points at the line where the variable is "captured," but the real cause is that
the variable is reassigned **somewhere else** -- fixing it means checking every place
that variable is used.

**4. Assuming `this` inside a lambda behaves the way it does inside an anonymous class.**
As we saw in "Anonymous Inner Classes vs. Lambdas", `this` inside a lambda refers to the
enclosing object -- unlike an anonymous class, a lambda has no "`this`" of its own.

**5. Continuing to write a new named class every time you need a `Comparator`/
`Runnable`/etc.** As we saw in "Why Does It Exist?", a lambda exists precisely to remove
that repetition -- when you need a one-off implementation of a single-method interface,
reach for a lambda first.

## Summary, Cheat Sheet, and Glossary

In this lesson we covered lambda syntax end to end: the parameter-writing rules, the
expression-body/block-body split and when `return` is mandatory, the compiler assigning a
lambda a type from context (target typing), the effectively-final restriction and why it
exists, and how a lambda differs from an anonymous inner class in terms of `this`. Key
points:

- A lambda is, on the spot, an instance of a functional interface (exactly one abstract
  method) -- it has no type of its own
- Parentheses are mandatory for zero parameters, optional for exactly one, and mandatory
  again for more than one
- An expression body has no `return` (it's implicit); a block body requires an explicit
  `return`
- A lambda can only capture local variables that are effectively final (never reassigned)
- `this` inside a lambda refers to the enclosing object -- unlike an anonymous class, a
  lambda has no `this` of its own

Quick reference:

```java
() -> ...                    // no parameters
x -> ...                     // one parameter, no parentheses
(x) -> ...                   // one parameter, with parentheses
(x, y) -> ...                // multiple parameters, parentheses mandatory
x -> x * 2                   // expression body, implicit return
x -> { return x * 2; }       // block body, explicit return mandatory
```

**Glossary**

**Lambda expression** — A nameless, short function definition that implements a
functional interface's single abstract method.

**Functional interface** — An interface with exactly one abstract method ("Interface"
lesson).

**Expression body** — A lambda body consisting of a single expression, requiring no
`return`.

**Block body** — A lambda body wrapped in `{ }` that can contain multiple statements, and
requires an explicit `return` on every path that produces a value.

**Target type** — The functional interface type the compiler infers for a lambda from
its context (a variable's type, a parameter's type, a return type).

**Effectively final** — The state of a local variable never having been reassigned after
its first assignment; lambdas can only capture variables in this state.
