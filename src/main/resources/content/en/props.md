# Props

In Components, we used the `Button` component three times, but all three
were identical. What if we want to show a different label or a different
color each time? That's what **props** are for. This lesson covers how
to send data into a component from outside, with simple examples.

## What Are Props?

Props (properties) are how you send data into a component from outside --
much like giving an HTML tag an attribute (remember "Attributes and
className" from the JSX lesson), except here the value reaches the
component function as a parameter.

## Sending Data from Parent to Child

When you use a component (that is, "render" it), you can give it values
like attributes -- these become that component's props:

{{BasicPropsExample.jsx}}

Here, `App` is the component that uses `Greeting` (the "parent"), and
`Greeting` is the component being used (the "child"). By writing
`name="Ayşe"`, we send `Greeting` a prop named `name`.

## Using Multiple Props

You can send a component as many props as you want:

{{MultiplePropsExample.jsx}}

Each prop reaches the component as its own field on the `props` object --
`props.name`, `props.age`, `props.city`, and so on.

## Reading Props with Destructuring

Instead of writing `props.name` everywhere, most React code uses
destructuring:

{{PropsDestructuringExample.jsx}}

Both versions do exactly the same thing -- destructuring just removes the
repeated `props.` and makes the code a bit shorter. This is the more
common style, and we'll keep using it in later lessons.

## Default Values (Default Props)

What happens if a prop is never sent? You can define a default value
right in the destructuring:

{{DefaultPropsExample.jsx}}

`name = "Guest"` is exactly the same idea as default values for regular
JavaScript function parameters -- if `name` isn't sent, `Guest` is used.

## Props vs. Regular Function Parameters

Props really are nothing more than a regular function parameter -- there's
no special mechanism from React here. The difference is just in how you
use it: you'd call a normal function as `Greeting({ name: "Ayşe" })`,
while you "call" a component inside JSX as `<Greeting name="Ayşe" />`.
There's also an important rule: props are **read-only** -- a component
should never change a prop it receives. If you need to change data over
time, that's what "state" is for -- we'll cover that in the State &
Events category.

## Summary and Glossary

Props are how you send data into a component from outside. A parent
component gives a child values like attributes; the child reads them via
`props` (or directly as variables, with destructuring). If a prop isn't
sent, a default value can be defined. Props are read-only.

**Glossary**

**Props** — Read-only data sent into a component from outside.

**Parent Component** — A component that uses (renders) another
component.

**Child Component** — A component used by a parent component.

**Destructuring** — Syntax for pulling an object's fields directly into
variables (like `{ name, age }`).

**Default Prop** — A predefined value used when a prop isn't sent.
