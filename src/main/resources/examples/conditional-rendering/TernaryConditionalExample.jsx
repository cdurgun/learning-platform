function TernaryConditionalExample({ isLoggedIn }) {
  // The ternary (? :) PRODUCES A VALUE, so it can be written directly
  // inside { }. This condenses the four lines from IfConditionalExample
  // into a single line.
  return <p>{isLoggedIn ? "Welcome!" : "Please log in."}</p>;
}
