import { BrowserRouter, Routes, Route, Link } from "react-router";

function Home() {
  return (
    <div>
      <h1>Home Page</h1>
      {/* We use <Link to="..."> instead of <a href="..."> -- Link changes
          the URL WITHOUT RELOADING the page (no full page reload), React
          only re-renders the part that needs to change. */}
      <Link to="/courses">View Courses</Link>
    </div>
  );
}

function Courses() {
  return (
    <div>
      <h1>Courses Page</h1>
      <Link to="/">Back to Home</Link>
    </div>
  );
}

function LinkNavigationExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
      </Routes>
    </BrowserRouter>
  );
}
