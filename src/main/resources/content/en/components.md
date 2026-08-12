# Components

In the JSX lesson, we saw React's syntax. Now let's look at what we
actually use JSX inside: **components**. In React, everything is built
out of components -- this lesson covers what a component is and how to
write and use one, with simple examples.

## What Is a Component?

A component is a small, independent piece of a UI -- a button, a card,
even an entire page can be a component. As we mentioned in What Is
React?, a React application is really just many small components put
together.

## Writing a Component as a Function

At its simplest, a component is a JavaScript function that returns JSX:

{{FunctionComponentExample.jsx}}

That's it. There's no new syntax or special keyword -- just a regular
function that returns JSX.

## Using a Component (Rendering It)

Using a component (this is called "rendering" it) means writing it as a
tag inside JSX:

{{UsingComponentExample.jsx}}

`<Welcome />` works just like writing `<h1>` or `<div>` -- the only
difference is that this one is a component you wrote. A component can
also be used inside another component, like `App` using `Welcome`.

## The Component Naming Rule

How does React tell a component apart from a regular HTML tag? Simple: by
whether the name starts with an uppercase or lowercase letter.

{{ComponentNamingExample.jsx}}

A name starting with a lowercase letter (`div`, `button`, `userCard`) is
treated by React as a regular HTML tag. That's why component names must
always start with an uppercase letter (`Welcome`, `UserCard`). Forgetting
this is one of the most common mistakes in this lesson.

## Reusable Components

The biggest benefit of a component: write it once, use it as many times
as you want.

{{ReusableButtonExample.jsx}}

The same `Button` component is used three times -- no need to rewrite the
same HTML each time. In the next lesson (Props), we'll see how to
customize the same component with DIFFERENT data on each use.

## Summary and Glossary

A component is a function that returns JSX. Its name must start with an
uppercase letter, it's used as a tag inside JSX, and it can be written
once and reused as many times as needed.

**Glossary**

**Component** — A JavaScript function that returns JSX, describing a
small, independent piece of a UI.

**Rendering** — Using a component inside JSX (like `<Welcome />`).

**Function Component** — A component written as a function (the most
common kind of component in React today).
