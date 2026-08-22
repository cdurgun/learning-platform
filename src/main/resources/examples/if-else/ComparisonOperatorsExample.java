public class ComparisonOperatorsExample {
    public static void main(String[] args) {
        int a = 10;
        int b = 20;

        System.out.println("a == b: " + (a == b));
        System.out.println("a != b: " + (a != b));
        System.out.println("a < b: " + (a < b));
        System.out.println("a > b: " + (a > b));
        System.out.println("a <= b: " + (a <= b));
        System.out.println("a >= b: " + (a >= b));

        // Comparing floating-point numbers directly with == is risky -- binary
        // floating point cannot represent 0.1 or 0.2 exactly, so their sum is
        // not exactly 0.3.
        double sum = 0.1 + 0.2;
        System.out.println("0.1 + 0.2 == 0.3: " + (sum == 0.3));
        System.out.println("Actual value: " + sum);

        // Comparing String OBJECTS with == compares references, not content --
        // see the "String Pool ve == vs equals()" section in the String lesson.
        String literalOne = "hello";
        String literalTwo = "hello";
        String constructed = new String("hello");

        System.out.println("literalOne == literalTwo: " + (literalOne == literalTwo));
        System.out.println("literalOne == constructed: " + (literalOne == constructed));
        System.out.println("literalOne.equals(constructed): " + literalOne.equals(constructed));
    }
}
