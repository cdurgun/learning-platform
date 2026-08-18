import { BrowserRouter, Routes, Route, Link, useParams } from "react-router";

function CourseList() {
  return (
    <div>
      <h1>Courses</h1>
      <Link to="/courses/java">Java</Link>
      <Link to="/courses/react">React</Link>
    </div>
  );
}

function CourseDetail() {
  // The URL segment defined as ":courseSlug" is read as an object via
  // useParams() -- the key matches the name used in the Route (courseSlug).
  const { courseSlug } = useParams();

  return <h1>Course: {courseSlug}</h1>;
}

function RouteParamExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/courses" element={<CourseList />} />
        <Route path="/courses/:courseSlug" element={<CourseDetail />} />
      </Routes>
    </BrowserRouter>
  );
}
