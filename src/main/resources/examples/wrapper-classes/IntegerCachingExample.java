public class IntegerCachingExample {
    public static void main(String[] args) {
        // The JVM caches Integer objects for values from -128 to 127 (the
        // "Integer Cache") -- Integer.valueOf() (which autoboxing calls
        // internally) returns the SAME cached object for any value in that
        // range, instead of creating a new one every time.
        Integer a = 100;
        Integer b = 100;
        System.out.println("a == b for 100 (inside the cache, -128..127): " + (a == b));

        // Outside that range, autoboxing creates a BRAND-NEW object every time
        // -- so == compares references that are no longer the same, even
        // though the values are equal.
        Integer c = 200;
        Integer d = 200;
        System.out.println("c == d for 200 (OUTSIDE the cache): " + (c == d));
        System.out.println("c.equals(d): " + c.equals(d));

        System.out.println();
        System.out.println("This is EXACTLY the same trap as the String pool ('==' vs 'equals()'");
        System.out.println("in the \"String\" lesson) -- just triggered by a value range instead of");
        System.out.println("literal vs. new String(...). Rule of thumb: NEVER use == to compare");
        System.out.println("wrapper objects -- always use equals() (or unbox to a primitive first).");

        // Unboxing to a primitive sidesteps the whole issue, because primitive
        // == compares VALUES, not references.
        int cPrimitive = c;
        int dPrimitive = d;
        System.out.println("cPrimitive == dPrimitive (primitive int, always value comparison): "
                + (cPrimitive == dPrimitive));
    }
}
