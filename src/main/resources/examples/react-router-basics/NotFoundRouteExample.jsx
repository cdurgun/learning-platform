import { BrowserRouter, Routes, Route, Link } from "react-router";

function Home() {
  return <h1>Home</h1>;
}

function Courses() {
  return <h1>Courses</h1>;
}

function NotFound() {
  return (
    <div>
      <h1>404 - Page Not Found</h1>
      <Link to="/">Go back home</Link>
    </div>
  );
}

function NotFoundRouteExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
        {/* path="*" CATCHES any URL that doesn't match any of the other
            defined Routes -- it's always written LAST inside Routes. */}
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}
