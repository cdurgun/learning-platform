import { useState } from "react";

function ControlledCheckboxExample() {
  const [isSubscribed, setIsSubscribed] = useState(false);

  // Checkbox'larda value yerine checked kullanılır -- mantık aynı:
  // checkbox'ın işaretli olup olmadığını React'in state'i belirliyor.
  function handleChange(event) {
    setIsSubscribed(event.target.checked);
  }

  return (
    <div>
      <label>
        <input type="checkbox" checked={isSubscribed} onChange={handleChange} />
        Bültene abone ol
      </label>
      <p>{isSubscribed ? "Abonesin." : "Abone değilsin."}</p>
    </div>
  );
}
