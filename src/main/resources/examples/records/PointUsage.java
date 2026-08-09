class PointUsage {
    public static void main(String[] args) {
        Point p1 = new Point(3, 4);
        Point p2 = new Point(3, 4);

        System.out.println(p1);                          // Point[x=3, y=4]
        System.out.println("x koordinati: " + p1.x());   // x koordinati: 3
        System.out.println(p1.equals(p2));                // true
        System.out.println(p1 == p2);                      // false — two different objects
    }
}
