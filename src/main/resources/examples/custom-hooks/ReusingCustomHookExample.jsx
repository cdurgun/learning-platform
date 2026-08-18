import { useState } from "react";

function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue);
  return {
    count,
    increment: () => setCount((prev) => prev + 1),
  };
}

function ReusingCustomHookExample() {
  // We call the same hook twice -- each call has its own INDEPENDENT state.
  const apples = useCounter(0);
  const oranges = useCounter(10);

  return (
    <div>
      <p>Apples: {apples.count}</p>
      <button onClick={apples.increment}>Add Apple</button>

      <p>Oranges: {oranges.count}</p>
      <button onClick={oranges.increment}>Add Orange</button>
    </div>
  );
}
