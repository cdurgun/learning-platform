# Conditional Rendering

In JSX, we briefly saw that curly braces `{ }` can only hold an
expression that produces a value, so we used a ternary instead of `if`.
This lesson covers showing different UI based on a condition
("conditional rendering") in full, together with state.

## Conditional Rendering with if

`if` can't be written directly inside JSX's `{ }` -- but you can use it
BEFORE `return`, to decide the value of a regular JavaScript variable:

{{IfConditionalExample.jsx}}

Here, `if` decides which text gets assigned to the `message` variable;
the JSX itself is still just a single `{message}` expression.

## Conditional Rendering with a Ternary (? :)

A ternary produces a value, so it can be written directly inside `{ }` --
it collapses the several lines from `IfConditionalExample` into one:

{{TernaryConditionalExample.jsx}}

When choosing between two options (this OR that), a ternary is shorter
than `if` and feels more natural inside JSX.

## Conditional Rendering with the && Operator

Sometimes you're not choosing between two options, but between "show
something" and "show nothing at all." That's what `&&` is for:

{{AndOperatorConditionalExample.jsx}}

If the left side of `&&` is truthy, the right side gets rendered; if
it's falsy (`false`, `0`, `""`, `null`, `undefined`), React renders
nothing. **A common mistake:** if the left side is a number that could
be `0`, then `0 && <p>...</p>` actually renders the text `0` on screen --
because `0` is falsy, but it's still a renderable value inside JSX. To
avoid this, explicitly convert the number to a boolean with a
comparison like `hasNewMessage > 0`.

## Conditional Components

Sometimes what changes based on a condition isn't a single piece of
text, but an entirely different component:

{{ConditionalComponentExample.jsx}}

`ConditionalComponentExample` returns either `<LoadingMessage />` or
`<WelcomeMessage />` depending on the condition -- both are meaningful,
independent components on their own. This is the "build bigger UIs out
of small components" idea from Component Composition, combined with a
condition.

## Summary and Glossary

Conditional rendering is how you show different content based on a
condition. `if` is used outside JSX (before `return`) to decide a
variable's value; a ternary is used inside JSX between two options, and
`&&` for "show it or show nothing." You can also return entirely
different components based on a condition.

**Glossary**

**Conditional Rendering** — Rendering different content (text, an
element, a component) based on a condition.

**Truthy / Falsy** — How a value behaves in a logical context like
`if`/`&&` in JavaScript; `false`, `0`, `""`, `null`, and `undefined` are
falsy, everything else is truthy.

**`&&` Operator** — A JavaScript operator that returns its right side
if the left side is truthy, and renders nothing otherwise.
