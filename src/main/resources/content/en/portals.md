# Portals

The last topic in the Advanced React category -- a way to render a
component to a different DOM node than its position in the React tree:
**Portals**.

## What Is a Portal? Getting Started with createPortal

`react-dom`'s `createPortal` function lets us render a component to a
different place in the DOM:

{{BasicPortalExample.jsx}}

`createPortal(child, container)` renders `child` into the `container`
DOM node, instead of its normal position in the React tree. It still
appears in its expected place in the component tree (in React
DevTools), but its actual DOM position is completely different.

## Using Portals for Modals

The most common use case for Portals is modals:

{{ModalWithPortalExample.jsx}}

A modal's CSS (`position: fixed`, a high `z-index`) needs to make it
appear ABOVE the rest of the page -- but the modal's actual DOM
position (say, inside a card with `overflow: hidden`) can sometimes
prevent that. A Portal ELIMINATES this problem by rendering the modal
directly into `document.body`.

## Event Bubbling: A Portal's Surprising Behavior

The most important (and most surprising) property of Portals is how
events behave:

{{EventBubblingThroughPortalExample.jsx}}

`Popup` renders OUTSIDE the outer `<div>` in the DOM (into
`document.body`). But clicking the button inside it still causes
`onClick` to bubble up to the outer `<div>` -- React propagates events
according to its OWN component tree, not the actual DOM tree. This is
the most important behavior to know when using Portals.

## Setting Up a Portal Target

Instead of `document.body`, a dedicated target is usually used:

{{PortalTargetSetupExample.jsx}}

Adding something like `<div id="tooltip-root"></div>` as a SIBLING to
the app's `#root` in `index.html` is common practice -- it makes it
easier for the portal's content to manage its own styles and
positioning.

## Summary and Glossary

`createPortal(child, container)` renders a component to a different DOM
node while KEEPING its position in the React tree -- the most common
uses are modals, tooltips, and dropdowns (to avoid CSS properties like
`overflow: hidden` on ancestor elements). Events bubble according to
React's component tree, not the actual DOM position -- this lets us
keep using Portals like normal components.

**Glossary**

**Portal** — A mechanism for rendering a component to a different DOM
node while preserving its position in the React tree.

**Event Bubbling** — An event propagating upward from the element it
was triggered on, through its ancestor elements.

## Practical Project

There's a real, runnable example project that brings together the
concepts from this category (React Performance, Error Boundaries, Lazy
Loading & Code Splitting, Suspense, Portals):
**[Advanced React Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/advanced-react)**
-- an application showing a course list optimized with `React.memo`, an
Error Boundary, a detail panel code-split with `React.lazy` +
`Suspense`, and a Portal modal, all working together.

You can download it and run it yourself, and read through the code
line by line:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/advanced-react
npm run dev
```

The `react-course-projects` repo uses **npm workspaces** -- `npm install`
only needs to run once, at the repo root, and every project folder
shares the same dependencies (no separate `node_modules` per folder). If
you've already run `npm install` at the root, you can just
`cd react-course-projects/projects/advanced-react` and run `npm run dev`.
