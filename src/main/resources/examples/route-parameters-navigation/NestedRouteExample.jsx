import { BrowserRouter, Routes, Route, Link, Outlet, useParams } from "react-router";

function CourseLayout() {
  // This is the "parent" route matched by /courses/:courseSlug. The
  // <Outlet /> inside it specifies where the matched CHILD route
  // (if any) should be rendered.
  const { courseSlug } = useParams();

  return (
    <div>
      <h1>Course: {courseSlug}</h1>
      <Link to={`/courses/${courseSlug}/enum`}>Enum Topic</Link>
      <Outlet />
    </div>
  );
}

function TopicDetail() {
  const { courseSlug, topicSlug } = useParams();

  return (
    <p>
      Topic: {topicSlug} (course: {courseSlug})
    </p>
  );
}

function NestedRouteExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/courses/:courseSlug" element={<CourseLayout />}>
          {/* A nested Route -- it is only rendered at the <Outlet />
              position INSIDE CourseLayout, for a URL like
              /courses/java/enum. */}
          <Route path=":topicSlug" element={<TopicDetail />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
