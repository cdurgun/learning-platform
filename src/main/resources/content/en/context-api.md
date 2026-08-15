# Context API

In Sharing State, we saw how props drilling becomes a problem in a deep
component tree. This lesson covers React's built-in solution to that
problem -- the **Context API**.

## Creating a Context with createContext

Context is a "box" that carries a value readable from anywhere in the
tree, without passing props:

{{CreateContextExample.jsx}}

`createContext("light")` creates a `ThemeContext` -- the value in the
parentheses is the DEFAULT value used when there's no Provider.
`<ThemeContext.Provider value="dark">` OVERRIDES this value to `"dark"`
for the entire tree inside it. `useContext(ThemeContext)` reads the
value from the nearest Provider.

## Without a Provider: The Default Value

A Provider isn't always required -- without one, `useContext` returns
the default value given to `createContext`:

{{DefaultValueExample.jsx}}

There's no `Provider` at all in this example; `ThemedButton` gets the
`"light"` value given via `createContext("light")`. A Provider is only
needed when you want to CHANGE that default.

## Solving Props Drilling with Context

Let's rewrite the deep tree example from Sharing State, this time with
Context:

{{AvoidingPropsDrillingExample.jsx}}

NONE of `Level1`, `Level2`, `Level3` even know about the `user` prop
anymore -- only `Level4`, at the very bottom, reads it DIRECTLY from
`UserContext`. We didn't need to pass anything through the intermediate
layers.

## Carrying State Inside Context

Context doesn't just carry a fixed value -- it can carry the state
itself AND the function that updates it:

{{ContextWithStateExample.jsx}}

`value={{ items, addItem }}` gives the Provider an OBJECT -- both the
current `items` list and the `addItem` function that updates it. This
is the most common way Context is used in real applications.

## Wrapping Context in a Custom Hook

The custom hook pattern from the Hooks lesson pairs very naturally with
Context:

{{CustomContextHookExample.jsx}}

`useTheme()` WRAPS `useContext(ThemeContext)` to expose a cleaner API
-- the component that uses it calls `useTheme()` without ever dealing
with the concept of "context," just like a built-in hook. Throwing an
error when used outside a Provider catches misuse early.

## Summary and Glossary

`createContext()` creates a value readable from anywhere in the tree;
a `Provider` OVERRIDES that value for a specific subtree; `useContext()`
reads the value from the nearest Provider. Without a Provider, the
default value given to `createContext` is used. Context can carry a
fixed value, or state together with the functions that update it --
combined with wrapping `useContext` in a custom hook (like `useTheme()`),
this is the most common way to manage what could be called "global"
state in React.

**Glossary**

**Context** — A React structure that carries a value readable from
anywhere in the tree, without passing props.

**Provider** — The component that sets a Context's value for the
entire subtree beneath it.

## Practical Project

There's a real, runnable example project that brings together the
concepts from this category (Sharing State, Context API):
**[State Management Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/state-management)**
-- a course list that can be filtered by search and have courses added
to favorites.

It shows keeping the search text in a shared parent (lifting state up)
and passing it via props to both the search box and results list, and
managing favorite courses with a `FavoritesContext`
(createContext + Provider + custom hook) read from different parts of
the tree (the course list AND a favorites counter in the header) with
NO props drilling at all, all working together. You can download it
and run it yourself, and read through the code line by line:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/state-management
npm run dev
```

The `react-course-projects` repo uses **npm workspaces** -- `npm install`
only needs to run once, at the repo root, and every project folder
shares the same dependencies (no separate `node_modules` per folder). If
you've already run `npm install` at the root, you can just
`cd react-course-projects/projects/state-management` and run
`npm run dev`.
