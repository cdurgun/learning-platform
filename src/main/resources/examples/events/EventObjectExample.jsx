function EventObjectExample() {
  function handleClick(event) {
    console.log("Olay tipi:", event.type);
    console.log("Hedef element:", event.target.tagName);
  }

  return <button onClick={handleClick}>Event Object'i Gör (Console'a Bak)</button>;
}
