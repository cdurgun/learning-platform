import { useState } from "react";

function FormSubmitExample() {
  const [name, setName] = useState("");
  const [submittedName, setSubmittedName] = useState(null);

  function handleSubmit(event) {
    event.preventDefault();
    // When the form is submitted, we use the value currently in state --
    // since it's a controlled input, we always know what the value is.
    setSubmittedName(name);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={name}
        onChange={(event) => setName(event.target.value)}
        placeholder="Enter your name"
      />
      <button type="submit">Submit</button>

      {submittedName && <p>Submitted: {submittedName}</p>}
    </form>
  );
}
