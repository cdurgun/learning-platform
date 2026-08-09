abstract class DataProcessor {
    // The "template method" -- it defines the FIXED skeleton of the
    // algorithm, marked `final` so no subclass can ever change the order
    // (or skip a step); only the individual steps below are customizable.
    final void process() {
        validate();
        transform();
        save();
    }

    abstract void validate();

    abstract void transform();

    // A default step with a body -- subclasses may override it if they need
    // to, but most won't have to.
    void save() {
        System.out.println("Saved.");
    }
}

class CsvProcessor extends DataProcessor {
    @Override
    void validate() {
        System.out.println("Validating CSV structure...");
    }

    @Override
    void transform() {
        System.out.println("Transforming CSV rows...");
    }
}

class TemplateMethodExample {
    public static void main(String[] args) {
        DataProcessor processor = new CsvProcessor();
        processor.process();
        // Validating CSV structure...
        // Transforming CSV rows...
        // Saved.
    }
}
