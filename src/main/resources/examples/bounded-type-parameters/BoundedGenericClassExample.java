public class BoundedGenericClassExample {

    // The bound can be declared on a CLASS's type parameter too, not just
    // a method's -- every use of NumericBox is now restricted to Number
    // subtypes, and every method inside the class can rely on that.
    static class NumericBox<T extends Number> {
        private final T value;

        NumericBox(T value) {
            this.value = value;
        }

        boolean isPositive() {
            return value.doubleValue() > 0; // legal, thanks to the class-level bound
        }

        T getValue() {
            return value;
        }
    }

    public static void main(String[] args) {
        NumericBox<Integer> intBox = new NumericBox<>(42);
        System.out.println(intBox.isPositive());

        NumericBox<Double> doubleBox = new NumericBox<>(-3.5);
        System.out.println(doubleBox.isPositive());

        // NumericBox<String> stringBox = new NumericBox<>("hi"); // would NOT
        //     compile -- String does not extend Number, so it fails the bound.
    }
}
