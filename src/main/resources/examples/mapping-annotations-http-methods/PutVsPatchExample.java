import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.LinkedHashMap;
import java.util.Map;

// PUT replaces the ENTIRE resource -- every field must be supplied, missing fields
// are lost. PATCH updates only the fields that were actually sent, leaving the rest
// untouched.
@Controller
class UserProfileController {
    private final Map<String, String> profile = new LinkedHashMap<>();

    UserProfileController() {
        profile.put("name", "Ayse");
        profile.put("city", "Istanbul");
    }

    @PutMapping("/profile")
    @ResponseBody
    public Map<String, String> replace(@RequestBody Map<String, String> newProfile) {
        profile.clear();
        profile.putAll(newProfile); // anything not in newProfile is gone
        return new LinkedHashMap<>(profile); // a copy that keeps insertion order for display
    }

    @PatchMapping("/profile")
    @ResponseBody
    public Map<String, String> update(@RequestBody Map<String, String> changes) {
        profile.putAll(changes); // only overwrites the given keys
        return new LinkedHashMap<>(profile); // a copy that keeps insertion order for display
    }
}

class PutVsPatchExample {
    public static void main(String[] args) {
        UserProfileController controller = new UserProfileController();

        System.out.println(controller.update(Map.of("city", "Ankara")));
        // {name=Ayse, city=Ankara} -- PATCH: only "city" changed, "name" untouched

        System.out.println(controller.replace(Map.of("city", "Izmir")));
        // {city=Izmir} -- PUT: "name" is GONE, it wasn't in the replacement body
    }
}
