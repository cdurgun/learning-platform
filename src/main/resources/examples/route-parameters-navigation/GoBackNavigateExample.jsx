import { BrowserRouter, Routes, Route, Link, useNavigate } from "react-router";

function CourseList() {
  return (
    <div>
      <h1>Courses</h1>
      <Link to="/courses/java">Java</Link>
    </div>
  );
}

function CourseDetail() {
  const navigate = useNavigate();

  function handleBack() {
    // navigate(-1) does the same thing as the browser's "back" button --
    // it goes one step back in the history. navigate(-2) goes two steps
    // back, and so on.
    navigate(-1);
  }

  return (
    <div>
      <h1>Course Detail</h1>
      <button onClick={handleBack}>Back</button>
    </div>
  );
}

function GoBackNavigateExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/courses" element={<CourseList />} />
        <Route path="/courses/:courseSlug" element={<CourseDetail />} />
      </Routes>
    </BrowserRouter>
  );
}
