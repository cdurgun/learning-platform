import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.util.HashMap;
import java.util.Map;

// Mini project: a small feature-toggle system, tying together
// @ConfigurationProperties (a whole family of on/off switches, grouped under
// one prefix) with @ConditionalOnProperty (one specific feature deciding, at
// startup, whether an entire bean should exist at all).
@ConfigurationProperties(prefix = "app.features")
class FeatureToggles {
    private Map<String, Boolean> flags = new HashMap<>();

    public Map<String, Boolean> getFlags() { return flags; }
    public void setFlags(Map<String, Boolean> flags) { this.flags = flags; }

    boolean isEnabled(String feature) {
        return flags.getOrDefault(feature, false);
    }
}

interface RecommendationEngine {
    String recommend(String userId);
}

@Configuration
@EnableConfigurationProperties(FeatureToggles.class)
class FeatureToggleConfig {

    // Registered unconditionally -- always available, whatever the feature
    // flags say.
    @Bean
    RecommendationEngine basicRecommendationEngine() {
        return userId -> "Popular items for you, " + userId;
    }

    // Registered only when the property is explicitly turned on. @Primary
    // (from the Component Scanning lesson) resolves the ambiguity when both
    // beans exist: the AI engine wins any plain-type injection whenever it's
    // present at all.
    @Bean
    @Primary
    @ConditionalOnProperty(name = "app.features.ai-recommendations", havingValue = "true")
    RecommendationEngine aiRecommendationEngine() {
        return userId -> "AI-personalized picks for you, " + userId;
    }
}
