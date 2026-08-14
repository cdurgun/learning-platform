function KeyPropExample() {
  const users = [
    { id: 1, name: "Ayşe" },
    { id: 2, name: "Mehmet" },
    { id: 3, name: "Elif" },
  ];

  // key, mümkün olduğunca eleman ismi ya da index değil, o elemana özgü,
  // KALICI ve BENZERSİZ bir kimlik olmalı -- burada veritabanından gelen
  // id gibi.
  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
