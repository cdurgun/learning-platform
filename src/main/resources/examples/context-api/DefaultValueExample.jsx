import { createContext, useContext } from "react";

const ThemeContext = createContext("light");

function ThemedButton() {
  const theme = useContext(ThemeContext);
  return <button className={theme}>Click me</button>;
}

function DefaultValueExample() {
  // There's NO Provider here at all -- when ThemedButton calls
  // useContext(ThemeContext), it gets the DEFAULT value ("light") given
  // by createContext("light"). A Provider is only needed when we want to
  // OVERRIDE that value.
  return <ThemedButton />;
}
