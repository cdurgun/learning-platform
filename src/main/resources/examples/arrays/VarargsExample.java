public class VarargsExample {
    public static void main(String[] args) {
        // A varargs parameter (Type... name) lets the CALLER pass zero, one, or
        // many arguments -- inside the method, it is simply an array.
        System.out.println("sum(): " + sum());
        System.out.println("sum(1): " + sum(1));
        System.out.println("sum(1, 2, 3, 4): " + sum(1, 2, 3, 4));

        // Passing an actual array works exactly the same way -- varargs IS an
        // array parameter, just with convenient call-site syntax.
        int[] values = {10, 20, 30};
        System.out.println("sum(values) (passing an int[] directly): " + sum(values));

        // A varargs parameter must be the LAST parameter in the method's
        // signature -- printLabeled() below shows a normal parameter followed by
        // varargs.
        printLabeled("Scores", 90, 85, 77);
        printLabeled("Empty case");

        // System.out.printf() and String.format() themselves use varargs
        // (Object... args) -- that's how they accept any number of placeholders.
        System.out.printf("printf is varargs too: %s scored %d%n", "Alice", 95);
    }

    private static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) {
            total += n;
        }
        return total;
    }

    private static void printLabeled(String label, int... values) {
        System.out.print(label + ": ");
        if (values.length == 0) {
            System.out.println("(no values)");
            return;
        }
        for (int v : values) {
            System.out.print(v + " ");
        }
        System.out.println();
    }
}
