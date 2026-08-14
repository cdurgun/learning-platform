import { createContext, useContext } from "react";

const ThemeContext = createContext("light");

function ThemedButton() {
  const theme = useContext(ThemeContext);
  return <button className={theme}>Click me</button>;
}

function DefaultValueExample() {
  // Burada HİÇ Provider yok -- ThemedButton, useContext(ThemeContext)
  // çağırdığında, createContext("light") ile verilen VARSAYILAN değeri
  // ("light") alır. Provider yalnızca, o değeri EZMEK (override etmek)
  // istediğimizde gerekli.
  return <ThemedButton />;
}
