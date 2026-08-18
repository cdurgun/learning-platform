import { useState } from "react";

function ControlledCheckboxExample() {
  const [isSubscribed, setIsSubscribed] = useState(false);

  // Checkboxes use checked instead of value -- the logic is the same:
  // React's state decides whether the checkbox is checked or not.
  function handleChange(event) {
    setIsSubscribed(event.target.checked);
  }

  return (
    <div>
      <label>
        <input type="checkbox" checked={isSubscribed} onChange={handleChange} />
        Subscribe to newsletter
      </label>
      <p>{isSubscribed ? "You are subscribed." : "You are not subscribed."}</p>
    </div>
  );
}
