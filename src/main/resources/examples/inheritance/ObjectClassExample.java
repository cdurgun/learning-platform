import java.util.Objects;

class Point {
    int x;
    int y;

    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    @Override
    public String toString() {
        return "Point(" + x + ", " + y + ")";
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) return true;
        if (!(other instanceof Point)) return false;
        Point p = (Point) other;
        return x == p.x && y == p.y;
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
}

class ObjectClassExample {
    public static void main(String[] args) {
        Point p1 = new Point(1, 2);
        Point p2 = new Point(1, 2);

        System.out.println(p1);                              // Point(1, 2) -- uses overridden toString()
        System.out.println(p1.equals(p2));                    // true -- same x,y, overridden equals()
        System.out.println(p1.hashCode() == p2.hashCode());   // true -- required when equals() is true
    }
}
