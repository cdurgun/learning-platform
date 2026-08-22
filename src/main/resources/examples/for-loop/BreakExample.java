public class BreakExample {
    public static void main(String[] args) {
        int[] numbers = {4, 9, 15, 23, 42, 7};
        int target = 23;
        int foundIndex = -1;

        for (int i = 0; i < numbers.length; i++) {
            if (numbers[i] == target) {
                foundIndex = i;
                // break immediately exits the loop -- no point checking the
                // remaining elements once the target is found.
                break;
            }
        }

        if (foundIndex != -1) {
            System.out.println("Found " + target + " at index " + foundIndex);
        } else {
            System.out.println(target + " not found");
        }

        // Without break, every iteration would run even after finding a
        // match -- wasted work, and the LAST match would silently win
        // instead of the first one.
        int lastMatchIndex = -1;
        for (int i = 0; i < numbers.length; i++) {
            if (numbers[i] > 10) {
                lastMatchIndex = i;
            }
        }
        System.out.println("Last index > 10 (no break): " + lastMatchIndex);
    }
}
