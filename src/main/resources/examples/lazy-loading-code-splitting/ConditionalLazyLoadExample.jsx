import { lazy, Suspense, useState } from "react";

// Making a large, rarely used component like EmojiPicker lazy is
// especially useful -- most users may never open it, in which case we
// never download its code at all.
const EmojiPicker = lazy(() => import("./EmojiPicker.jsx"));

function ConditionalLazyLoadExample() {
  const [showPicker, setShowPicker] = useState(false);

  return (
    <div>
      <button onClick={() => setShowPicker(!showPicker)}>
        {showPicker ? "Hide" : "Show"} Emoji Picker
      </button>
      {/* EmojiPicker's code is NEVER downloaded until `showPicker` becomes
          true for the FIRST time -- it's only loaded if it will actually
          be used. */}
      {showPicker && (
        <Suspense fallback={<p>Loading emoji picker...</p>}>
          <EmojiPicker />
        </Suspense>
      )}
    </div>
  );
}
