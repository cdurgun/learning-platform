import { useState } from "react";

function FullFormValidationExample() {
  const [formData, setFormData] = useState({ name: "", email: "" });
  const [errors, setErrors] = useState({});

  function handleChange(event) {
    const { name, value } = event.target;
    setFormData({ ...formData, [name]: value });
  }

  function validate() {
    // We build a separate error message for each field and collect ALL
    // errors in a single object -- this lets each field show its own error.
    const newErrors = {};

    if (formData.name.trim() === "") {
      newErrors.name = "Name cannot be empty.";
    }

    if (formData.email.trim() === "") {
      newErrors.email = "Email cannot be empty.";
    }

    return newErrors;
  }

  function handleSubmit(event) {
    event.preventDefault();

    const newErrors = validate();
    setErrors(newErrors);

    // If the object has no keys at all, there are no errors.
    if (Object.keys(newErrors).length === 0) {
      console.log("Form is valid, submitting:", formData);
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          type="text"
          name="name"
          value={formData.name}
          onChange={handleChange}
          placeholder="Name"
        />
        {errors.name && <p className="error">{errors.name}</p>}
      </div>

      <div>
        <input
          type="email"
          name="email"
          value={formData.email}
          onChange={handleChange}
          placeholder="Email"
        />
        {errors.email && <p className="error">{errors.email}</p>}
      </div>

      <button type="submit">Submit</button>
    </form>
  );
}
