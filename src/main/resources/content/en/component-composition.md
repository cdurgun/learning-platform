# Component Composition

In Components and Props, we wrote small components and sent them data.
This lesson shows how to COMBINE those small pieces into bigger UIs --
this is called "composition."

## What Is the children Prop?

`children` is a special prop every component gets automatically. Whatever
you write between a component's opening and closing tags becomes that
component's `children`:

{{ChildrenPropExample.jsx}}

When we write `<Box><p>...</p></Box>`, the `<p>...</p>` part becomes
`Box`'s `children`. This works a bit differently from the regular props
we saw in Props -- you don't pass `children` as an attribute, you write
it INSIDE the tag.

## Nested Components

Components can be nested -- a component can contain other components,
which can themselves contain other components:

{{NestedComponentsExample.jsx}}

`UserProfile` contains `Avatar` and `UserName`; `App` contains
`UserProfile`. This is how you build a large UI out of small components
that each focus on one job.

## Composition vs. Inheritance (A Quick Look)

In object-oriented programming, "inheritance" means a class inherits
behavior from another class. React components have NO such inheritance:

{{CompositionVsInheritanceExample.jsx}}

In React, components are combined through composition, not inheritance --
you put small components inside a larger one using `children`. The React
team has said composition is enough for nearly every scenario, which is
why you won't see a pattern like extending a component with `extends` in
React.

## Summary and Glossary

`children` is a special prop that carries whatever content is written
between a component's opening and closing tags. Components are nested to
build larger UIs. In React, components are combined through composition,
not inheritance.

**Glossary**

**`children`** — A special prop carrying the content written between a
component's opening and closing tags.

**Composition** — Combining small components to build a larger UI.

**Inheritance** — A class inheriting behavior from another class -- a
pattern React does NOT use between components.

## Practical Project

There's a real, runnable example project that brings together the concepts
from this category (Components, Props, Component Composition): **[Components & Props Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/components-props)**.

It shows multiple components, props (with destructuring and default
values), and composition via `children`, all working together. You can
download it and run it yourself, and read through the code line by line:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/components-props
npm run dev
```

The `react-course-projects` repo uses **npm workspaces** -- `npm install`
only needs to run once, at the repo root, and every project folder shares
the same dependencies (no separate `node_modules` per folder). If you've
already run `npm install` at the root, you can just
`cd react-course-projects/projects/components-props` and run
`npm run dev`.
