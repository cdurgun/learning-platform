interface ClickHandler {
    void onClick(String source);
}

// Same functional interface, two ways to provide an implementation -- side by side,
// to make both the syntax reduction and the "this" difference concrete.
class AnonymousClassVsLambdaExample {

    private final String owner = "AnonymousClassVsLambdaExample";

    void demoThis() {
        // Anonymous inner class: creates a REAL, separate class -- "this" inside its
        // body refers to the anonymous class instance itself.
        ClickHandler anonymous = new ClickHandler() {
            @Override
            public void onClick(String source) {
                System.out.println("anonymous this: " + this.getClass().getName());
            }
        };

        // Lambda: does NOT create a new class in that same sense -- "this" inside a
        // lambda body is inherited from the ENCLOSING scope, exactly as if the
        // lambda's body were pasted directly into the surrounding method.
        ClickHandler lambda = source -> System.out.println("lambda this: " + this.owner);

        anonymous.onClick("button");
        lambda.onClick("button");
    }

    public static void main(String[] args) {
        new AnonymousClassVsLambdaExample().demoThis();
    }
}
