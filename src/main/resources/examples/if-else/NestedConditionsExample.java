public class NestedConditionsExample {
    public static void main(String[] args) {
        checkLogin("alice", "correct-password");
        checkLogin("unknown-user", "whatever");
        checkLogin("alice", "wrong-password");
    }

    private static void checkLogin(String username, String password) {
        String storedUsername = "alice";
        String storedPassword = "correct-password";

        // An if INSIDE another if's body -- a nested condition. The inner check
        // only runs when the outer one is already true.
        if (username.equals(storedUsername)) {
            if (password.equals(storedPassword)) {
                System.out.println("Login successful for " + username);
            } else {
                System.out.println("Wrong password for " + username);
            }
        } else {
            System.out.println("No such user: " + username);
        }
    }
}
