# useRef

In useEffect, we saw a component reaching outside its render output.
This lesson covers another hook that solves a similar need -- "remembering"
a value without triggering the screen to update, or accessing a DOM
element directly: `useRef`.

## DOM References

One of `useRef`'s most common uses is accessing a DOM element directly:

{{DomReferenceExample.jsx}}

Writing `ref={inputRef}` tells React "put this element's real DOM node
into `inputRef.current`." `inputRef.current` is now a real DOM element --
we can call the browser's own methods on it directly, like `focus()`.

## Persistent Values Across Renders

`useRef`'s second use: "remembering" a value across renders, without
that value changing triggering a RE-RENDER:

{{PersistentValueExample.jsx}}

`renderCount.current` increases on every render and its value persists
across renders -- but that increase doesn't trigger a re-render on its
own. We only see the updated value on the NEXT render (triggered here
by the `count` state changing for another reason).

## useRef vs. useState

The key difference between `useRef` and `useState`: changing state with
`useState` TRIGGERS a re-render, changing a ref does NOT:

{{UseRefVsUseStateExample.jsx}}

Clicking "Increment State" updates the screen, because `setStateValue`
triggers a re-render. Clicking "Increment Ref" really does change the
value (you can see it in the console), but nothing changes on screen --
because a ref change doesn't tell React "re-render." A value that needs
to be VISIBLE on screen should be state; a value that just needs to be
"remembered," without appearing on screen, can be a ref.

## Using useRef and useEffect Together

`useRef` and `useEffect` are often used together -- for example, to
answer "what was the value on the previous render":

{{PreviousValueWithRefExample.jsx}}

The `useEffect`, which runs after every render, saves the current
`count` value into `previousCountRef`. On the next render, this ref
still holds the value from the PREVIOUS render -- because updating a
ref doesn't trigger a new render on its own; the update only happens
inside the render that's triggered by the `count` state changing.

## Summary and Glossary

`useRef` is used for two main things: accessing a DOM element directly,
or remembering a value across renders without triggering the screen to
update. Unlike `useState`, changing a ref doesn't trigger a re-render --
so use `useState` for data that needs to be visible on screen, and
`useRef` for "background" values that don't.

**Glossary**

**`useRef`** — The hook that lets you access a DOM element, or store a
value across renders without triggering the screen to update.

**`.current`** — The field on the object `useRef` returns that holds
the currently stored value.

**DOM Reference** — Direct access to a JSX element's real browser DOM
node; set up with the `ref` attribute.
