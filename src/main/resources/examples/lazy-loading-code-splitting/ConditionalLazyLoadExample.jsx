import { lazy, Suspense, useState } from "react";

// EmojiPicker gibi büyük, nadiren kullanılan bir component'i lazy
// yapmak özellikle faydalı -- kullanıcıların çoğu belki hiç açmaz, o
// zaman kodunu hiç indirmemiş oluruz.
const EmojiPicker = lazy(() => import("./EmojiPicker.jsx"));

function ConditionalLazyLoadExample() {
  const [showPicker, setShowPicker] = useState(false);

  return (
    <div>
      <button onClick={() => setShowPicker(!showPicker)}>
        {showPicker ? "Hide" : "Show"} Emoji Picker
      </button>
      {/* EmojiPicker'ın kodu, `showPicker` İLK KEZ true olana kadar HİÇ
          indirilmez -- yalnızca gerçekten kullanılacaksa yükleniyor. */}
      {showPicker && (
        <Suspense fallback={<p>Loading emoji picker...</p>}>
          <EmojiPicker />
        </Suspense>
      )}
    </div>
  );
}
