import { lazy, Suspense } from "react";

// lazy() expects the import() function to return a DEFAULT export --
// if CourseChart is only a named export (`export function
// CourseChart() {}`, NOT `export default`), we need to wrap it into a
// "default" field using .then().
const CourseChart = lazy(() =>
  import("./CourseChart.jsx").then((module) => ({ default: module.CourseChart })),
);

function NamedExportLazyExample() {
  return (
    <Suspense fallback={<p>Loading chart...</p>}>
      <CourseChart />
    </Suspense>
  );
}
