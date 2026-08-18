import { useState } from "react";

function SliderInput({ rating, onRatingChange }) {
  return (
    <input
      type="range"
      min="0"
      max="5"
      value={rating}
      onChange={(event) => onRatingChange(Number(event.target.value))}
    />
  );
}

function RatingDisplay({ rating }) {
  return <p>Rating: {rating} / 5</p>;
}

function SyncedSiblingsExample() {
  // Two sibling components with different views (a slider and a text
  // display) represent the SAME value -- since the state has been
  // moved to their common ancestor, both always stay in sync.
  const [rating, setRating] = useState(0);

  return (
    <div>
      <SliderInput rating={rating} onRatingChange={setRating} />
      <RatingDisplay rating={rating} />
    </div>
  );
}
