import { BrowserRouter, Routes, Route, useNavigate } from "react-router";

function CourseList() {
  const navigate = useNavigate();

  function handleSelect(courseSlug) {
    // Link always requires a click -- useNavigate(), on the other hand,
    // lets us CHANGE the URL from INSIDE a function (e.g. an event
    // handler).
    navigate(`/courses/${courseSlug}`);
  }

  return (
    <div>
      <button onClick={() => handleSelect("java")}>Go to Java</button>
      <button onClick={() => handleSelect("react")}>Go to React</button>
    </div>
  );
}

function CourseDetail() {
  return <h1>Course Detail</h1>;
}

function UseNavigateExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/courses" element={<CourseList />} />
        <Route path="/courses/:courseSlug" element={<CourseDetail />} />
      </Routes>
    </BrowserRouter>
  );
}
