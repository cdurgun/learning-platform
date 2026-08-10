import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.AnnotationUtils;

// @SpringBootApplication is a convenience annotation: it is itself meta-annotated
// with three annotations we can already recognize. This file proves that
// composition with reflection, the same way StereotypeAnnotationsExample (in the
// Component Scanning lesson) proved @Service carries @Component underneath.
@SpringBootApplication
class DemoApplication {
}

class SpringBootApplicationExample {
    public static void main(String[] args) {
        boolean carriesSpringBootConfiguration =
                AnnotationUtils.findAnnotation(DemoApplication.class, SpringBootConfiguration.class) != null;
        boolean carriesEnableAutoConfiguration =
                AnnotationUtils.findAnnotation(DemoApplication.class, EnableAutoConfiguration.class) != null;
        boolean carriesComponentScan =
                AnnotationUtils.findAnnotation(DemoApplication.class, ComponentScan.class) != null;

        System.out.println("Carries @SpringBootConfiguration: " + carriesSpringBootConfiguration);
        // Carries @SpringBootConfiguration: true
        System.out.println("Carries @EnableAutoConfiguration: " + carriesEnableAutoConfiguration);
        // Carries @EnableAutoConfiguration: true
        System.out.println("Carries @ComponentScan: " + carriesComponentScan);
        // Carries @ComponentScan: true

        // @SpringBootConfiguration is itself meta-annotated with @Configuration --
        // that's exactly why a @SpringBootApplication-annotated class (like this
        // project's own LearningPlatformApplication) can be passed directly to
        // an ApplicationContext, wherever a @Configuration class is expected.
        boolean springBootConfigurationIsConfiguration =
                AnnotationUtils.findAnnotation(SpringBootConfiguration.class, Configuration.class) != null;
        System.out.println("@SpringBootConfiguration carries @Configuration: " + springBootConfigurationIsConfiguration);
        // @SpringBootConfiguration carries @Configuration: true
    }
}
