import org.springframework.web.cors.CorsConfiguration;

// Same-origin policy: a browser blocks a page at origin A (scheme+host+port) from
// reading a response from origin B, unless B's server explicitly allows it via CORS
// (Cross-Origin Resource Sharing) response headers. For "unsafe" requests (anything
// other than a simple GET/HEAD/POST with a plain content type), the browser sends a
// preflight OPTIONS request FIRST, asking "would you allow this?" -- and only sends
// the real request if the answer is yes. Spring's CorsConfiguration is the object
// that answers that question; this example uses it directly, no HTTP involved.
class CorsPreflightExample {

    public static void main(String[] args) {
        CorsConfiguration config = new CorsConfiguration();
        config.addAllowedOrigin("https://learning-platform.example.com");
        config.addAllowedMethod("GET");
        config.addAllowedMethod("POST");
        config.addAllowedHeader("Content-Type");

        // checkOrigin returns the allowed origin to echo back in the response header,
        // or null if this origin isn't allowed at all.
        System.out.println(config.checkOrigin("https://learning-platform.example.com"));
        // https://learning-platform.example.com

        System.out.println(config.checkOrigin("https://evil.example.com"));
        // null -- browser will block the response from reaching JavaScript

        // checkHttpMethod returns the allowed methods, or null if the requested one
        // (what the preflight's Access-Control-Request-Method asked about) isn't allowed.
        System.out.println(config.checkHttpMethod("DELETE"));
        // null -- DELETE was never added as an allowed method
    }
}
