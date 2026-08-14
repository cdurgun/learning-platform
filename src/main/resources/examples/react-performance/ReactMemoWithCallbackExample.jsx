import { memo, useCallback, useState } from "react";

const SearchButton = memo(function SearchButton({ onSearch }) {
  console.log("SearchButton render edildi");
  return <button onClick={onSearch}>Search</button>;
});

function ReactMemoWithCallbackExample() {
  const [count, setCount] = useState(0);
  const [query, setQuery] = useState("");

  // useCallback OLMADAN, her render'da `handleSearch` YENİ bir fonksiyon
  // olurdu -- fonksiyonlar da birer değer olduğu için, memo bunu "props
  // değişti" sayar ve SearchButton'ı yine de yeniden render ederdi.
  // useCallback, `query` değişmediği sürece AYNI fonksiyon referansını
  // korur.
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
