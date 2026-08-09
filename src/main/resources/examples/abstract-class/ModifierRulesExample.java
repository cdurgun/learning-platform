abstract class Shape {
    public abstract double area();          // legal: public abstract

    protected abstract double perimeter();  // legal: protected abstract

    // private abstract double helper();
    // ILLEGAL: a private method can never be overridden, which directly
    // contradicts what `abstract` requires (a subclass MUST override it).

    // static abstract double unit();
    // ILLEGAL: static methods aren't resolved polymorphically (no dynamic
    // dispatch), so they can't be "overridden" the way abstract requires.

    // abstract final double diagonal();
    // ILLEGAL: `final` forbids overriding, `abstract` requires it --
    // a direct contradiction.
}

// abstract final class Circle { }
// ILLEGAL for the exact same reason: a class can't be simultaneously
// "must be extended to be useful" (abstract) and "can never be extended"
// (final) at the same time.

class Square extends Shape {
    private final double side;

    Square(double side) {
        this.side = side;
    }

    @Override
    public double area() {
        return side * side;
    }

    @Override
    protected double perimeter() {
        return 4 * side;
    }
}

class ModifierRulesExample {
    public static void main(String[] args) {
        Shape shape = new Square(3);
        System.out.println(shape.area()); // 9.0

        // shape.perimeter();
        // Not accessible here: perimeter() is `protected`, and this call
        // site is outside Shape's package and outside any subclass of Shape.
    }
}
