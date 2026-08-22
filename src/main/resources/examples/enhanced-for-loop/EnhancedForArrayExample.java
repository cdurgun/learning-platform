public class EnhancedForArrayExample {
    public static void main(String[] args) {
        int[] scores = {70, 85, 92, 60, 78};

        // "for (Type element : array)" reads as "for each element in array" --
        // no counter, no condition, no update to write yourself.
        for (int score : scores) {
            System.out.println("Score: " + score);
        }

        int total = 0;
        for (int score : scores) {
            total += score;
        }
        System.out.println("Total: " + total);
    }
}
