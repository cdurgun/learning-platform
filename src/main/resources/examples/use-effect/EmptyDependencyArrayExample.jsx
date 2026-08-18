import { useState, useEffect } from "react";

function EmptyDependencyArrayExample() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log("Component appeared on screen for the first time (mounted).");
  }, []); // Empty dependency array: runs only once, after the FIRST render.

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
