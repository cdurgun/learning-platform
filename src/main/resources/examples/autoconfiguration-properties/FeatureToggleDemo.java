import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.Map;

class FeatureToggleDemo {
    public static void main(String[] args) {
        // Two independent property paths under the same "app.features" prefix:
        // "flags.ai-recommendations" binds into FeatureToggles' Map field (for
        // the application's own bookkeeping/UI), while the flat
        // "ai-recommendations" key separately drives @ConditionalOnProperty
        // on the bean itself. They happen to carry the same value here, but
        // they are two different mechanisms answering two different questions.

        // Case 1: AI recommendations turned off -- only the basic engine exists.
        AnnotationConfigApplicationContext offContext = new AnnotationConfigApplicationContext();
        ConfigurableEnvironment offEnv = offContext.getEnvironment();
        offEnv.getPropertySources().addFirst(new MapPropertySource("test", Map.of(
                "app.features.flags.ai-recommendations", "false",
                "app.features.ai-recommendations", "false"
        )));
        offContext.register(FeatureToggleConfig.class);
        offContext.refresh();
        System.out.println(offContext.getBean(FeatureToggles.class).isEnabled("ai-recommendations"));
        // false
        System.out.println(offContext.getBean(RecommendationEngine.class).recommend("user-42"));
        // Popular items for you, user-42
        offContext.close();

        // Case 2: AI recommendations turned on -- both beans exist, @Primary
        // decides which one wins the ambiguous injection.
        AnnotationConfigApplicationContext onContext = new AnnotationConfigApplicationContext();
        ConfigurableEnvironment onEnv = onContext.getEnvironment();
        onEnv.getPropertySources().addFirst(new MapPropertySource("test", Map.of(
                "app.features.flags.ai-recommendations", "true",
                "app.features.ai-recommendations", "true"
        )));
        onContext.register(FeatureToggleConfig.class);
        onContext.refresh();
        System.out.println(onContext.getBean(FeatureToggles.class).isEnabled("ai-recommendations"));
        // true
        System.out.println(onContext.getBean(RecommendationEngine.class).recommend("user-42"));
        // AI-personalized picks for you, user-42
        onContext.close();
    }
}
