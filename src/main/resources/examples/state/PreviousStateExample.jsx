import { useState } from "react";

function PreviousStateExample() {
  const [count, setCount] = useState(0);

  function incrementTwice() {
    // WRONG: count still shows the OLD value here, and both lines use
    // the same "old value + 1" -- so the result only increases by 1,
    // not 2.
    // setCount(count + 1);
    // setCount(count + 1);

    // RIGHT: the function form (prevCount => ...) always uses the most
    // up-to-date value from the previous update.
    setCount((prevCount) => prevCount + 1);
    setCount((prevCount) => prevCount + 1);
  }

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={incrementTwice}>Increment by 2</button>
    </div>
  );
}
