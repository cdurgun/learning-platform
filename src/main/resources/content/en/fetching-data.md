# Fetching Data

In every example so far, data was defined INSIDE the component (as an
array or object). In real applications, data usually comes from a
**server**. This lesson covers the basic way to fetch data from a
server in React (and send data to it) -- the `fetch` function.

## Fetching Data with fetch: GET

`fetch` is a built-in browser function -- it sends an HTTP request to a
URL and returns a **Promise**. The `useEffect` we saw in the Hooks
lesson is used to fire this request when the component appears on
screen:

{{BasicFetchGetExample.jsx}}

Since `useEffect`'s second argument is an empty array (`[]`), this
request fires only ONCE, when the component first renders.
`fetch(url).then(...)` first converts the response to JSON, then writes
the incoming data to state with `setCourses` -- when state changes,
React re-renders and the list appears on screen.

## Showing a Loading State

Some time passes between sending the request and receiving the
response -- during that time, we need to show the user that something
is happening instead of a blank screen:

{{LoadingStateExample.jsx}}

The `loading` state starts as `true`; we set it to `false` once the
data arrives. While `loading` is `true`, the component renders
`<p>Loading...</p>` and returns EARLY -- the rest of the JSX never
renders.

## Handling Errors

A request doesn't always succeed -- the network can drop, the server
can return an error. If we don't handle this, the user is left with a
silently blank screen:

{{ErrorHandlingExample.jsx}}

`response.ok` tells us whether the HTTP status code is in the 200-299
range -- `fetch` does NOT automatically reject on statuses like 404 or
500, so we have to check this ourselves and `throw`. `.catch()` catches
that error and writes it to the `error` state; `.finally()` turns off
`loading` regardless of success or failure.

## Sending Data: POST

Besides reading data (GET), a POST request is used to create a new
record:

{{PostRequestExample.jsx}}

In a POST request, we pass `fetch` a second argument -- an options
object: `method: "POST"`, `headers` to tell the server the data we're
sending is JSON, and `body` where we put the data we're sending,
converted to a string with `JSON.stringify(...)`.

## Updating and Deleting: PUT and DELETE

PUT is used to update an existing record, DELETE to remove one:

{{PutAndDeleteExample.jsx}}

Like POST, PUT sends a `body` -- but the URL specifies WHICH record to
update (`/courses/${courseId}`). DELETE usually sends no `body` at all,
specifying only via the URL's id which record to remove.

## Summary and Glossary

`fetch` sends an HTTP request to a URL and returns a Promise; it's
called inside `useEffect` when the component appears on screen. GET
reads data, POST creates a new record, PUT updates an existing record,
DELETE removes one -- POST and PUT send JSON in the `body`. A request
should always be managed together with `loading` and `error` state --
the user should see a waiting message until the data arrives, and a
clear message if something goes wrong.

**Glossary**

**fetch** — The browser's built-in function for sending an HTTP request
to a URL; returns a Promise.

**HTTP Method** — A word describing the PURPOSE of a request: GET
(read), POST (create), PUT (update), DELETE (remove).

**Promise** — A JavaScript object representing an operation that hasn't
completed yet, but will eventually produce a result (or an error).
