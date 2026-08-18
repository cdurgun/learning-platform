import java.text.MessageFormat;
import java.util.ListResourceBundle;
import java.util.Locale;
import java.util.ResourceBundle;

// #{...} is a message expression -- it looks up a key in a locale-specific bundle and
// (optionally) fills in {0}, {1}... placeholders, exactly like this project's own
// messages*.properties + MessageSource setup (see TopicController.buildUnavailableMessage,
// which does the same lookup + formatting by hand for a message that needs different
// word order in Turkish vs. English). Thymeleaf's #{...} is this same mechanism wired
// through an IMessageResolver that, in this project, ultimately delegates to Spring's
// MessageSource -- this example reproduces just the lookup/format part in plain Java,
// without a real Thymeleaf message resolver, to keep the demo focused.
class MessageExpressionExample {

    static class TrBundle extends ListResourceBundle {
        protected Object[][] getContents() {
            return new Object[][]{
                    {"topic.unavailable", "Bu içerik {0} dilinde henüz mevcut değil."}
            };
        }
    }

    static class EnBundle extends ListResourceBundle {
        protected Object[][] getContents() {
            return new Object[][]{
                    {"topic.unavailable", "This content is not yet available in {0}."}
            };
        }
    }

    static String resolve(String key, Locale locale, Object... params) {
        ResourceBundle bundle = locale.getLanguage().equals("tr") ? new TrBundle() : new EnBundle();
        String pattern = bundle.getString(key);
        return MessageFormat.format(pattern, params);
    }

    public static void main(String[] args) {
        System.out.println(resolve("topic.unavailable", Locale.forLanguageTag("tr"), "İngilizce"));
        // Bu içerik İngilizce dilinde henüz mevcut değil.

        System.out.println(resolve("topic.unavailable", Locale.forLanguageTag("en"), "Turkish"));
        // This content is not yet available in Turkish.

        // In a Thymeleaf template, the same lookup is one attribute:
        //   <p th:text="#{topic.unavailable(${languageName})}">...</p>
        // -- no key found for the current locale falls back to "??key??" by default,
        // which is exactly the kind of silent-looking bug worth watching for
        // (see "Common Mistakes").
    }
}
