import { useEffect, useState } from "react";

function ErrorHandlingExample() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch("/api/courses")
      .then((response) => {
        if (!response.ok) {
          // fetch() does NOT automatically reject on HTTP errors like
          // 404/500 -- it's up to us to CHECK response.ok.
          throw new Error("Request failed: " + response.status);
        }
        return response.json();
      })
      .then((data) => setCourses(data))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return <p>Loading...</p>;
  }

  // If the error state is set, we show an error message without ever
  // rendering the list -- the same if pattern from the Conditional
  // Rendering lesson.
  if (error) {
    return <p>Something went wrong: {error}</p>;
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
