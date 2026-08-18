import { useState } from "react";

function ResettingControlledInputExample() {
  const [text, setText] = useState("");

  function handleClear() {
    // Because the value lives in state, clearing the input is as simple
    // as resetting the state -- there's no need to touch the actual DOM
    // element (e.g. via useRef or event.target.reset()).
    setText("");
  }

  return (
    <div>
      <input
        type="text"
        value={text}
        onChange={(event) => setText(event.target.value)}
      />
      <button onClick={handleClear}>Clear</button>
    </div>
  );
}
