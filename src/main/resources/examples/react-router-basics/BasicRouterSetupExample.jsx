import { BrowserRouter, Routes, Route } from "react-router";

function Home() {
  return <h1>Home Page</h1>;
}

function Courses() {
  return <h1>Courses Page</h1>;
}

function BasicRouterSetupExample() {
  return (
    <BrowserRouter>
      {/* Routes decides WHICH Route to render based on the URL -- only the
          matching one is rendered at any given time. */}
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
      </Routes>
    </BrowserRouter>
  );
}
