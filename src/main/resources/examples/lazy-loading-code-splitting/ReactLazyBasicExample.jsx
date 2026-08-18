import { lazy, Suspense, useState } from "react";

// lazy() loads the component's CODE with a dynamic import() instead of
// a regular import -- this file is NOT INCLUDED in the app's initial
// bundle, it's only downloaded as a separate file when actually needed.
// This is what we call "code splitting".
const CourseDetails = lazy(() => import("./CourseDetails.jsx"));

function ReactLazyBasicExample() {
  const [showDetails, setShowDetails] = useState(false);

  return (
    <div>
      <button onClick={() => setShowDetails(true)}>Show Details</button>
      {showDetails && (
        // Suspense specifies a fallback UI to show WHILE the lazy
        // component's code is LOADING -- `fallback` is shown until the
        // code is downloaded, then the real component is rendered.
        <Suspense fallback={<p>Loading...</p>}>
          <CourseDetails />
        </Suspense>
      )}
    </div>
  );
}
