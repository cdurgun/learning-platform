public class CustomExceptionConstructorsExample {

    // Mirroring the four constructors Throwable itself offers is a common
    // convention -- it lets callers of your exception choose exactly the
    // same shapes they already use with built-in exceptions: no details,
    // a message only, a message with a cause, or a cause only.
    static class ReportGenerationException extends RuntimeException {
        ReportGenerationException() {
            super();
        }

        ReportGenerationException(String message) {
            super(message);
        }

        ReportGenerationException(String message, Throwable cause) {
            super(message, cause);
        }

        ReportGenerationException(Throwable cause) {
            super(cause);
        }
    }

    public static void main(String[] args) {
        try {
            throw new ReportGenerationException("PDF renderer returned no pages");
        } catch (ReportGenerationException e) {
            System.out.println("message-only: " + e.getMessage());
        }

        try {
            Exception original = new IllegalStateException("renderer not initialized");
            throw new ReportGenerationException("report generation failed", original);
        } catch (ReportGenerationException e) {
            System.out.println("message+cause: " + e.getMessage() + " <- " + e.getCause());
        }
    }
}
