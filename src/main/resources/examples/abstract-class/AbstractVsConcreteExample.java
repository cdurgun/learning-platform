// Shape has ZERO abstract methods -- every method already has a body -- but
// the class itself is still marked `abstract`, so it still cannot be
// instantiated directly. It's the `abstract` keyword on the class, not the
// presence of an abstract method, that blocks `new`.
abstract class Shape {
    double area() {
        return 0;
    }
}

class Square extends Shape {
    private final double side;

    Square(double side) {
        this.side = side;
    }

    @Override
    double area() {
        return side * side;
    }
}

class AbstractVsConcreteExample {
    public static void main(String[] args) {
        // Shape shape = new Shape(); // compile error: Shape is abstract; cannot be instantiated

        Shape shape = new Square(4);
        System.out.println(shape.area()); // 16.0
    }
}
