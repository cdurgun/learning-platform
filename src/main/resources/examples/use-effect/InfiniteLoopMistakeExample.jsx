import { useState, useEffect } from "react";

function InfiniteLoopMistakeExample() {
  const [count, setCount] = useState(0);

  // WRONG: a useEffect without a dependency array runs after EVERY
  // render. If state is updated inside it, that update triggers a new
  // render, which runs the effect again -- an INFINITE LOOP.
  // useEffect(() => {
  //   setCount(count + 1);
  // });

  // RIGHT: make the dependency array [] so it only runs on the first render.
  useEffect(() => {
    setCount((prev) => prev + 1);
  }, []);

  return <p>Count (should only increase once): {count}</p>;
}
