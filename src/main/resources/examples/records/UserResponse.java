import java.time.Instant;

record UserResponse(Long id, String fullName, String email, Instant createdAt) {

    // Static factory: a common pattern for keeping the entity -> response
    // conversion in one place (the same pattern we saw in "Static Members").
    static UserResponse from(Long id, String fullName, String email, Instant createdAt) {
        return new UserResponse(id, fullName, email, createdAt);
    }
}
