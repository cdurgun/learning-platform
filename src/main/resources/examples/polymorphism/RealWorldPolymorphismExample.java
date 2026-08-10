interface DataSource {
    String readData();
}

class FileDataSource implements DataSource {
    @Override
    public String readData() {
        return "data read from a file";
    }
}

class MemoryDataSource implements DataSource {
    private String data;

    MemoryDataSource(String data) {
        this.data = data;
    }

    @Override
    public String readData() {
        return data;
    }
}

class RealWorldPolymorphismExample {
    // Mirrors how code that reads from an InputStream never cares about the real source
    static void readAll(DataSource source) {
        System.out.println(source.readData());
    }

    public static void main(String[] args) {
        readAll(new FileDataSource());             // data read from a file
        readAll(new MemoryDataSource("in-memory")); // in-memory
    }
}
