import java.util.LinkedHashMap;
import java.util.Map;

// HATEOAS (Hypermedia as the Engine of Application State): a response includes not
// just data, but the LINKS a client can follow next -- the API guides the client,
// instead of the client having to hard-code every URL it might ever need. This
// project doesn't use the real `spring-hateoas` library (it isn't a dependency
// here), so this example hand-builds the same shape a real HATEOAS response has,
// to show the idea without adding a library this project doesn't otherwise need.
class HateoasConceptExample {

    record TopicResponse(String slug, String title, Map<String, String> links) {
    }

    static TopicResponse toResponseWithLinks(String slug, String title, String previousSlug, String nextSlug) {
        Map<String, String> links = new LinkedHashMap<>();
        links.put("self", "/api/topics/" + slug);
        if (previousSlug != null) {
            links.put("previous", "/api/topics/" + previousSlug);
        }
        if (nextSlug != null) {
            links.put("next", "/api/topics/" + nextSlug);
        }
        return new TopicResponse(slug, title, links);
    }

    public static void main(String[] args) {
        TopicResponse response = toResponseWithLinks(
                "advanced-spring-mvc", "Advanced Spring MVC",
                "spring-mvc-views-thymeleaf", "rest-api-design");

        System.out.println(response);
        // TopicResponse[slug=advanced-spring-mvc, title=Advanced Spring MVC,
        //   links={self=/api/topics/advanced-spring-mvc,
        //          previous=/api/topics/spring-mvc-views-thymeleaf,
        //          next=/api/topics/rest-api-design}]

        // A client following "next" never needs to know this project's URL scheme
        // (/api/topics/{slug}) -- it just follows the link the server gave it. This
        // project's own topic.html does the conceptual equivalent server-side
        // (previousTopic/nextTopic in TopicController), just rendered as HTML
        // <a> tags instead of a JSON "links" map.
    }
}
