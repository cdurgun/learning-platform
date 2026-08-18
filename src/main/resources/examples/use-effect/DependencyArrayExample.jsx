import { useState, useEffect } from "react";

function DependencyArrayExample() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState("Alice");

  useEffect(() => {
    console.log("count changed:", count);
  }, [count]); // Only runs when count changes -- not when name changes.

  return (
    <div>
      <p>
        {name}, count: {count}
      </p>
      <button onClick={() => setCount(count + 1)}>Increment Count</button>
      <button onClick={() => setName(name === "Alice" ? "Bob" : "Alice")}>
        Change Name
      </button>
    </div>
  );
}
