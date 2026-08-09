class AppException extends Exception {
    AppException(String message) {
        super(message);
    }
}

class ValidationException extends AppException {
    ValidationException(String message) {
        super(message);
    }
}

class NotFoundException extends AppException {
    NotFoundException(String message) {
        super(message);
    }
}

class RealWorldHierarchyExample {
    static void handle(AppException e) {
        // One catch site handles every subtype, exactly like catching java.io.IOException
        // handles FileNotFoundException, EOFException, and every other subtype.
        System.out.println("Handled: " + e.getMessage());
    }

    public static void main(String[] args) {
        handle(new ValidationException("email is invalid"));
        handle(new NotFoundException("user not found"));
    }
}
