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
  // ":courseSlug" olarak tanımlanan URL parçası, useParams() ile bir
  // nesne olarak okunur -- anahtar, Route'taki isimle (courseSlug) aynı.
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
