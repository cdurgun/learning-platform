class OverloadResolutionExample {
    static void process(int value) {
        System.out.println("process(int): " + value);
    }

    static void process(long value) {
        System.out.println("process(long): " + value);
    }

    static void process(Integer value) {
        System.out.println("process(Integer): " + value);
    }

    static void process(int... values) {
        System.out.println("process(int...): " + values.length + " values");
    }

    public static void main(String[] args) {
        short s = 5;
        process(s); // no process(short) -- WIDENS to int -- process(int)

        process(5L); // exact match -- process(long)

        Integer boxed = 5;
        process(boxed); // exact match -- process(Integer)

        process(1, 2, 3); // no 3-arg overload -- falls back to VARARGS -- process(int...)
    }
}
