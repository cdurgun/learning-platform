const BASE_URL = "http://localhost:3000";

function DeleteCourseExample({ courses, setCourses }) {
  async function handleDelete(courseId) {
    await fetch(`${BASE_URL}/courses/${courseId}`, { method: "DELETE" });

    // AFTER deleting on the server, we also need to update the list on
    // screen -- following the immutability rule from the State lesson, we
    // create a new array by REMOVING the deleted record with filter().
    setCourses(courses.filter((course) => course.id !== courseId));
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>
          {course.name}
          <button onClick={() => handleDelete(course.id)}>Delete</button>
        </li>
      ))}
    </ul>
  );
}
