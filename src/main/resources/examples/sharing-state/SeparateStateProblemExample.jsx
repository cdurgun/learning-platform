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
  // Problem: this component needs to know what the user typed into
  // SearchBox -- but the `query` state is trapped INSIDE SearchBox and
  // there is no way to reach it from here.
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
