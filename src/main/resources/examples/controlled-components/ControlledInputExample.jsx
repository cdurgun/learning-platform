import { useState } from "react";

function ControlledInputExample() {
  const [text, setText] = useState("");

  function handleChange(event) {
    setText(event.target.value);
  }

  return (
    <div>
      {/* value={text} says that React's state should DECIDE the value the
          input displays on screen -- the input no longer holds its own
          value, it gets its value entirely from the `text` state. */}
      <input type="text" value={text} onChange={handleChange} />
      <p>You typed: {text}</p>
    </div>
  );
}
