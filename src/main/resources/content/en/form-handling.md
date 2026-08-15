# Form Handling

In Controlled Components, we bound a single input to state. This
lesson covers handling a real form end to end -- submission, multiple
fields, validation, and error messages.

## Submitting a Form: Collecting Values with onSubmit

The `onSubmit` we saw in Events is usually used in forms to work with
the value that's already in state:

{{FormSubmitExample.jsx}}

Since the input is controlled, the `name` state is already up to date
by the time the form is submitted -- there's no need to read the value
from the DOM, we just use state directly.

## Managing Multiple Fields

When a form has more than one input, instead of opening a separate
`useState` for each one, it's more manageable to keep them all in ONE
state object:

{{MultiFieldFormExample.jsx}}

`event.target.name` gives you the `name` attribute of whichever input
changed -- with `[name]: value` (a computed property name), a SINGLE
`handleChange` function can figure out which field changed and update
only that one. This follows the immutability rule from State:
`{ ...formData, [name]: value }` copies the old object and creates a
NEW object with just one field changed.

## Simple Validation

Before submitting a form, you usually want to check whether the entered
values are valid -- this is called **validation**:

{{RequiredFieldValidationExample.jsx}}

We check the value at submit time (inside `handleSubmit`); if it's
empty, we write a message into the `error` state and exit the function
early (`return`) without actually "submitting" the form.

## Displaying Error Messages

Once you find an error, you need to show it to the user -- the `&&`
pattern from Conditional Rendering fits perfectly here:

{{EmailFormatValidationExample.jsx}}

If `error` is non-empty, the expression `{error && <p>...}` renders the
error message; if `error` is empty, nothing renders. This example also
includes a simple email format check -- using a regex
(`emailPattern.test(email)`).

## Validating the Whole Form Before Submit

In a form with multiple fields, each field may need to show its own
error:

{{FullFormValidationExample.jsx}}

The `validate()` function produces a separate error message for each
field and collects them all into ONE object (`newErrors`). If that
object has no keys (`Object.keys(newErrors).length === 0`), the form is
valid. Under each input, only its OWN error (`errors.name`,
`errors.email`) is shown -- again with `&&` for conditional rendering.

## Summary and Glossary

A form is submitted with `onSubmit`; because the inputs are controlled,
their values are already ready in state by the time of submission.
Multiple fields are kept in a single state object, with
`event.target.name` used to figure out which field changed. Validation
is usually done at submit time; errors are kept in state (as a single
message, or an object with one entry per field) and shown with `&&` for
conditional rendering.

**Glossary**

**Validation** — The process of checking whether entered values follow
the expected rules.

**Computed Property Name** — Syntax like `{ [name]: value }` that lets
you set an object's key dynamically from a variable.

## Practical Project

There's a real, runnable example project that brings together the
concepts from this category (Controlled Components, Form Handling):
**[Forms Demo](https://github.com/cdurgun/react-course-projects/tree/main/projects/forms)** --
a simple sign-up form.

It shows controlled inputs with `value`+`onChange`, managing multiple
fields in a single state object, `onSubmit`+`preventDefault`, and
validating the whole form before submit with each field showing its own
error, all working together. You can download it and run it yourself,
and read through the code line by line:

```bash
git clone https://github.com/cdurgun/react-course-projects.git
cd react-course-projects
npm install
cd projects/forms
npm run dev
```

The `react-course-projects` repo uses **npm workspaces** -- `npm install`
only needs to run once, at the repo root, and every project folder
shares the same dependencies (no separate `node_modules` per folder). If
you've already run `npm install` at the root, you can just
`cd react-course-projects/projects/forms` and run `npm run dev`.
