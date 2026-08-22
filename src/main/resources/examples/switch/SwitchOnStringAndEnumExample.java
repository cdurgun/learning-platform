public class SwitchOnStringAndEnumExample {

    enum Role { ADMIN, EDITOR, VIEWER }

    public static void main(String[] args) {
        System.out.println(permissionsFor("admin"));
        System.out.println(permissionsFor("editor"));
        System.out.println(permissionsFor("guest"));

        System.out.println(roleLabel(Role.ADMIN));
        System.out.println(roleLabel(Role.VIEWER));
    }

    // Switching on a String compares by CONTENT (like .equals(), not ==) --
    // no need to worry about the == vs equals() trap from the "Comparison
    // Operators" section of the if / else lesson.
    private static String permissionsFor(String role) {
        return switch (role) {
            case "admin" -> "read, write, delete";
            case "editor" -> "read, write";
            default -> "read only";
        };
    }

    private static String roleLabel(Role role) {
        return switch (role) {
            case ADMIN -> "Administrator";
            case EDITOR -> "Editor";
            case VIEWER -> "Viewer";
        };
    }
}
