import { useState } from "react";

function MultiFieldFormExample() {
  // Instead of opening a separate useState for each field, we keep ALL
  // fields in a single state object -- more manageable as the form grows.
  const [formData, setFormData] = useState({ name: "", email: "" });

  function handleChange(event) {
    const { name, value } = event.target;

    // Whichever input changed (based on the input's `name` attribute),
    // we only update that field, copying the rest as they are.
    setFormData({ ...formData, [name]: value });
  }

  return (
    <form>
      <input
        type="text"
        name="name"
        value={formData.name}
        onChange={handleChange}
        placeholder="Name"
      />
      <input
        type="email"
        name="email"
        value={formData.email}
        onChange={handleChange}
        placeholder="Email"
      />
      <p>
        {formData.name} / {formData.email}
      </p>
    </form>
  );
}
