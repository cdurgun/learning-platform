import { useState } from "react";

// A custom hook is just a NORMAL JavaScript function that starts with "use" --
// inside it, you can call React's own hooks (like useState, useEffect).
function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue);

  function increment() {
    setCount((prev) => prev + 1);
  }

  function decrement() {
    setCount((prev) => prev - 1);
  }

  return { count, increment, decrement };
}

function CustomHookNamingExample() {
  const { count, increment, decrement } = useCounter(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increment}>+1</button>
      <button onClick={decrement}>-1</button>
    </div>
  );
}
