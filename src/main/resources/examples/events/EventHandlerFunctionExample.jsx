function EventHandlerFunctionExample() {
  function sayHello() {
    console.log("Hello!");
  }

  return (
    <div>
      {/* CORRECT: we pass the function itself, we don't call it. */}
      <button onClick={sayHello}>Named Function</button>

      {/* You can also write an inline function. */}
      <button onClick={() => console.log("Hi!")}>Inline Function</button>

      {/* WRONG: if you write sayHello(), the function runs immediately
          as soon as the component renders -- it won't wait for a click. */}
      {/* <button onClick={sayHello()}>Wrong Usage</button> */}
    </div>
  );
}
