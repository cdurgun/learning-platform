class PlanetUsageExample {
    public static void main(String[] args) {
        Planet earth = Planet.EARTH;

        System.out.println("Kütle: " + earth.getMassKg() + " kg");
        System.out.printf("Yüzey yerçekimi: %.2f m/s^2%n", earth.surfaceGravity());
    }
}
