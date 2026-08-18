import { Suspense, useEffect, useState } from "react";

function CourseListWithEffect() {
  const [courses, setCourses] = useState(null);

  // IMPORTANT: useEffect + fetch (the pattern from the API & Data
  // Fetching lesson) does NOT AUTOMATICALLY TRIGGER Suspense -- Suspense
  // only works with a Promise source that React DIRECTLY recognizes,
  // like use(). That's why, while the `courses` state is null here, the
  // outer Suspense's fallback does NOT show -- the component renders
  // `null`, and Suspense never even finds out.
  useEffect(() => {
    fetch("http://localhost:3000/courses")
      .then((response) => response.json())
      .then((data) => setCourses(data));
  }, []);

  if (!courses) {
    // Not Suspense's fallback -- our own manual loading check.
    return null;
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}

function SuspenseLimitationsExample() {
  return (
    <Suspense fallback={<p>This fallback never shows for CourseListWithEffect.</p>}>
      <CourseListWithEffect />
    </Suspense>
  );
}
