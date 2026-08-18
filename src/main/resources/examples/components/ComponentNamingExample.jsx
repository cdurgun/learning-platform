// React tells components and normal HTML tags apart by their capitalization:
// - Starts with a lowercase letter ("div", "button") -> a normal HTML tag.
// - Starts with an uppercase letter ("Welcome", "UserCard") -> your component.

function userCard() {
  // Because this function starts with a lowercase letter, even if you write
  // <userCard /> in JSX, React will try to interpret it as an unknown HTML
  // tag rather than as a component -- this is why component names must
  // ALWAYS start with an uppercase letter.
  return <div>Incorrect naming example</div>;
}

function UserCard() {
  // This is correct: a name that starts with an uppercase letter.
  return <div>Correct naming example</div>;
}

console.log(userCard(), UserCard());
