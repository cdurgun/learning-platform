import { useState } from "react";

function FormSubmitExample() {
  const [name, setName] = useState("");
  const [submittedName, setSubmittedName] = useState(null);

  function handleSubmit(event) {
    event.preventDefault();
    // Form gönderildiğinde, o an state'te olan değeri kullanıyoruz --
    // controlled input olduğu için değerin ne olduğunu her zaman biliyoruz.
    setSubmittedName(name);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={name}
        onChange={(event) => setName(event.target.value)}
        placeholder="İsmini yaz"
      />
      <button type="submit">Gönder</button>

      {submittedName && <p>Gönderilen: {submittedName}</p>}
    </form>
  );
}
