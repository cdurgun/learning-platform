class Vehicle {
    String brand;

    Vehicle(String brand) {
        this.brand = brand;
    }

    @Override
    public String toString() {
        return brand;
    }
}

class MotorVehicle extends Vehicle {
    int horsePower;

    MotorVehicle(String brand, int horsePower) {
        super(brand);
        this.horsePower = horsePower;
    }

    void revEngine() {
        System.out.println(brand + " engine revving at " + horsePower + " hp");
    }

    @Override
    public String toString() {
        return super.toString() + " (" + horsePower + " hp)";
    }
}

class Car extends MotorVehicle {
    int doors;

    Car(String brand, int horsePower, int doors) {
        super(brand, horsePower);
        this.doors = doors;
    }

    @Override
    public String toString() {
        return super.toString() + ", " + doors + " doors";
    }
}

class Motorcycle extends MotorVehicle {
    boolean hasSidecar;

    Motorcycle(String brand, int horsePower, boolean hasSidecar) {
        super(brand, horsePower);
        this.hasSidecar = hasSidecar;
    }

    @Override
    public String toString() {
        return super.toString() + (hasSidecar ? " with sidecar" : " no sidecar");
    }
}
