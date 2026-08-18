import { createContext, useContext, useState } from "react";

const ThemeContext = createContext(null);

function ThemeProvider({ children }) {
  const [theme, setTheme] = useState("light");

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// The pattern from the Custom Hooks lesson continues here: instead of
// spreading useContext across components, we wrap it in a separate hook
// (`useTheme`). This way, the consuming component just calls `useTheme()`
// without ever dealing with the "context" concept -- just like `useState`.
function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error("useTheme must be used within a ThemeProvider");
  }
  return context;
}

function ThemeToggleButton() {
  const { theme, setTheme } = useTheme();

  return (
    <button onClick={() => setTheme(theme === "light" ? "dark" : "light")}>
      Current theme: {theme}
    </button>
  );
}

function CustomContextHookExample() {
  return (
    <ThemeProvider>
      <ThemeToggleButton />
    </ThemeProvider>
  );
}
