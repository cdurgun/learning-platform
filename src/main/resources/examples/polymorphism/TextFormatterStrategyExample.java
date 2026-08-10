interface TextFormatter {
    String format(String text);
}

class UpperCaseFormatter implements TextFormatter {
    @Override
    public String format(String text) {
        return text.toUpperCase();
    }
}

class ReverseFormatter implements TextFormatter {
    @Override
    public String format(String text) {
        return new StringBuilder(text).reverse().toString();
    }
}

class Document {
    private TextFormatter formatter; // composition -- holds a strategy, doesn't implement one

    Document(TextFormatter formatter) {
        this.formatter = formatter;
    }

    void setFormatter(TextFormatter formatter) {
        this.formatter = formatter; // behavior can change at runtime
    }

    String render(String text) {
        return formatter.format(text); // delegates -- doesn't know WHICH formatter it's using
    }
}

class TextFormatterStrategyExample {
    public static void main(String[] args) {
        Document doc = new Document(new UpperCaseFormatter());
        System.out.println(doc.render("hello")); // HELLO

        doc.setFormatter(new ReverseFormatter()); // swap strategy at runtime
        System.out.println(doc.render("hello")); // olleh
    }
}
