function IfConditionalExample({ isLoggedIn }) {
  // if does NOT PRODUCE A VALUE, so it can't be written directly inside
  // JSX's { }. Instead, we decide on a plain variable BEFORE the return.
  let message;

  if (isLoggedIn) {
    message = "Welcome!";
  } else {
    message = "Please log in.";
  }

  return <p>{message}</p>;
}
