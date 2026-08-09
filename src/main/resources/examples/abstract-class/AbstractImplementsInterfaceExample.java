interface Auditable {
    String auditLog();
}

// An abstract class that implements an interface is NOT required to provide
// bodies for that interface's methods -- it can leave auditLog() unimplemented
// and defer it to its own concrete subclasses, exactly the way it defers its
// own abstract methods like content().
abstract class Document implements Auditable {
    protected String title;

    Document(String title) {
        this.title = title;
    }

    abstract String content();
    // auditLog() from Auditable is inherited as still-abstract here --
    // Document compiles fine without implementing it.
}

class Report extends Document {
    Report(String title) {
        super(title);
    }

    @Override
    String content() {
        return "Q3 sales figures...";
    }

    @Override
    public String auditLog() {
        return "Report '" + title + "' was accessed";
    }
}

class AbstractImplementsInterfaceExample {
    public static void main(String[] args) {
        Document document = new Report("Q3 Report");
        System.out.println(document.content());  // Q3 sales figures...
        System.out.println(document.auditLog());  // Report 'Q3 Report' was accessed
    }
}
