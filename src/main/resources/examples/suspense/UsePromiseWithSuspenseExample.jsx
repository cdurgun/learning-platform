import { Suspense, use } from "react";

function fetchCourse() {
  return fetch("http://localhost:3000/courses/1").then((response) => response.json());
}

// To avoid creating a NEW Promise on every render, we call this once
// OUTSIDE the component, while the module loads.
const coursePromise = fetchCourse();

function CourseName() {
  // Unlike normal hooks, use() can also be called CONDITIONALLY. When
  // given a Promise, if the Promise has NOT resolved yet, use() tells
  // React "I need to wait" -- this shows the fallback of the nearest
  // Suspense; once the Promise resolves, it returns the actual value.
  const course = use(coursePromise);
  return <p>Course: {course.name}</p>;
}

function UsePromiseWithSuspenseExample() {
  return (
    <Suspense fallback={<p>Loading course...</p>}>
      <CourseName />
    </Suspense>
  );
}
