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
  // Sharing State dersindeki örneğin aksine, Level1/Level2/Level3'ün
  // HİÇBİRİ `user` prop'unu bilmiyor bile -- yalnızca Level4, en dipte,
  // UserContext'ten DOĞRUDAN okuyor.
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
