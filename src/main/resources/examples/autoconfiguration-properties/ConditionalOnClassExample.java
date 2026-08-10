import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// @ConditionalOnClass is the annotation Spring Boot's own auto-configuration
// classes use dozens of times over: "only register this bean if a given class
// is present on the classpath." Here we use it directly on our own @Bean
// methods, with one class we know for certain IS on the classpath and one
// that is NOT, to see both branches.
@Configuration
class JsonSupportConfig {

    // com.fasterxml.jackson.databind.ObjectMapper really is on the classpath --
    // spring-boot-starter-web brings Jackson in transitively. This bean IS
    // registered.
    @Bean
    @ConditionalOnClass(name = "com.fasterxml.jackson.databind.ObjectMapper")
    String jacksonSupportMarker() {
        return "Jackson support enabled";
    }

    // No such class exists anywhere on the classpath -- this bean is silently
    // skipped, exactly like a real auto-configuration class skips registering
    // (say) a DataSource bean when no JDBC driver is present at all.
    @Bean
    @ConditionalOnClass(name = "com.example.NoSuchLibraryEverInstalled")
    String missingLibrarySupportMarker() {
        return "This should never print";
    }
}

class ConditionalOnClassExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(JsonSupportConfig.class);

        System.out.println(context.containsBean("jacksonSupportMarker"));
        // true
        System.out.println(context.containsBean("missingLibrarySupportMarker"));
        // false

        context.close();
    }
}
