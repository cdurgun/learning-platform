class MessageConverterDemo {
    public static void main(String[] args) throws Exception {
        MessageConverterSimulation converters = new MessageConverterSimulation();

        MessageConverterSimulation.Product product = converters.read("{\"name\":\"Keyboard\",\"price\":49.9}");
        System.out.println(product);
        // Product[name=Keyboard, price=49.9]

        System.out.println(converters.write(product, "application/json"));
        // {"name":"Keyboard","price":49.9}
        System.out.println(converters.write(product, "application/xml"));
        // <product><name>Keyboard</name><price>49.9</price></product>
        System.out.println(converters.write(product, "text/csv"));
        // 406 Not Acceptable: text/csv
    }
}
