import { useState, useRef } from "react";

function UseRefVsUseStateExample() {
  const [stateValue, setStateValue] = useState(0);
  const refValue = useRef(0);

  function incrementState() {
    setStateValue(stateValue + 1); // Updates the screen (triggers a re-render).
  }

  function incrementRef() {
    refValue.current = refValue.current + 1;
    console.log("refValue.current:", refValue.current);
    // The value really did change, but the screen is NOT UPDATED -- because
    // changing a ref does not trigger a re-render.
  }

  return (
    <div>
      <p>State: {stateValue}</p>
      <button onClick={incrementState}>Increment State</button>
      <button onClick={incrementRef}>Increment Ref (Check Console)</button>
    </div>
  );
}
