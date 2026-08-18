import { createContext, useContext } from "react";

const UserContext = createContext(null);

function Level1() {
  return <Level2 />;
}

function Level2() {
  return <Level3 />;
}

function Level3() {
  return <Level4 />;
}

function Level4() {
  // Unlike the example in the Sharing State lesson, NONE of Level1/Level2/
  // Level3 even knows about the `user` prop -- only Level4, at the bottom,
  // reads DIRECTLY from UserContext.
  const user = useContext(UserContext);
  return <p>Logged in as {user}</p>;
}

function AvoidingPropsDrillingExample() {
  return (
    <UserContext.Provider value="Ada">
      <Level1 />
    </UserContext.Provider>
  );
}
