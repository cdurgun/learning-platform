import { useState, useCallback } from "react";

function UseCallbackBasicExample() {
  const [count, setCount] = useState(0);

  // Without useCallback, handleClick would be created as a NEW function on
  // every render -- functions from two different renders are not considered
  // "equal". useCallback keeps the SAME function reference as long as the
  // dependency array doesn't change.
  const handleClick = useCallback(() => {
    console.log("Clicked, count:", count);
  }, [count]);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
      <button onClick={handleClick}>Log to Console</button>
    </div>
  );
}
