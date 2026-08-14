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

// Custom Hooks dersindeki desen burada devam ediyor: useContext'i
// component'lerin içine dağıtmak yerine, ayrı bir hook'a (`useTheme`)
// sarmalıyoruz. Böylece kullanan component, "context" kavramıyla hiç
// uğraşmadan `useTheme()` çağırıyor -- tıpkı `useState` gibi.
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
