class Vehicle {
    String brand;

    Vehicle(String brand) {
        this.brand = brand;
        System.out.println("Vehicle constructor running for " + brand);
    }
}

class Car extends Vehicle {
    int doors;

    Car(String brand, int doors) {
        super(brand); // must be the first statement
        this.doors = doors;
        System.out.println("Car constructor running, doors=" + doors);
    }
}

class ConstructorChainExample {
    public static void main(String[] args) {
        Car car = new Car("Toyota", 4);
        // Output order proves Vehicle's constructor runs FIRST:
        // Vehicle constructor running for Toyota
        // Car constructor running, doors=4
    }
}
