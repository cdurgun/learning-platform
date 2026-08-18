import { useEffect, useState } from "react";

function LoadingStateExample() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/api/courses")
      .then((response) => response.json())
      .then((data) => {
        setCourses(data);
        setLoading(false);
      });
  }, []);

  // Showing a "Loading..." message on screen until the data arrives lets
  // the user know something is happening -- instead of an empty list.
  if (loading) {
    return <p>Loading...</p>;
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
