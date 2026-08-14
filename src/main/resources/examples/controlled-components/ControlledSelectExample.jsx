import { useState } from "react";

function ControlledSelectExample() {
  const [language, setLanguage] = useState("tr");

  return (
    <div>
      {/* select'ler de aynı desenle kontrol edilir: value + onChange. */}
      <select value={language} onChange={(event) => setLanguage(event.target.value)}>
        <option value="tr">Türkçe</option>
        <option value="en">English</option>
      </select>
      <p>Seçilen dil: {language}</p>
    </div>
  );
}
