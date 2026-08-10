class OverloadingExample {
    static int add(int a, int b) {
        return a + b;
    }

    static double add(double a, double b) {
        return a + b;
    }

    static int add(int a, int b, int c) {
        return a + b + c;
    }

    // static double add(int a, int b) { return a + b; } // compile error: cannot overload by return type alone

    public static void main(String[] args) {
        System.out.println(add(2, 3));    // 5    -- add(int, int)
        System.out.println(add(2.5, 3.5)); // 6.0  -- add(double, double)
        System.out.println(add(1, 2, 3)); // 6    -- add(int, int, int)
    }
}
