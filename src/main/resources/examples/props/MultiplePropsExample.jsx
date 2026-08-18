// You can pass as many props as you like to a component -- each one
// reaches the function as a separate field of the props object.
function UserCard(props) {
  return (
    <div>
      <h2>{props.name}</h2>
      <p>Age: {props.age}</p>
      <p>City: {props.city}</p>
    </div>
  );
}

function App() {
  return <UserCard name="Emma" age={28} city="Boston" />;
}

console.log(App());
