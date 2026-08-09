record Measurement(double value) {
}

class EqualsSemanticsExample {
    public static void main(String[] args) {
        Measurement a = new Measurement(Double.NaN);
        Measurement b = new Measurement(Double.NaN);

        System.out.println(Double.NaN == Double.NaN);   // false — primitive ==
        System.out.println(a.equals(b));                // true  — Double.compare semantics
        System.out.println(a.value() == b.value());      // false — the accessor still returns a primitive double
    }
}
