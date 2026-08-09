record PointWithFactory(int x, int y) {

    static final PointWithFactory ORIGIN = new PointWithFactory(0, 0);

    static PointWithFactory origin() {
        return ORIGIN;
    }

    static PointWithFactory of(int x, int y) {
        return new PointWithFactory(x, y);
    }
}
