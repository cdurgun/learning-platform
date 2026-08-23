"Introduction to Exceptions" showed what happens when nothing handles an exception -- the program terminates, loudly, with a stack trace. This lesson covers the actual mechanism for stepping in before that happens: `try`, `catch`, and `finally`.

## What Are try and catch?

A `try` block marks a section of code as "this might throw an exception -- watch it." A `catch` block, immediately following it, specifies what to do if a SPECIFIC type of exception actually occurs inside that `try` block. If no exception is thrown, every `catch` block is simply skipped, and execution continues right after them as if they weren't there.

## Why Does It Exist?

"Introduction to Exceptions" already covered why exceptions themselves exist as a language feature. `try`/`catch` answers a narrower, more practical question: once you know a specific piece of code MIGHT fail, how do you contain that failure to exactly the place you're prepared to deal with it, instead of letting it terminate the whole program? Wrapping the risky code in `try`, and the recovery logic in `catch`, keeps the "what if this fails" handling physically next to the code that might actually fail.

## History

`try`/`catch`/`finally` as keywords predate Java -- Java's designers borrowed this exact three-part shape directly from C++'s exception handling syntax (added to C++ in the late 1980s), rather than inventing a new one. `finally` itself, guaranteeing cleanup code runs regardless of outcome, is Java's own addition to that borrowed shape -- C++ has no direct equivalent, relying instead on a different pattern (RAII) to guarantee cleanup.

## The Basic try-catch Block

{{BasicTryCatchExample.java}}

> 💡 Tip
> The parameter in a `catch` block (`e` above) is a real, ordinary local variable, scoped to that `catch` block only -- you can call any method `Throwable` defines on it (see the "Introduction to Exceptions" lesson's "The Anatomy of an Exception: Throwable, Message, and Stack Trace" section), most commonly `getMessage()`.

## Multiple catch Blocks: Matching in Order

A single `try` can be followed by several `catch` blocks, each handling a DIFFERENT exception type -- Java checks them top to bottom and runs only the FIRST one that matches.

{{MultipleCatchBlocksExample.java}}

> ⚠️ Warning
> Order matters. If a `catch` block for a SUPERCLASS (like `RuntimeException`) came before a `catch` block for one of its subclasses (like `NumberFormatException`), the subclass's `catch` block would be unreachable -- the superclass one would always match first. The compiler catches this specific mistake and refuses to build (see "Exception Hierarchy" for what "superclass" means precisely here).

## Multi-Catch: Catching Several Exception Types in One Block with |

When two or more DIFFERENT exception types genuinely need the SAME handling code, writing out separate, duplicate `catch` blocks (as in `MultipleCatchBlocksExample`) repeats yourself for no reason. Multi-catch, added in Java 7, lets one `catch` block list several types separated by `|`.

{{MultiCatchExample.java}}

## finally: The Block That Always Runs

A `finally` block, placed after the last `catch` (or directly after `try`, with no `catch` at all), runs in every case -- whether the `try` block succeeded, an exception was caught, or an exception propagated past every `catch` block uncaught.

{{FinallyAlwaysRunsExample.java}}

> 💡 Tip
> `finally` is what a resource-cleanup pattern like closing a file or a database connection is built on -- `try`-with-resources (covered where it's actually used, in the "File Reading" lesson) is really `finally`-based cleanup that the compiler writes for you automatically, not a fundamentally different mechanism.

## finally and return: A Subtle Interaction

`finally` running unconditionally has one genuinely surprising consequence: if `finally` ITSELF contains a `return` (or a `throw`), it silently overrides whatever the `try` or `catch` block was about to return, discarding it completely -- including a genuinely uncaught exception that was already propagating.

{{FinallyOverridingReturnExample.java}}

> ⚠️ Warning
> This isn't a bug or an edge case Java accidentally allows -- it's simply how `finally` running unconditionally interacts with `return`/`throw`. It's exactly why "Best Practices" recommends treating a `return` or `throw` inside `finally` as something to avoid, not a convenient shortcut.

## Best Practices

- **Keep `try` blocks focused on the specific code that can actually fail** -- wrapping far more code than necessary makes it harder to tell which line an exception could realistically come from.
- **Order multiple `catch` blocks from most specific to most general** -- see the warning in "Multiple catch Blocks", and see "Exception Hierarchy" for how to reason about which type is more general.
- **Prefer multi-catch over duplicating identical `catch` bodies** -- see `MultiCatchExample` -- but only when the handling logic is genuinely identical, not just similar.
- **Never put a `return` or `throw` inside a `finally` block** -- see "finally and return: A Subtle Interaction" -- use `finally` purely for cleanup that doesn't affect what gets returned or thrown.

## Common Mistakes

- **Ordering a superclass's `catch` block before a subclass's.** The compiler rejects this outright as unreachable code -- see the warning in "Multiple catch Blocks: Matching in Order".
- **Assuming `finally` doesn't run when a `try` block returns.** It still runs, between the `return` statement being evaluated and control actually leaving the method -- see `FinallyAlwaysRunsExample`.
- **Not realizing a `return` inside `finally` silently discards an in-flight exception.** No warning, no trace of the original problem -- see `FinallyOverridingReturnExample`.
- **Wrapping an entire method body in one giant `try` block "just in case."** This makes it much harder to tell, later, which specific line an exception is actually protecting against.

## Summary, Cheat Sheet, and Glossary

`try` marks code that might fail; `catch` specifies what to do for a specific exception type if it does, checked top to bottom until one matches; multi-catch (`|`) lets one `catch` block handle several unrelated types with identical handling; `finally` runs unconditionally, in every case, making it the right place for cleanup -- but never for `return` or `throw`, since that silently overrides whatever the `try`/`catch` was about to produce.

Quick reference:

```java
try {
    riskyOperation();
} catch (SpecificException e) {
    // handle the specific case
} catch (AnotherException | YetAnotherException e) {
    // multi-catch: identical handling for two unrelated types
} finally {
    // always runs -- cleanup only, never return/throw here
}
```

**Glossary**

**try** — A block marking code that might throw an exception.

**catch** — A block specifying how to handle a specific exception type thrown inside a preceding `try` block.

**Multi-Catch** — A single `catch` block, using `|`, that handles several unrelated exception types identically.

**finally** — A block that runs unconditionally after `try`/`catch`, regardless of whether an exception occurred or was caught.
