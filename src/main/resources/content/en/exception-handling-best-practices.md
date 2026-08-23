Six lessons in, you know the mechanics of Java exceptions cold: how they're structured, how to catch and finalize, how the hierarchy works, checked vs unchecked, `throw`/`throws`, and designing your own types. Knowing the mechanics is not the same as using them well — this closing lesson is about the habits and anti-patterns that separate code that merely compiles from code a team can actually trust in production.

## Why This Lesson Exists at All

Every mechanic covered so far is legal Java — the compiler accepts all of it. But legal isn't the same as wise: an empty `catch` block compiles fine and quietly destroys your ability to debug production failures; catching `Exception` compiles fine and silently swallows bugs alongside real failures. This lesson collects the practices experienced Java developers apply on top of the rules you already know.

## Anti-Pattern: Using Exceptions for Control Flow

Exceptions exist for EXCEPTIONAL conditions — outcomes that are not part of a method's normal, expected operation. Using `throw`/`catch` to implement ordinary control flow (like breaking out of a loop once you've found something) abuses a mechanism built for error propagation to do a job `return` or `break` already does, at real runtime cost (building a stack trace is not free) and at a real readability cost.

{{ExceptionsForControlFlowAntiPatternExample.java}}

`findFirstOver20_bad(...)` throws and catches a `FoundException` purely to exit a loop — finding a matching number is a completely ordinary outcome, not an exceptional one. `findFirstOver20_good(...)` produces the identical result with a plain `return`, no exception machinery involved at all.

> ⚠️ Warning
> If you ever find yourself writing a custom exception whose only purpose is to carry a value out of a loop or a deeply nested call, that's a strong signal you're using exceptions for control flow — restructure the code with ordinary `return` values instead.

## Anti-Pattern: Swallowing Exceptions

An empty `catch` block is one of the most damaging things you can write in Java: the failure happened, but every trace of it — the type, the message, the stack trace — disappears the instant execution reaches that empty block. Whoever debugs the resulting symptom later has nothing to go on.

{{SwallowingExceptionsAntiPatternExample.java}}

`parsePort_bad(...)` swallows `NumberFormatException` and returns `0` — a caller has no way to tell a genuinely configured port `0` apart from a parse failure that got silently discarded. `parsePort_good(...)` does one of the two honest things: if nothing useful can be done here, don't catch at all (let it propagate); if you DO catch, translate the failure into something clearer for your own caller — a technique you already know as wrapping, from "Throw and Throws."

> 💡 Tip
> If you're tempted to write an empty `catch` block "just to make the code compile" while you figure out the right handling later, at minimum print or log something inside it as a placeholder — an empty block is easy to forget about forever.

## Catching Specifically, and in the Right Order

A single `try` can have multiple `catch` blocks, and — as you saw in "Try-Catch and Finally" — Java requires them ordered from most specific to least specific. That compiler rule exists to serve a real design goal: each `catch` block should react to exactly the failure it names, not to a broad category that happens to include it.

{{CatchOrderAndSpecificityExample.java}}

`process(...)` catches `NumberFormatException` and `NullPointerException` separately, each with its own targeted response, and only falls back to a broad `catch (RuntimeException e)` for genuinely unanticipated failures — placed last, since the compiler rejects a supertype catch positioned before its subtypes. Catching `Exception` (or worse, `Throwable`) as a matter of habit, instead of as a deliberate last resort, tends to lump together failures that need completely different responses.

## Only Catch What You Can Actually Handle

Not every method that CAN catch an exception SHOULD. A `catch` block only earns its place when the method has enough context to do something meaningful with the failure — retry, fall back to a default, translate it for its own caller. If a method has no such response, catching there just to immediately do nothing useful (or to rethrow unchanged) adds code without adding value.

{{OnlyCatchWhatYouCanHandleExample.java}}

