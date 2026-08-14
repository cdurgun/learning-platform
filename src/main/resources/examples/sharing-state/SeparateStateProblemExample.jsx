import { useState } from "react";

function SearchBox() {
  const [query, setQuery] = useState("");

  return (
    <input
      type="text"
      value={query}
      onChange={(event) => setQuery(event.target.value)}
      placeholder="Search courses..."
    />
  );
}

function ResultsList() {
  // Sorun: bu component'in, kullanıcının SearchBox'a ne yazdığını bilmesi
  // gerekiyor -- ama `query` state'i SearchBox'ın İÇİNDE hapsolmuş, buraya
  // hiçbir şekilde ulaşamıyor.
  return <p>Type in the search box above -- but this list has no way to know what you typed.</p>;
}

function SeparateStateProblemExample() {
  return (
    <div>
      <SearchBox />
      <ResultsList />
    </div>
  );
}
