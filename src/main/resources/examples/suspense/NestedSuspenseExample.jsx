import { lazy, Suspense } from "react";

const CourseHeader = lazy(() => import("./CourseHeader.jsx"));
const CourseReviews = lazy(() => import("./CourseReviews.jsx"));

function NestedSuspenseExample() {
  return (
    // The outer Suspense shows a fallback for the WHOLE page until
    // CourseHeader loads. Once CourseHeader appears, the INNER Suspense
    // only takes the place of CourseReviews -- the rest of the page
    // (including CourseHeader) does NOT go back to a "loading" state.
    <Suspense fallback={<p>Loading page...</p>}>
      <CourseHeader />
      <Suspense fallback={<p>Loading reviews...</p>}>
        <CourseReviews />
      </Suspense>
    </Suspense>
  );
}
