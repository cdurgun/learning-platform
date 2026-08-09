class VehicleHierarchyDemo {
    public static void main(String[] args) {
        Vehicle[] vehicles = {
            new Car("Toyota", 150, 4),
            new Motorcycle("Harley-Davidson", 90, false)
        };

        for (Vehicle v : vehicles) {
            System.out.println(v); // uses each subclass's overridden toString()

            if (v instanceof MotorVehicle motorVehicle) {
                motorVehicle.revEngine(); // safe downcast, all vehicles here are motorized
            }

            if (v instanceof Car car) {
                System.out.println("It's a car with " + car.doors + " doors");
            } else if (v instanceof Motorcycle motorcycle) {
                System.out.println("It's a motorcycle, sidecar: " + motorcycle.hasSidecar);
            }
        }
    }
}
