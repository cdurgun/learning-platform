public class ParallelIterationLimitationExample {
    public static void main(String[] args) {
        String[] names = {"Alice", "Bob", "Carol"};
        int[] ages = {30, 25, 35};

        // Enhanced for iterates ONE Iterable at a time -- there's no direct
        // way to walk two arrays together, because there's no shared index.
        // Nesting two enhanced-for loops would pair EVERY name with EVERY
        // age, not the matching ones.

        // A classic for loop, sharing a single index across both arrays,
        // solves this cleanly (see "Multiple Variables in for" in the
        // "for Loop" lesson for the two-index version of this pattern).
        for (int i = 0; i < names.length; i++) {
            System.out.println(names[i] + " is " + ages[i] + " years old.");
        }
    }
}
