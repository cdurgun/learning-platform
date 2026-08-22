public class BreakContinueInWhileExample {
    public static void main(String[] args) {
        // break and continue work exactly the same way in while/do-while as
        // they do in for (see the "for Loop" lesson) -- only the loop's own
        // header differs.
        int i = 0;
        System.out.println("break in a while loop:");
        while (true) {
            i++;
            if (i > 3) {
                break;
            }
            System.out.println("i = " + i);
        }

        System.out.println("continue in a while loop:");
        int j = 0;
        while (j < 10) {
            j++;
            if (j % 2 == 0) {
                continue;
            }
            System.out.println("odd j = " + j);
        }
    }
}
