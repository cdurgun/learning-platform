public class StringPoolAndEqualityExample {
    public static void main(String[] args) {
        // Two literals with the same text are the SAME object -- the compiler/JVM
        // reuses a single entry in the "string pool" (an intern table).
        String a = "hello";
        String b = "hello";
        System.out.println("a == b (both literals): " + (a == b));

        // `new String(...)` FORCES a brand-new object on the heap, even if the
        // pool already has an identical value.
        String c = new String("hello");
        System.out.println("a == c (c is `new String(...)`): " + (a == c));
        System.out.println("a.equals(c): " + a.equals(c));

        // intern() looks up (or adds) the pool entry for this value's content,
        // so it goes back to being the same object as the literal.
        String d = c.intern();
        System.out.println("a == d (d is c.intern()): " + (a == d));

        // Compile-time constant expressions are folded into a single literal by
        // the compiler, so they ALSO land in the pool.
        String e = "hel" + "lo"; // constant-folded at compile time
        System.out.println("a == e (\"hel\" + \"lo\" is constant-folded): " + (a == e));

        // But concatenation involving a NON-constant (a variable) happens at
        // runtime and produces a new object -- it is NOT interned automatically.
        String prefix = "hel";
        String f = prefix + "lo";
        System.out.println("a == f (prefix + \"lo\", built at runtime): " + (a == f));
        System.out.println("a.equals(f): " + a.equals(f));

        System.out.println();
        System.out.println("Rule of thumb: NEVER use == to compare String content.");
        System.out.println("Always use equals() (or equalsIgnoreCase()).");
    }
}
