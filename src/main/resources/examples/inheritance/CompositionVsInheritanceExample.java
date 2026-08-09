class Engine {
    void start() {
        System.out.println("Engine starting...");
    }

    void stop() {
        System.out.println("Engine stopping...");
    }
}

// Inheritance approach: Car "is-a" Engine -- semantically wrong, and Car
// exposes every one of Engine's public methods whether it makes sense or not.
class CarWithInheritance extends Engine {
}

// Composition approach: Car "has-a" Engine -- Car controls exactly which
// Engine behavior it exposes, and can swap the engine implementation freely.
class CarWithComposition {
    private final Engine engine;

    CarWithComposition(Engine engine) {
        this.engine = engine;
    }

    void drive() {
        engine.start(); // delegation -- Car forwards to its Engine
        System.out.println("Car driving...");
    }
}

class CompositionVsInheritanceExample {
    public static void main(String[] args) {
        CarWithInheritance carA = new CarWithInheritance();
        carA.start(); // works, but semantically odd -- a Car IS an Engine?

        CarWithComposition carB = new CarWithComposition(new Engine());
        carB.drive(); // Engine starting... / Car driving...
    }
}
