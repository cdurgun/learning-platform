// A DTO (Data Transfer Object) is a shape designed for the API contract, not the
// database. Records (see the Record lesson) are a natural fit -- immutable,
// concise, and each one describes exactly one direction of the conversation.
class DtoRecordExample {

    // Request DTO: only what a client is allowed to send. No id (the server assigns
    // it), no passwordHash (the client sends a plain password, the server hashes it).
    record CreateUserRequest(String email, String password) {
    }

    // Response DTO: only what a client is allowed to see. No passwordHash, no
    // internalNotes -- compare with EntityLeakageRiskExample.UserEntity.
    record UserResponse(Long id, String email, java.util.List<String> roles) {
    }

    public static void main(String[] args) {
        CreateUserRequest request = new CreateUserRequest("ada@example.com", "s3cret!");
        System.out.println(request);
        // DtoRecordExample$CreateUserRequest[email=ada@example.com, password=s3cret!]

        UserResponse response = new UserResponse(1L, request.email(), java.util.List.of("USER"));
        System.out.println(response);
        // DtoRecordExample$UserResponse[id=1, email=ada@example.com, roles=[USER]]

        // Two different shapes for two different moments -- CreateUserRequest never
        // has an id (it doesn't exist yet), UserResponse never has a password (it
        // should never come back out). A single shared "User" shape used for both
        // directions can't express either constraint.
    }
}
