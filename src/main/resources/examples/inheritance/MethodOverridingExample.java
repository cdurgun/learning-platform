class Shape {
    double area() {
        return 0.0;
    }
}

class Circle extends Shape {
    double radius;

    Circle(double radius) {
        this.radius = radius;
    }

    @Override
    double area() {
        return Math.PI * radius * radius;
    }
}

class Rectangle extends Shape {
    double width;
    double height;

    Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }

    @Override
    double area() {
        return width * height;
    }
}

class MethodOverridingExample {
    static void describe(Shape shape) {
        System.out.println("Area: " + shape.area());
    }

    public static void main(String[] args) {
        describe(new Circle(2));       // Area: 12.566370614359172
        describe(new Rectangle(3, 4)); // Area: 12.0
    }
}
