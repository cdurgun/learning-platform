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
  // İki farklı görünüme (bir slider, bir metin) sahip iki kardeş
  // component, AYNI değeri temsil ediyor -- state, ortak ataya
  // taşındığı için ikisi de her zaman senkron kalıyor.
  const [rating, setRating] = useState(0);

  return (
    <div>
      <SliderInput rating={rating} onRatingChange={setRating} />
      <RatingDisplay rating={rating} />
    </div>
  );
}
