public class WrapperBasicsExample {
    public static void main(String[] args) {
        // Every primitive type has a corresponding wrapper CLASS: int -> Integer,
        // double -> Double, boolean -> Boolean, char -> Character, long -> Long,
        // short -> Short, byte -> Byte, float -> Float.

        // AUTOBOXING: the compiler automatically wraps a primitive into its
        // wrapper object when one is needed.
        Integer boxedAge = 30; // same as Integer.valueOf(30)
        System.out.println("Autoboxed Integer: " + boxedAge);

        // AUTOUNBOXING: the compiler automatically unwraps a wrapper back into
        // its primitive when a primitive is needed (e.g. in arithmetic).
        int primitiveAge = boxedAge + 1; // same as boxedAge.intValue() + 1
        System.out.println("Autounboxed back to int, +1: " + primitiveAge);

        // Two ways to convert a String to a number: parseXxx() returns a
        // PRIMITIVE, valueOf() returns a WRAPPER OBJECT (using the internal
        // cache when possible -- see the "Integer Caching" section).
        int parsed = Integer.parseInt("42");
        Integer valueOf = Integer.valueOf("42");
        System.out.println("Integer.parseInt(\"42\") (primitive): " + parsed);
        System.out.println("Integer.valueOf(\"42\") (wrapper object): " + valueOf);

        // Each wrapper class carries useful constants describing the primitive's
        // range.
        System.out.println("Integer.MAX_VALUE: " + Integer.MAX_VALUE);
        System.out.println("Integer.MIN_VALUE: " + Integer.MIN_VALUE);
        System.out.println("Double.MAX_VALUE: " + Double.MAX_VALUE);

        // Unlike a primitive, a wrapper reference can be null -- this is
        // actually one of the main reasons wrapper classes exist (see "Why Does
        // It Exist?").
        Integer maybeAge = null;
        System.out.println("A wrapper can be null: " + maybeAge);
    }
}
