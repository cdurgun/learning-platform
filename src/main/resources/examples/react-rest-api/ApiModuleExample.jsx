// In real apps, instead of scattering fetch calls across every component,
// it's common to collect them in a separate file (e.g. api.js) -- this
// keeps all requests in ONE place and lets you change `BASE_URL` in a
// single spot. This example shows the CONTENTS of that file (normally it
// would be a separate file, and components would import these functions).

const BASE_URL = "http://localhost:3000";

async function getCourses() {
  const response = await fetch(`${BASE_URL}/courses`);
  if (!response.ok) {
    throw new Error("Failed to load courses");
  }
  return response.json();
}

async function createCourse(course) {
  const response = await fetch(`${BASE_URL}/courses`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(course),
  });
  return response.json();
}

async function deleteCourse(courseId) {
  await fetch(`${BASE_URL}/courses/${courseId}`, { method: "DELETE" });
}

function ApiModuleExample() {
  return (
    <p>
      This represents an api.js module: getCourses(), createCourse() and
      deleteCourse() wrap the raw fetch calls in one place.
    </p>
  );
}
