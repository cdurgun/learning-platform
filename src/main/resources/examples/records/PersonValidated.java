record PersonValidated(String name, int age) {

    // Compact constructor: validation and normalization happen here.
    PersonValidated {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("name boş olamaz");
        }
        if (age < 0 || age > 150) {
            throw new IllegalArgumentException("age geçersiz: " + age);
        }
        name = name.trim(); // reassigning the parameter — not the field
    }
}
