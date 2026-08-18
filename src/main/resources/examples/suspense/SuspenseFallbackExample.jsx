import { lazy, Suspense } from "react";

const CourseDetails = lazy(() => import("./CourseDetails.jsx"));

function SuspenseFallbackExample() {
  return (
    // `fallback` can be any JSX -- not just text, but also a spinner, a
    // skeleton screen, or another component. In the Lazy Loading lesson
    // we only saw Suspense used together with lazy() -- this lesson
    // takes a closer look at Suspense itself.
    <Suspense fallback={<p className="spinner">Loading course...</p>}>
      <CourseDetails />
    </Suspense>
  );
}
