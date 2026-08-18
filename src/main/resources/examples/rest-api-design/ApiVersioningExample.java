import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

// Two common ways to version a REST API. Neither needs a new mechanism -- both
// reuse tools this project already knows: @GetMapping's path (Mapping Annotations
// and HTTP Methods) for URI versioning, @RequestHeader (Path Variables and Request
// Parameters) for header versioning.
@RestController
class ApiVersioningExample {

    // URI versioning: the version is part of the path itself -- impossible to miss,
    // easy to route differently, but "v1"/"v2" leak into every client's URLs forever.
    @GetMapping("/api/v1/topics/{slug}")
    public String getTopicV1(String slug) {
        return "{\"slug\":\"" + slug + "\"}"; // v1 shape: flat
    }

    @GetMapping("/api/v2/topics/{slug}")
    public String getTopicV2(String slug) {
        return "{\"slug\":\"" + slug + "\",\"links\":{}}"; // v2 shape: adds a field
    }

    // Header versioning: the URL never changes -- one @GetMapping, the version comes
    // from a request header instead.
    @GetMapping("/api/topics/{slug}")
    public String getTopic(String slug, @RequestHeader(name = "Api-Version", defaultValue = "1") int apiVersion) {
        return apiVersion >= 2
                ? "{\"slug\":\"" + slug + "\",\"links\":{}}"
                : "{\"slug\":\"" + slug + "\"}";
    }

    public static void main(String[] args) {
        ApiVersioningExample controller = new ApiVersioningExample();

        System.out.println(controller.getTopicV1("advanced-spring-mvc"));
        // {"slug":"advanced-spring-mvc"}
        System.out.println(controller.getTopicV2("advanced-spring-mvc"));
        // {"slug":"advanced-spring-mvc","links":{}}

        System.out.println(controller.getTopic("advanced-spring-mvc", 1));
        // {"slug":"advanced-spring-mvc"}
        System.out.println(controller.getTopic("advanced-spring-mvc", 2));
        // {"slug":"advanced-spring-mvc","links":{}}
    }
}
