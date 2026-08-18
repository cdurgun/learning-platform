import { useEffect, useState } from "react";

function BasicFetchGetExample() {
  const [courses, setCourses] = useState([]);

  // useEffect runs ONCE when the component first appears on screen (empty
  // dependency array []) -- this is the most common use case for fetching
  // data. fetch() returns a Promise; with .then() we first convert the
  // response to JSON, then write it to state.
  useEffect(() => {
    fetch("/api/courses")
      .then((response) => response.json())
      .then((data) => setCourses(data));
  }, []);

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
