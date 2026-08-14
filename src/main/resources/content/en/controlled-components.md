# Controlled Components

In Events we saw `onChange`, and in State we saw `useState`, separately.
This lesson brings the two together into the **controlled component** --
the fundamental pattern for writing forms in React.

## What Is a Controlled Component?

Normally, an `<input>` keeps its own value inside itself (in the
browser's DOM) -- React might not even be aware of it. In a
**controlled component**, the input's value is DETERMINED by React's
state instead: the input doesn't hold a value on its own, it always
gets its value from state.

## Binding an Input to State with value

The first step in making an input controlled is binding the `value`
attribute to a state variable:

{{ControlledInputExample.jsx}}

Since we wrote `value={text}`, the value shown in the input is ALWAYS
whatever `text` currently holds in state. But that alone isn't enough --
something also needs to happen when the user types, which we'll see in
the next section.

## Updating State with onChange

`value` alone makes the input read-only -- the user can't type anything.
To keep state up to date, you also need `onChange`:

{{WhyControlledMattersExample.jsx}}

Every keystroke runs `onChange`, `setText` updates state, React
re-renders, and the input's `value` reflects that new state. This loop
(type → update state → re-render → show in input) is the heart of a
controlled component. Since the value lives in state, we can also use
it instantly somewhere else on screen at the same time (a character
count, a preview, etc.).

## Controlled Checkboxes and Selects

The same pattern isn't limited to text inputs -- checkboxes and selects
can be controlled too:

{{ControlledCheckboxExample.jsx}}

Checkboxes use `checked` instead of `value`, but the logic is the same:
React's state decides whether it's checked.

{{ControlledSelectExample.jsx}}

A `<select>` is controlled with `value` and `onChange` too, just like a
text input.

## Why Controlled Components?

One of the most concrete benefits of keeping a value in React's state
is that you can easily do things with it -- like resetting it
programmatically:

{{ResettingControlledInputExample.jsx}}

Since the value lives in state, clearing the input is as simple as
`setText("")`. If we kept the value outside React (in the browser's own
DOM), we'd need a DOM reference (`useRef`) or the form's own `reset()`
method to do the same thing.

## Summary and Glossary

A controlled component is a form element bound to state with `value`
(or `checked` for checkboxes) and kept up to date with `onChange`. Since
the value always lives in React's state, reading, validating, or
resetting it becomes easier -- you don't have to rely on a value the
input holds on its own.

**Glossary**

**Controlled Component** — A form element whose value is determined by
React's state and updated with `onChange`.

**Uncontrolled Component** — A form element that holds its own value
(in the browser's DOM), not tied to React state.
