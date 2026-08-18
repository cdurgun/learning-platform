record PersonValidated(String name, int age) {

    // Compact constructor: validation and normalization happen here.
    PersonValidated {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("name must not be blank");
        }
        if (age < 0 || age > 150) {
            throw new IllegalArgumentException("invalid age: " + age);
        }
        name = name.trim(); // reassigning the parameter — not the field
    }
}
