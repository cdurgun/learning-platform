import { useState } from "react";

function ControlledSelectExample() {
  const [language, setLanguage] = useState("tr");

  return (
    <div>
      {/* Selects are controlled with the same pattern: value + onChange. */}
      <select value={language} onChange={(event) => setLanguage(event.target.value)}>
        <option value="tr">Turkish</option>
        <option value="en">English</option>
      </select>
      <p>Selected language: {language}</p>
    </div>
  );
}