`parsePrice(...)` deliberately does NOT catch `NumberFormatException` — it has no basis for deciding whether to retry or give up, so it lets the exception propagate. `readPriceWithRetry(...)` is where the catch actually belongs, because it's the layer that knows how to react: retry a few times, then give up with a clear `IllegalStateException` for whoever called it.

## Putting It All Together: A Recap of the Series

Across this series you built up the full picture one layer at a time: "Introduction to Exceptions" covered what an exception even is and what happens when one goes uncaught; "Try-Catch and Finally" covered the mechanics of handling and cleanup; "Exception Hierarchy" covered how `Throwable`, `Error`, `Exception`, and `RuntimeException` relate and how `catch` matches by supertype; "Checked vs Unchecked Exceptions" covered the compiler-enforced contract and when to choose which; "Throw and Throws" covered creating a failure at runtime versus declaring one at compile time; "Creating and Throwing Custom Exceptions" covered designing your own types. This lesson's four practices are what turn that full toolbox into code a team can trust: don't reach for `throw`/`catch` when ordinary control flow will do, never let a `catch` block erase the evidence of what went wrong, catch specific types in the right order, and only catch where you can actually respond.

## Best Practices

- Reserve exceptions for genuinely exceptional conditions — never for expected, everyday outcomes your code can check for directly.
- Never leave a `catch` block truly empty; at an absolute minimum, note that the failure happened.
- List `catch` blocks from most specific to least specific, and treat a broad `catch (Exception e)` as a deliberate last resort, not a default habit.
- Catch only where a method has a genuine, useful response to the failure — otherwise let it propagate to a layer that does.
- When you do catch and rethrow a different type, always preserve the original as the `cause`, exactly as covered in "Throw and Throws."

## Common Mistakes

- Designing a whole custom exception (like a "found" signal) just to break out of a loop or nested call.
- Writing `catch (Exception e) {}` "temporarily" and never coming back to fix it.
- Catching a broad supertype before a narrower one is even considered, collapsing genuinely different failures into one generic response.
- Catching an exception purely to log it and rethrow the exact same thing unchanged — this adds a `try`/`catch` that does nothing a caller couldn't already do itself.

## Summary, Cheat Sheet, and Glossary

**Summary**

- Exceptions are for exceptional conditions, not for implementing ordinary control flow.
- An empty `catch` block destroys the evidence of a failure — never leave one silently empty.
- `catch` blocks should be specific and ordered from most to least specific; a broad catch is a deliberate last resort.
- Only catch where a method can genuinely act on the failure — otherwise, let it propagate.
- The full series builds one coherent toolbox: what exceptions are, handling and cleanup, the hierarchy, checked vs unchecked, throw vs throws, and designing your own types.

**Cheat Sheet**

```java
// Don't: exceptions as control flow
try {
    for (int n : numbers) {
        if (n > 20) throw new FoundException(n);
    }
} catch (FoundException e) { return e.value; }

// Do: ordinary control flow
for (int n : numbers) {
    if (n > 20) return n;
}

// Don't: swallowing
try {
    return Integer.parseInt(text);
} catch (NumberFormatException e) { /* nothing */ }

// Do: translate, don't erase
try {
    return Integer.parseInt(text);
} catch (NumberFormatException e) {
    throw new IllegalArgumentException("invalid: " + text, e);
}

// Do: specific before broad
catch (NumberFormatException e) { ... }
catch (NullPointerException e) { ... }
catch (RuntimeException e) { ... } // last resort
```

**Glossary**

- **Exceptions as control flow**: an anti-pattern that uses `throw`/`catch` to implement ordinary, expected logic instead of error propagation.
- **Swallowing an exception**: catching it and discarding all trace of it, usually via an empty `catch` block.
- **Catch specificity**: ordering `catch` blocks from the narrowest, most targeted type to the broadest.
- **Handleable**: a failure a given method has enough context to actually react to (retry, fall back, translate) rather than just pass through.
