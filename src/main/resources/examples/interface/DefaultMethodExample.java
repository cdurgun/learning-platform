interface Vehicle {
    void start();

    // Added years after Vehicle first shipped: every existing implementer
    // (like Bicycle below) keeps compiling untouched and simply inherits
    // this behavior for free.
    default void honk() {
        System.out.println("Beep!");
    }
}

class Car implements Vehicle {
    @Override
    public void start() {
        System.out.println("Car engine started");
    }
    // No honk() override needed — it uses Vehicle's default.
}

class SportsCar implements Vehicle {
    @Override
    public void start() {
        System.out.println("Sports car engine roars to life");
    }

    // A class is always free to override a default method with its own.
    @Override
    public void honk() {
        System.out.println("HOOONK!");
    }
}

class DefaultMethodExample {
    public static void main(String[] args) {
        Vehicle car = new Car();
        car.start();
        car.honk(); // Beep!

        Vehicle sportsCar = new SportsCar();
        sportsCar.start();
        sportsCar.honk(); // HOOONK!
    }
}
