class SalesReportPipeline extends ReportPipeline {
    @Override
    void validate() {
        System.out.println("[validate] checking sales data...");
    }

    @Override
    void process() {
        System.out.println("[process] aggregating sales totals...");
    }
    // save() and log() are not overridden -- both use ReportPipeline's defaults.
}

class InventoryReportPipeline extends ReportPipeline {
    @Override
    void validate() {
        System.out.println("[validate] checking inventory counts...");
    }

    @Override
    void process() {
        System.out.println("[process] computing stock levels...");
    }

    @Override
    void log() {
        // This pipeline needs a different log step -- and since log() was a
        // concrete (not abstract) hook, overriding it is optional, not required.
        System.out.println("[log] inventory pipeline audited and archived");
    }
}

class ReportPipelineDemo {
    public static void main(String[] args) {
        new SalesReportPipeline().run();
        // [validate] checking sales data...
        // [process] aggregating sales totals...
        // [save] report written to disk
        // [log] pipeline finished for SalesReportPipeline

        System.out.println("---");

        new InventoryReportPipeline().run();
        // [validate] checking inventory counts...
        // [process] computing stock levels...
        // [save] report written to disk
        // [log] inventory pipeline audited and archived
    }
}
