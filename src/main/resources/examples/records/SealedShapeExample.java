sealed interface Shape permits Circle, Rectangle, Square {
}

record Circle(double radius) implements Shape {
}

record Rectangle(double width, double height) implements Shape {
}

record Square(double side) implements Shape {
}

class SealedShapeExample {

    static double area(Shape shape) {
        return switch (shape) {
            case Circle(double r) -> Math.PI * r * r;
            case Rectangle(double w, double h) -> w * h;
            case Square(double s) -> s * s;
        };
    }

    public static void main(String[] args) {
        System.out.printf("%.2f%n", area(new Circle(2)));      // 12.57
        System.out.println(area(new Rectangle(3, 4)));          // 12.0
        System.out.println(area(new Square(5)));                // 25.0
    }
}
