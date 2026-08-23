public class GenericInterfaceExample {

    // A generic interface: the type parameter T flows through the method
    // signatures exactly like it would in a generic class.
    interface Repository<T> {
        void save(T item);
        T findLatest();
    }

    // A concrete class implementing the interface supplies a real type
    // argument -- every method in the implementation now deals with
    // Order specifically, no casting required anywhere.
    static class InMemoryOrderRepository implements Repository<Order> {
        private Order latest;

        @Override
        public void save(Order item) {
            latest = item;
        }

        @Override
        public Order findLatest() {
            return latest;
        }
    }

    record Order(int id, double total) {
    }

    public static void main(String[] args) {
        Repository<Order> repository = new InMemoryOrderRepository();
        repository.save(new Order(1, 49.99));

        Order latest = repository.findLatest(); // already an Order, no cast
        System.out.println(latest);
    }
}
