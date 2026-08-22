public class TernaryOperatorExample {
    public static void main(String[] args) {
        int age = 20;
        String status = (age >= 18) ? "adult" : "minor";
        System.out.println("Status: " + status);

        int a = 15;
        int b = 42;
        int max = (a > b) ? a : b;
        System.out.println("Max: " + max);

        // Ternary expressions can be nested, but this quickly hurts readability --
        // prefer an if/else-if chain (see "else if Chains") once you need more
        // than two outcomes.
        int score = 72;
        String grade = (score >= 90) ? "A" : (score >= 80) ? "B" : (score >= 70) ? "C" : "F";
        System.out.println("Nested ternary grade: " + grade);
    }
}
