import { useState } from "react";

function StateImmutabilityExample() {
  const [user, setUser] = useState({ name: "Emma", age: 25 });

  function haveBirthday() {
    // WRONG: mutating the existing object directly.
    // React might not notice the change, and the screen might not update.
    // user.age = user.age + 1;
    // setUser(user);

    // RIGHT: create a NEW object that copies the old values via spread
    // (...) and pass that to the state.
    setUser({ ...user, age: user.age + 1 });
  }

  return (
    <div>
      <p>
        {user.name} is {user.age} years old.
      </p>
      <button onClick={haveBirthday}>Birthday</button>
    </div>
  );
}
