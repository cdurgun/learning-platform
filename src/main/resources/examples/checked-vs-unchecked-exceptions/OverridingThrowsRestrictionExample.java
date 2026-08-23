import java.io.FileNotFoundException;
import java.io.IOException;

// When overriding a method, you may declare FEWER (or NARROWER) checked exceptions
// than the method you're overriding -- but never MORE, and never a BROADER checked
// exception type. This is enforced by the compiler, not just a convention.
public class OverridingThrowsRestrictionExample {
    interface SettingsSource {
        String read(String key) throws IOException;
    }

    // Narrows IOException down to FileNotFoundException (one of its subclasses) --
    // legal, because any caller that already handles IOException also handles this.
    static class StrictSettingsSource implements SettingsSource {
        @Override
        public String read(String key) throws FileNotFoundException {
            if (key.equals("missing")) {
                throw new FileNotFoundException("setting not found: " + key);
            }
            return "30s";
        }
    }

    // Drops the `throws` clause entirely -- also legal, since declaring nothing is
    // narrower than declaring IOException.
    static class InMemorySettingsSource implements SettingsSource {
        @Override
        public String read(String key) {
            return "30s";
        }
    }

    public static void main(String[] args) throws IOException {
        SettingsSource source = new StrictSettingsSource();
        System.out.println(source.read("timeout"));

        SettingsSource memorySource = new InMemorySettingsSource();
        System.out.println(memorySource.read("timeout"));

        // If StrictSettingsSource.read tried to declare `throws Exception` (broader
        // than IOException), this file would NOT compile -- the restriction is
        // checked by the compiler at the override site, not at any call site.
    }
}
