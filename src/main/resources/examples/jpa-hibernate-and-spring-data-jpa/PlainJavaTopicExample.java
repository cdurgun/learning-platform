public class PlainJavaTopicExample {

    // A plain Java object -- nothing here says anything about a database.
    // The JVM only knows how to keep this alive in memory; it has no idea
    // "topic" should correspond to a table, or that "title" should
    // correspond to a column.
    static class Topic {
        private Long id;
        private String title;

        Topic(Long id, String title) {
            this.id = id;
            this.title = title;
        }
    }

    public static void main(String[] args) {
        Topic topic = new Topic(1L, "Introduction to Generics");

        // Without any help, "saving" this means hand-writing SQL yourself,
        // and hand-writing it again for every other entity in the
        // application:
        //
        //   String sql = "INSERT INTO topic (id, title) VALUES (?, ?)";
        //   preparedStatement.setLong(1, topic.getId());
        //   preparedStatement.setString(2, topic.getTitle());
        //   preparedStatement.executeUpdate();
        //
        // This is exactly the repetitive, error-prone gap ORM exists to close.
        System.out.println(topic.title);
    }
}
