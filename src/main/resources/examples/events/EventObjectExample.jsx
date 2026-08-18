function EventObjectExample() {
  function handleClick(event) {
    console.log("Event type:", event.type);
    console.log("Target element:", event.target.tagName);
  }

  return <button onClick={handleClick}>See the Event Object (Check the Console)</button>;
}
