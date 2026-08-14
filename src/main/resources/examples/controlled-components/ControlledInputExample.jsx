import { useState } from "react";

function ControlledInputExample() {
  const [text, setText] = useState("");

  function handleChange(event) {
    setText(event.target.value);
  }

  return (
    <div>
      {/* value={text}, input'un ekranda gösterdiği değeri React'in state'i
          BELİRLESİN diyor -- input artık kendi başına bir değer tutmuyor,
          değerini tamamen `text` state'inden alıyor. */}
      <input type="text" value={text} onChange={handleChange} />
      <p>Yazdığın: {text}</p>
    </div>
  );
}
