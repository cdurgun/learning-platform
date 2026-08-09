final class ImmutablePoint {
    final int x;
    final int y;

    ImmutablePoint(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

// class SubPoint extends ImmutablePoint { } // compile error: cannot inherit from final ImmutablePoint

class Base {
    final void identify() {
        System.out.println("I am a Base, and this method cannot be overridden");
    }

    void greet() {
        System.out.println("Hello from Base");
    }
}

class Derived extends Base {
    // @Override
    // final void identify() { } // compile error: identify() cannot override final method in Base

    @Override
    void greet() {
        System.out.println("Hello from Derived"); // greet() is NOT final, so overriding it is fine
    }
}

class FinalClassAndMethodExample {
    public static void main(String[] args) {
        Derived derived = new Derived();
        derived.identify(); // inherited as-is, cannot be overridden
        derived.greet();    // overridden version runs
    }
}
