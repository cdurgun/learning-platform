import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;

import java.time.Instant;

// Spring MVC's own lesson used setProperty(...) once, for a single
// "errors" list. ProblemDetail accepts as many custom properties as an
// API needs -- here, a machine-readable error code, a timestamp, and a
// trace id a client can quote back when asking for support, all attached
// to the SAME RFC 7807 body alongside its standard fields.
class CustomProblemDetailPropertiesExample {

    static ProblemDetail insufficientStock(String productId, int requested, int available) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(
                HttpStatus.UNPROCESSABLE_ENTITY,
                "Cannot fulfill the requested quantity");

        problem.setType(java.net.URI.create("https://api.example.com/errors/insufficient-stock"));
        problem.setTitle("Insufficient Stock");
        problem.setProperty("errorCode", "INSUFFICIENT_STOCK");
        problem.setProperty("productId", productId);
        problem.setProperty("requestedQuantity", requested);
        problem.setProperty("availableQuantity", available);
        problem.setProperty("timestamp", Instant.now());
        return problem;
    }

    public static void main(String[] args) {
        ProblemDetail problem = insufficientStock("SKU-42", 10, 3);

        System.out.println(problem.getStatus() + " " + problem.getTitle());
        System.out.println(problem.getProperties());
        // {errorCode=INSUFFICIENT_STOCK, productId=SKU-42, requestedQuantity=10,
        //  availableQuantity=3, timestamp=...}
    }
}
