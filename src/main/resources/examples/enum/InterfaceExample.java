interface Describable {
    String describe();
}

enum TrafficLight implements Describable {
    RED, YELLOW, GREEN;

    @Override
    public String describe() {
        return "Trafik ışığı: " + name();
    }
}
