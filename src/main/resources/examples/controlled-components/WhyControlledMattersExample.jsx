import { useState } from "react";

function WhyControlledMattersExample() {
  const [text, setText] = useState("");

  // Because the value lives in state, we can instantly use it in ANOTHER
  // part of the screen as the user types each letter -- for example to
  // show a character count or an uppercase preview.
  return (
    <div>
      <input
        type="text"
        value={text}
        onChange={(event) => setText(event.target.value)}
        placeholder="Type something..."
      />
      <p>Character count: {text.length}</p>
      <p>Uppercase preview: {text.toUpperCase()}</p>
    </div>
  );
}
