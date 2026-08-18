import { useEffect, useState } from "react";

// The useEffect+fetch+loading/error pattern from the API & Data Fetching
// lesson -- except on the other end there's no longer json-server, but a
// REAL Spring Boot application deployed to Render.
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? "http://localhost:8080";

function CourseList() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function loadCourses() {
      try {
        const response = await fetch(`${API_BASE_URL}/api/courses`);
        if (!response.ok) {
          throw new Error(`Request failed: ${response.status}`);
        }
        setCourses(await response.json());
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }

    loadCourses();
  }, []);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Could not reach the backend: {error}</p>;

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}

export default CourseList;
