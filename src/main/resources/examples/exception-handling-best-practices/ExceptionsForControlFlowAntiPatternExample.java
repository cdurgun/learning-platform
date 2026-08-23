public class ExceptionsForControlFlowAntiPatternExample {

    public static void main(String[] args) {
        int[] numbers = {4, 8, 15, 16, 23, 42};

        System.out.println("bad (exception as control flow): " + findFirstOver20_bad(numbers));
        System.out.println("good (ordinary control flow):    " + findFirstOver20_good(numbers));
    }

    // BAD: throwing and catching an exception purely to break out of a loop
    // once a value is found. Nothing here is actually exceptional -- "found
    // a matching number" is a completely normal, expected outcome. Building
    // and unwinding a stack trace for it is wasted work and hides the real
    // control flow behind a try/catch that has nothing to do with error
    // handling.
    static int findFirstOver20_bad(int[] numbers) {
        try {
            for (int n : numbers) {
                if (n > 20) {
                    throw new FoundException(n);
                }
            }
        } catch (FoundException e) {
            return e.value;
        }
        return -1;
    }

    static class FoundException extends RuntimeException {
        final int value;
        FoundException(int value) {
            this.value = value;
        }
    }

    // GOOD: the same result using ordinary control flow -- no exception
    // involved at all, because nothing exceptional happened.
    static int findFirstOver20_good(int[] numbers) {
        for (int n : numbers) {
            if (n > 20) {
                return n;
            }
        }
        return -1;
    }
}
