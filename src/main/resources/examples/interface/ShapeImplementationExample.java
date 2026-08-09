interface Shape {
    double area();

    double perimeter();
}

class Circle implements Shape {
    private final double radius;

    Circle(double radius) {
        this.radius = radius;
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }

    @Override
    public double perimeter() {
        return 2 * Math.PI * radius;
    }
}

class Rectangle implements Shape {
    private final double width;
    private final double height;

    Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }

    @Override
    public double area() {
        return width * height;
    }

    @Override
    public double perimeter() {
        return 2 * (width + height);
    }
}

class ShapeImplementationExample {
    public static void main(String[] args) {
        // Polymorphism through the interface reference: neither line below
        // needs to know whether it's holding a Circle or a Rectangle.
        Shape[] shapes = { new Circle(3), new Rectangle(4, 5) };

        for (Shape shape : shapes) {
            System.out.printf("area=%.2f perimeter=%.2f%n", shape.area(), shape.perimeter());
        }
        // area=28.27 perimeter=18.85
        // area=20.00 perimeter=18.00
    }
}
