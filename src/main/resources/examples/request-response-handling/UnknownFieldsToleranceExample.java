import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException;

// Two very different failure modes: a field the JSON is MISSING is usually silently
// null (harmless, unless a lower-level lesson like Validation adds a rule against
// it); a field the JSON has EXTRA that Java doesn't know about is rejected outright,
// by Jackson's default configuration.
class UnknownFieldsToleranceExample {

    record CreateUserRequest(String name, String email) {
    }

    public static void main(String[] args) throws Exception {
        ObjectMapper mapper = new ObjectMapper();

        String missingField = "{\"name\":\"Ayse\"}";
        CreateUserRequest withMissingField = mapper.readValue(missingField, CreateUserRequest.class);
        System.out.println(withMissingField);
        // CreateUserRequest[name=Ayse, email=null]

        String extraField = "{\"name\":\"Ayse\",\"email\":\"ayse@example.com\",\"age\":30}";
        try {
            mapper.readValue(extraField, CreateUserRequest.class);
        } catch (UnrecognizedPropertyException e) {
            System.out.println("Rejected unknown field: " + e.getPropertyName());
            // Rejected unknown field: age
        }
    }
}
