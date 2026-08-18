import { memo, useCallback, useState } from "react";

const SearchButton = memo(function SearchButton({ onSearch }) {
  console.log("SearchButton rendered");
  return <button onClick={onSearch}>Search</button>;
});

function ReactMemoWithCallbackExample() {
  const [count, setCount] = useState(0);
  const [query, setQuery] = useState("");

  // WITHOUT useCallback, `handleSearch` would be a NEW function on every
  // render -- since functions are values too, memo would treat this as
  // "props changed" and re-render SearchButton anyway. useCallback keeps
  // the SAME function reference as long as `query` doesn't change.
  const handleSearch = useCallback(() => {
    console.log("Searching for:", query);
  }, [query]);

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
      <input value={query} onChange={(event) => setQuery(event.target.value)} />
      <SearchButton onSearch={handleSearch} />
    </div>
  );
}
