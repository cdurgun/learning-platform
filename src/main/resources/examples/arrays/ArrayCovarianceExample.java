public class ArrayCovarianceExample {
    public static void main(String[] args) {
        // Java arrays are COVARIANT: since Integer extends Number, an
        // Integer[] can be assigned to a Number[] variable.
        Integer[] integers = {1, 2, 3};
        Number[] numbers = integers; // legal -- Integer[] IS-A Number[]
        System.out.println("numbers[0] via the Number[] view: " + numbers[0]);

        // The DANGER: the compiler allows storing a Double into `numbers`
        // (since Double is also a Number), but the array's REAL runtime type is
        // still Integer[] -- so this fails, not at compile time, but at RUNTIME.
        try {
            numbers[1] = 3.14; // compiles fine (Double IS-A Number)...
            System.out.println("unreachable");
        } catch (ArrayStoreException e) {
            System.out.println("Caught: " + e.getClass().getSimpleName() + " -- " + e.getMessage());
        }

        // This is exactly the kind of bug that array covariance can hide until
        // runtime -- generics (List<T>) deliberately do NOT allow this: a
        // List<Integer> cannot be assigned to a List<Number> variable at all,
        // so the equivalent mistake is caught at COMPILE time instead.
        System.out.println();
        System.out.println("Arrays: covariant, unsafe writes fail at RUNTIME (ArrayStoreException).");
        System.out.println("Generics (List<T>): invariant, the equivalent mistake fails at COMPILE time.");
    }
}
