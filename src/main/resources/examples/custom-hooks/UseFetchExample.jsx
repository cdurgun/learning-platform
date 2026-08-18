import { useState, useEffect } from "react";

// Instead of writing useEffect + useState over and over, we extract the
// "data fetching" logic into a reusable custom hook. (A simplified
// example -- topics like error handling and race conditions will be
// covered in more detail in the "API & Data Fetching" category.)
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(url)
      .then((response) => response.json())
      .then((json) => {
        setData(json);
        setLoading(false);
      });
  }, [url]);

  return { data, loading };
}

function UseFetchExample() {
  const { data, loading } = useFetch("https://api.example.com/users");

  if (loading) {
    return <p>Loading...</p>;
  }

  return <p>{data.length} users found.</p>;
}
