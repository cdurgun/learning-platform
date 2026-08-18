function OnSubmitExample() {
  function handleSubmit(event) {
    // Without preventDefault, the browser tries to submit the form and
    // the page reloads -- we don't want that in React apps.
    event.preventDefault();
    console.log("Form submitted!");
  }

  return (
    <form onSubmit={handleSubmit}>
      <button type="submit">Submit</button>
    </form>
  );
}
