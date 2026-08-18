import { BrowserRouter, Routes, Route, NavLink } from "react-router";

function Home() {
  return <h1>Home Page</h1>;
}

function Courses() {
  return <h1>Courses Page</h1>;
}

function NavLinkActiveExample() {
  return (
    <BrowserRouter>
      <nav>
        {/* NavLink does the same job as Link -- but by passing a function
            to className, we can distinguish the "I'm currently on this
            link's page" state (isActive). */}
        <NavLink
          to="/"
          className={({ isActive }) => (isActive ? "nav-link active" : "nav-link")}
        >
          Home
        </NavLink>
        <NavLink
          to="/courses"
          className={({ isActive }) => (isActive ? "nav-link active" : "nav-link")}
        >
          Courses
        </NavLink>
      </nav>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
      </Routes>
    </BrowserRouter>
  );
}
