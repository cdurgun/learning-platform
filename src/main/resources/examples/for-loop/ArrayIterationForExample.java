public class ArrayIterationForExample {
    public static void main(String[] args) {
        int[] scores = {70, 85, 92, 60, 78};

        // The classic index-based for loop gives you the INDEX at every
        // step, not just the value -- useful for printing positions, or
        // comparing neighboring elements.
        for (int i = 0; i < scores.length; i++) {
            System.out.println("scores[" + i + "] = " + scores[i]);
        }

        // Because you have the index, you can also MODIFY the array in
        // place -- something a value-only loop cannot do (see "Enhanced for
        // Loop" for why).
        for (int i = 0; i < scores.length; i++) {
            scores[i] = scores[i] + 5; // curve every score by +5
        }

        System.out.print("Curved scores: ");
        for (int i = 0; i < scores.length; i++) {
            System.out.print(scores[i] + " ");
        }
        System.out.println();
    }
}
