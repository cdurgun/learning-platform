import { useState, useEffect } from "react";

function CleanupFunctionExample() {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    const intervalId = setInterval(() => {
      setSeconds((prev) => prev + 1);
    }, 1000);

    // Cleanup function: React automatically calls this when the
    // component is removed from the screen (unmount), or RIGHT BEFORE
    // the effect runs again. If we don't clear the interval here, it
    // keeps running in the background even after the component is
    // removed from the screen -- a "memory leak".
    return () => {
      clearInterval(intervalId);
    };
  }, []);

  return <p>Elapsed time: {seconds} seconds</p>;
}
