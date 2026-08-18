function AndOperatorConditionalExample({ hasNewMessage }) {
  // The && operator: renders the right side if the left side is "truthy",
  // and renders nothing if it's "falsy" (false, 0, "", null, undefined).
  // Useful when there's no "else" branch like in a ternary -- i.e. for
  // "either show this or show nothing" situations.
  return (
    <div>
      <p>Inbox</p>
      {hasNewMessage && <p>You have a new message!</p>}
    </div>
  );
}
