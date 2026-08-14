# Route Parameters & Navigation

In React Router Basics, we worked with fixed URLs (`/courses`,
`/about`). This lesson covers putting a variable value INSIDE a URL
(like `/courses/java`), and changing pages from code without a link
click.

## Route Parameters: Reading Data from the URL

Instead of writing a separate `Route` for `/courses/java` and
`/courses/react`, we can define part of the URL as a VARIABLE:

{{RouteParamExample.jsx}}

Writing `path="/courses/:courseSlug"` makes `:courseSlug` a **route
parameter** -- in the URL `/courses/java`, `courseSlug` takes the value
`"java"`. Inside the component, we read this value with the
`useParams()` hook; the key on the returned object matches the name
used in the Route (`courseSlug`).

## Nested Routes and Outlet

Sometimes a page has an INNER section that changes based on the URL --
for example, a course page with a content area that changes depending
on the selected topic:

{{NestedRouteExample.jsx}}

Writing one `Route` INSIDE another (`:topicSlug` inside the
`:courseSlug` route) creates a nested structure. The `<Outlet />` we
place inside the parent component (`CourseLayout`) marks EXACTLY where
the matching child route should render -- without `Outlet`, the child
route wouldn't appear anywhere.

## Programmatic Navigation with useNavigate

`Link` always requires the user to CLICK something. Sometimes we want
to change pages from code AS A RESULT of something -- clicking a
button, finishing a calculation:

{{UseNavigateExample.jsx}}

The `useNavigate()` hook gives us a `navigate` function; calling it
from INSIDE an event handler changes the URL -- unlike `Link`, this
isn't tied to a click, but to a CONDITION in the code.

## Navigating After an Action

One of the most common uses of `useNavigate` is redirecting the user to
another page after a form is submitted:

{{NavigateAfterActionExample.jsx}}

The `onSubmit` + `preventDefault` pattern from Form Handling is the
same here -- the only difference is that after the form is "submitted"
(directly in this example, since there's no real save operation), we
redirect the user to the course list with `navigate("/courses")`.

## Going Back: navigate(-1)

`navigate` can also be given a NUMBER instead of a URL -- this is used
to move forward or backward in browser history:

{{GoBackNavigateExample.jsx}}

`navigate(-1)` does the same thing as the browser's "back" button: it
goes back one step in history. Since this returns the user to
"wherever they came from" instead of pinning them to a fixed page
(like `/courses`), it's usually preferred for "Back" buttons.

## Summary and Glossary

We can create a route parameter by marking part of a URL with `:name`,
and read its value with `useParams()`. Writing one `Route` inside
another and adding `<Outlet />` to the parent component lets us build
nested routes. `useNavigate()` lets us change pages from inside an
event handler or as a result of some action, without needing a click;
`navigate(-1)` moves backward in browser history.

**Glossary**

**Route Parameter** — A part of a URL pattern marked with `:name` that
takes a variable value in the real URL.

**Nested Route** — A Route written inside another Route, rendered only
when the parent Route matches and only at the `<Outlet />` position.

**Outlet** — A component inside a parent route component that marks
where the matching child route should render.

**Programmatic Navigation** — Changing pages from code (e.g. from an
event handler) with `useNavigate()`, instead of clicking a link.

## Practical Project

There's a real, runnable example project that brings together the
concepts from this category (React Router Basics, Route Parameters &
Navigation):
**[Routing Demo](https://github.com/cdurgun/react-course-projects/tree/routing-v1/projects/routing)**
-- a small course-browsing app that mirrors the learning platform's own
course structure (`/courses`, `/courses/java`, `/courses/java/enum`,
and similar).

It shows defining pages with `BrowserRouter` + `Routes` + `Route`,
navigating with `Link`/`NavLink`, reading data from the URL with route
parameters (`useParams`), nested routes with `Outlet`, and programmatic
navigation with `useNavigate`, all working together. You can download
it and run it yourself, and read through the code line by line:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/routing
npm run dev
```

The `react-course-projects` repo uses **npm workspaces** -- `npm install`
only needs to run once, at the repo root, and every project folder
shares the same dependencies (no separate `node_modules` per folder). If
you've already run `npm install` at the root, you can just
`cd react-course-projects/projects/routing` and run `npm run dev`.
