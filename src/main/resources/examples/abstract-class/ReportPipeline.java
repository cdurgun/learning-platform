// A reusable Template Method skeleton: every report goes through the same
// four fixed steps, in the same fixed order -- only validate() and
// process() are mandatory for a subclass to fill in; save() and log() are
// optional hooks with sensible defaults.
abstract class ReportPipeline {
    final void run() {
        validate();
        process();
        save();
        log();
    }

    abstract void validate();

    abstract void process();

    void save() {
        System.out.println("[save] report written to disk");
    }

    void log() {
        System.out.println("[log] pipeline finished for " + getClass().getSimpleName());
    }
}
