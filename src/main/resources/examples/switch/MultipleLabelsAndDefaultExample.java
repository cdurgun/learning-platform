public class MultipleLabelsAndDefaultExample {

    enum Season { WINTER, SPRING, SUMMER, FALL }

    public static void main(String[] args) {
        System.out.println(describe(Season.WINTER));
        System.out.println(describe(Season.SPRING));
        System.out.println(describe(Season.SUMMER));
        System.out.println(describe(Season.FALL));
    }

    // A switch EXPRESSION over an enum can skip `default` entirely as long as
    // EVERY constant is covered -- the compiler checks this exhaustiveness for
    // you. Adding a new enum constant later without updating this switch
    // becomes a COMPILE ERROR, not a silent bug.
    private static String describe(Season season) {
        return switch (season) {
            case WINTER, FALL -> "cold";
            case SPRING, SUMMER -> "warm";
        };
    }
}
