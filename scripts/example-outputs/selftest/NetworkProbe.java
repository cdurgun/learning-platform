import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;

// Sandbox self-test: outbound network access must be impossible (--network none).
class NetworkProbe {
    public static void main(String[] args) {
        boolean open = false;
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress("1.1.1.1", 53), 2000);
            open = true;
        } catch (Exception expected) {
        }
        try {
            InetAddress.getByName("example.com");
            open = true;
        } catch (Exception expected) {
        }
        System.out.println(open ? "network: OPEN" : "network: blocked");
    }
}
