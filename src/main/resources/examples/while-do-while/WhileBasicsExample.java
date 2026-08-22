public class WhileBasicsExample {
    public static void main(String[] args) {
        int count = 1;

        // The condition is checked BEFORE each iteration -- if it's false
        // from the start, the body never runs at all.
        while (count <= 5) {
            System.out.println("count = " + count);
            count++;
        }

        int sum = 0;
        int n = 1;
        while (sum < 20) {
            sum += n;
            n++;
        }
        System.out.println("Stopped once sum reached " + sum + " (n was " + n + ")");
    }
}
