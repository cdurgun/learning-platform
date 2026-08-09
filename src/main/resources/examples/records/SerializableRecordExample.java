import java.io.*;

record Score(String player, int points) implements Serializable {

    // The validation in the compact constructor also runs during deserialization --
    // unlike a classic class, where a custom readObject() could bypass it.
    Score {
        if (points < 0) {
            throw new IllegalArgumentException("points negatif olamaz: " + points);
        }
    }
}

class SerializableRecordExampleUsage {
    public static void main(String[] args) throws Exception {
        Score original = new Score("Ada", 100);

        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        try (ObjectOutputStream out = new ObjectOutputStream(bytes)) {
            out.writeObject(original);
        }

        Score restored;
        try (ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bytes.toByteArray()))) {
            restored = (Score) in.readObject();
        }

        System.out.println(restored);                  // Score[player=Ada, points=100]
        System.out.println(original.equals(restored));  // true
    }
}
