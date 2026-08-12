# JSX

In Creating a React Application, we saw how to set up a React project.
Now we get into actual React code. The syntax you use to write UI in
React is called **JSX** -- this lesson covers what JSX is and its basic
rules, with examples kept as simple as possible.

## What Is JSX?

JSX is a syntax that looks a lot like HTML, but is actually an extension
of JavaScript. Most React components use JSX to describe what the UI
should look like:

{{JsxHelloWorldExample.jsx}}

This code looks like HTML, but it's really assigning a value to a
JavaScript variable (`element`). The browser can't understand JSX
directly -- a compiler (Babel) that runs automatically inside a Vite
project turns this code into plain JavaScript function calls the browser
understands. You never need to do this step by hand.

## HTML vs. JSX

JSX looks like HTML, but it isn't the same thing. One of the most
important differences: JSX is, in the end, a JavaScript value -- you can
assign it to a variable, return it from a function, or put it in a list.
Plain HTML can't do any of that.

There's also a naming difference (we'll see this in "Attributes and
className" below). But overall, the look is largely the same as HTML --
tags like `<div>`, `<h1>`, and `<button>` will look familiar.

## JavaScript Inside JSX: Curly Braces `{ }`

The most powerful part of JSX is that you can embed real JavaScript
inside it. You do this with a single curly brace `{ }`:

{{JsxExpressionExample.jsx}}

Anything that **produces a value** can go inside the curly braces: a
variable (`{name}`), a calculation (`{a + b}`), or a function call
(`{shout(...)}`). Things that don't produce a value (like an `if` block)
can't go here -- we'll see why in "A Quick Look at Conditional Rendering"
below.

## Attributes and className

You use HTML attributes (`src`, `alt`, `class`, etc.) in JSX too, but
with two important differences:

{{JsxAttributesExample.jsx}}

First: instead of HTML's `class`, JSX uses `className` (because `class`
already means something else in JavaScript). Second: just like with text
content, you can bind an attribute's value to a JavaScript expression
using curly braces `{ }`.

## JSX Rules

JSX has a few simple rules you need to follow:

{{JsxRulesExample.jsx}}

The most important one: a JSX block must have a **single root element**
-- you can't return two sibling elements side by side. You can wrap them
in a `<div>`, or use `<> </>` (a "Fragment") if you don't want to add an
extra HTML element. The other rules: attribute names are written in
camelCase (`onClick`, `tabIndex`), and self-closing tags (`<img>`,
`<input>`) must always be closed with a `/` in JSX (`<img />`).

## A Quick Look at Conditional Rendering

We saw that curly braces `{ }` can only hold something that "produces a
value" -- that's why you can't write `if` directly inside JSX (`if`
doesn't produce a value, it just decides whether to run a block of code).
Instead, you use something that does produce a value, like a ternary
(`? :`):

{{JsxConditionalIntroExample.jsx}}

This is just a quick preview -- we'll cover showing different UI based on
a condition ("conditional rendering") in much more depth in the
"Conditional Rendering" lesson, in the State & Events category.

## Summary and Glossary

JSX is a syntax that looks like HTML but is actually JavaScript. You can
embed JavaScript expressions inside it with curly braces `{ }`. It uses
`className` instead of `class`, every JSX block must have a single root
element, and self-closing tags must be closed with `/`.

**Glossary**

**JSX** — A syntax that looks like HTML but is actually an extension of
JavaScript.

**Expression** — A piece of code that produces a value (e.g. `a + b`);
only this kind of code can go inside `{ }` in JSX.

**className** — JSX's equivalent of HTML's `class` attribute.

**Fragment (`<> </>`)** — A JSX tool for grouping multiple elements under
a single root without adding an extra HTML element.

**Root Element** — The single, outermost element in a JSX block -- every
JSX block must have exactly one.
