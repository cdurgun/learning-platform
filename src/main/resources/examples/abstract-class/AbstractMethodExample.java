abstract class Vehicle {
    abstract void start();
}

// MotorVehicle does NOT implement start() -- and that's perfectly legal,
// because MotorVehicle itself is still declared `abstract`. Only a CONCRETE
// (non-abstract) subclass is forced to implement every inherited abstract
// method; an abstract subclass is free to defer some (or all) of them
// further down the hierarchy.
abstract class MotorVehicle extends Vehicle {
    abstract void refuel();
}

class Car extends MotorVehicle {
    @Override
    void start() {
        System.out.println("Car engine started");
    }

    @Override
    void refuel() {
        System.out.println("Car refueled with gasoline");
    }
}

class AbstractMethodExample {
    public static void main(String[] args) {
        Car car = new Car();
        car.start();
        car.refuel();
    }
}
