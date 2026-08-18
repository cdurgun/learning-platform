import { useState } from "react";

function UseStateBasicExample() {
  // useState(0) sets up state with an initial value of 0.
  // count: to read the current value. setCount: to update the value.
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}
