# Lists & Keys

So far, every example has shown just one thing -- a single counter, a
single user. But real apps usually show a LIST: a list of products, a
list of comments, a list of tasks. This lesson covers rendering lists
in React and why the `key` prop matters.

## Rendering a List with map()

To turn an array into JSX elements on screen, you use JavaScript's
`map()` function:

{{MapRenderListExample.jsx}}

`map()` turns every element in an array into something else and returns
a new array -- here, we're turning each fruit string into an `<li>`
element. The result is an array of JSX elements, which React can render
directly.

## What Is the key Prop?

When rendering a list with `map()`, you need to give each element a
`key` prop:

{{KeyPropExample.jsx}}

`key` is a string or number that UNIQUELY identifies that item within
the list. Whenever possible, use a stable identifier like an `id` from
your database, not the item's name or its index.

## Why Keys Matter

`key` tells React which list item on the next render is the SAME as
which item from the previous render:

{{WhyKeysMatterExample.jsx}}

As long as the list doesn't change, `key` doesn't seem to matter. But
when an item is added, removed, or the order changes, React uses `key`
to figure out which item "stayed the same" and which is new -- so it
only updates the part that actually changed, instead of rebuilding the
whole list.

## Common Mistakes

The most common mistake is using the array index as the `key`:

{{CommonKeyMistakeExample.jsx}}

This looks like it works as long as the list never changes. But once an
item is added or removed, or the order changes, every item's index
shifts -- React can no longer tell, just by looking at the index,
whether it's looking at the same item or a different one. This can
cause visual bugs, especially in lists with inputs (like checkboxes in
a task list), where the wrong item ends up being updated. Use a stable
identifier like `id` whenever you can; if you truly have no stable
identifier and the list is never reordered or changed, the index can be
a last resort.

## Summary and Glossary

You render an array on screen using `map()`; each item gets a unique
`key` so React can correctly track changes in the list. Whenever
possible, use a stable `id` as the `key`, not the array's index --
using the index can cause the wrong items to be updated when the list
changes.

**Glossary**

**`map()`** — A JavaScript array method that turns every item in an
array into something else and returns a new array; used in React to
turn lists into JSX elements.

**`key`** — A unique identifier given to each item in a list, letting
React track items across renders.

**Reconciliation** — The process React uses to find the difference
between the previous render and the new one and update only what
actually changed; `key` is what lets this process match up list items
correctly.

## Practical Project

There's a real, runnable example project that brings together the
concepts from this category (Events, State, Conditional Rendering,
Lists & Keys): **[State & Events Demo](https://github.com/cdurgun/react-course-projects/tree/state-events-v1/projects/state-events)** --
a simple task list app.

It shows event handlers (`onClick`/`onChange`/`onSubmit`), `useState`,
updating based on the previous state, state immutability,
conditional rendering with a ternary/`&&`, and rendering a list with
`map()`+`key`, all working together. You can download it and run it
yourself, and read through the code line by line:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/state-events
npm run dev
```

The `react-course-projects` repo uses **npm workspaces** -- `npm install`
only needs to run once, at the repo root, and every project folder
shares the same dependencies (no separate `node_modules` per folder). If
you've already run `npm install` at the root, you can just
`cd react-course-projects/projects/state-events` and run `npm run dev`.
