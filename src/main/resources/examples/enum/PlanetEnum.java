enum Planet {
    MERCURY(3.303e+23, 2.4397e6),
    VENUS(4.869e+24, 6.0518e6),
    EARTH(5.976e+24, 6.37814e6);

    private final double massKg;
    private final double radiusM;

    // Constructor her zaman private (ya da paket-private) olmak zorunda —
    // enum sabitleri yalnızca yukarıdaki tanım satırında, enum'un kendisi
    // tarafından "inşa edilir".
    Planet(double massKg, double radiusM) {
        this.massKg = massKg;
        this.radiusM = radiusM;
    }

    public double getMassKg() {
        return massKg;
    }

    public double getRadiusM() {
        return radiusM;
    }

    public double surfaceGravity() {
        final double gravitationalConstant = 6.67300E-11;
        return gravitationalConstant * massKg / (radiusM * radiusM);
    }
}
