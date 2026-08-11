import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.lang.annotation.Annotation;
import java.lang.reflect.Method;

// @CrossOrigin is the per-controller/per-method alternative to a global CORS config --
// Spring reads it with reflection at startup (the same mechanism the Reflection lesson
// covered) and builds a CorsConfiguration from its attributes, exactly like the one
// CorsPreflightExample builds by hand.
@RestController
class CrossOriginAnnotationExample {

    @CrossOrigin(origins = "https://learning-platform.example.com", methods = {
            org.springframework.web.bind.annotation.RequestMethod.GET})
    @GetMapping("/api/topics")
    public String listTopics() {
        return "[]";
    }

    public static void main(String[] args) throws NoSuchMethodException {
        Method method = CrossOriginAnnotationExample.class.getMethod("listTopics");
        CrossOrigin annotation = method.getAnnotation(CrossOrigin.class);

        System.out.println("origins: " + java.util.Arrays.toString(annotation.origins()));
        // origins: [https://learning-platform.example.com]
        System.out.println("methods: " + java.util.Arrays.toString(annotation.methods()));
        // methods: [GET]

        // This is conceptually all Spring itself does at startup: scan each handler
        // method for a @CrossOrigin (via getAnnotation, just like above), and if
        // present, register a matching CorsConfiguration for that mapping.
        Annotation[] all = method.getAnnotations();
        System.out.println("total annotations on listTopics: " + all.length);
        // total annotations on listTopics: 2  -- @CrossOrigin and @GetMapping
    }
}
