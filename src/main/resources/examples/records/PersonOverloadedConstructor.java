record PersonOverloadedConstructor(String name, int age) {

    // Extra constructor: delegates to the canonical constructor with a default
    // age of 0 when the age is unknown. The first line must always be this(...).
    PersonOverloadedConstructor(String name) {
        this(name, 0);
    }
}
