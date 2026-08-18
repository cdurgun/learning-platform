function KeyPropExample() {
  const users = [
    { id: 1, name: "Alice" },
    { id: 2, name: "Bob" },
    { id: 3, name: "Clara" },
  ];

  // The key should, whenever possible, be a PERMANENT and UNIQUE identifier
  // specific to that item -- not its name or index -- such as an id
  // coming from the database, as here.
  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
