import { useState } from "react";

// useState is a HOOK that React provides out of the box -- a function that
// starts with "use" and adds React features like state to function
// components.
function WhatIsAHookExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>useState is a hook: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
