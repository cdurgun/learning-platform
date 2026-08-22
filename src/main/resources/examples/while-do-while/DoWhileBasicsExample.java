public class DoWhileBasicsExample {
    public static void main(String[] args) {
        int count = 10;

        // do-while checks the condition AFTER the body -- so the body runs
        // at least ONCE even though "count <= 5" is already false when the
        // loop starts.
        do {
            System.out.println("count = " + count);
            count++;
        } while (count <= 5);

        System.out.println("Loop ran exactly once, count is now " + count);
    }
}
