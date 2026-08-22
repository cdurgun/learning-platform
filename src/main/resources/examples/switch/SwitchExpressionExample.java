public class SwitchExpressionExample {
    public static void main(String[] args) {
        System.out.println("1 -> " + classify(1));
        System.out.println("3 -> " + classify(3));
        System.out.println("6 -> " + classify(6));
        System.out.println("9 -> " + classify(9));
    }

    // A switch EXPRESSION evaluates directly to a value -- no need for a
    // separate variable that gets assigned inside each branch.
    private static String classify(int day) {
        return switch (day) {
            case 1, 2, 3, 4, 5 -> "weekday";
            case 6, 7 -> "weekend";
            default -> {
                // A block body needs `yield` to produce the expression's value.
                System.out.println("  (unexpected value logged: " + day + ")");
                yield "invalid";
            }
        };
    }
}
