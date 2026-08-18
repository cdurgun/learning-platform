import { useEffect, useState } from "react";

const BASE_URL = "http://localhost:3000";

function FetchCoursesExample() {
  const [courses, setCourses] = useState([]);

  useEffect(() => {
    // The callback of useEffect CANNOT be async directly -- so we define a
    // separate async function inside and call it right away. In a real
    // project this corresponds to GET /api/courses (with Spring Boot) --
    // React sends a request to the backend over HTTP, the backend reads
    // from the database (PostgreSQL) and returns JSON.
    async function loadCourses() {
      const response = await fetch(`${BASE_URL}/courses`);
      const data = await response.json();
      setCourses(data);
    }

    loadCourses();
  }, []);

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
