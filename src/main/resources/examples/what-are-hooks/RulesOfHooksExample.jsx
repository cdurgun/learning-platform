import { useState } from "react";

function RulesOfHooksExample({ showExtra }) {
  // CORRECT: Hooks are ALWAYS called at the TOP level of the component.
  const [count, setCount] = useState(0);

  // WRONG: Calling a hook conditionally (never do this).
  // if (showExtra) {
  //   const [extra, setExtra] = useState(0); // Breaks the rules!
  // }
  //
  // Why? React tracks each hook by assuming they're called in the SAME
  // ORDER on EVERY RENDER. A conditional hook breaks this order by being
  // called on some renders and not others -- React gets confused about
  // which state belongs to which hook.

  return <p>Count: {count}</p>;
}
