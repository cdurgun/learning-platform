import { BrowserRouter, Routes, Route, Link, Outlet, useParams } from "react-router";

function CourseLayout() {
  // Bu, /courses/:courseSlug ile eşleşen "üst" route. İçindeki <Outlet />,
  // eşleşen ALT route'un (varsa) nereye render edileceğini belirtir.
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
          {/* İç içe (nested) Route -- yalnızca /courses/java/enum gibi bir
              URL'de, CourseLayout'un İÇİNDEKİ <Outlet /> konumunda render
              edilir. */}
          <Route path=":topicSlug" element={<TopicDetail />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
