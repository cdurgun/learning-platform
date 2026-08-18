import { createContext, useContext } from "react";

// createContext() creates a "box" -- it carries a value that can be read
// from anywhere in the tree, without passing props. The "light" in the
// parentheses is the DEFAULT value used when no Provider exists.
const ThemeContext = createContext("light");

function ThemedButton() {
  // useContext(ThemeContext) reads the `value` of the nearest
  // ThemeContext.Provider -- ThemedButton reads this value directly,
  // WITHOUT receiving it as a prop.
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
