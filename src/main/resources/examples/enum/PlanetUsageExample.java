class PlanetUsageExample {
    public static void main(String[] args) {
        Planet earth = Planet.EARTH;

        System.out.println("Mass: " + earth.getMassKg() + " kg");
        System.out.printf("Surface gravity: %.2f m/s^2%n", earth.surfaceGravity());
    }
}
