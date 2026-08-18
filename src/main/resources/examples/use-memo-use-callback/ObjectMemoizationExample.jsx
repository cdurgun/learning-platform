import { useState, useMemo } from "react";

function ObjectMemoizationExample() {
  const [count, setCount] = useState(0);

  // Without useMemo, a NEW object is created on every render -- even if the
  // content is the same, objects from two different renders are NOT
  // considered "equal" (===).
  const config = useMemo(
    () => ({ theme: "dark", fontSize: 16 }),
    [], // No dependencies -- the object is only created on the FIRST render.
  );

  return (
    <div>
      <p>Count: {count}</p>
      <p>
        Theme: {config.theme}, Font Size: {config.fontSize}
      </p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
