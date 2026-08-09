class SimpleContainerDemo {
    public static void main(String[] args) throws ReflectiveOperationException {
        SimpleContainer container = new SimpleContainer();

        Car car = container.resolve(Car.class);
        System.out.println(car.drive()); // Engine started -> Car is driving
    }
}
