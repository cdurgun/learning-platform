record ComparablePointExample(int x, int y) implements Comparable<ComparablePointExample> {

    // Ordering rule: x first, then y if equal (simple lexicographic order).
    @Override
    public int compareTo(ComparablePointExample other) {
        int byX = Integer.compare(x, other.x);
        return byX != 0 ? byX : Integer.compare(y, other.y);
    }
}
