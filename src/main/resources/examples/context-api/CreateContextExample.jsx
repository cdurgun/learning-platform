import { createContext, useContext } from "react";

// createContext(), bir "kutu" oluşturur -- ağacın herhangi bir yerinden,
// props geçirmeden okunabilecek bir değer taşır. Parantez içindeki "light",
// bir Provider bulunmadığında kullanılacak VARSAYILAN değer.
const ThemeContext = createContext("light");

function ThemedButton() {
  // useContext(ThemeContext), en yakın ThemeContext.Provider'ın
  // `value`'sunu okur -- ThemedButton, bu değeri props ile ALMADAN
  // doğrudan buradan okuyor.
  const theme = useContext(ThemeContext);

  return <button className={theme}>Click me</button>;
}

function CreateContextExample() {
  return (
    <ThemeContext.Provider value="dark">
      <ThemedButton />
    </ThemeContext.Provider>
  );
}
