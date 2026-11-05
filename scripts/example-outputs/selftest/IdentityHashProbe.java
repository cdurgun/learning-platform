import com.sun.management.HotSpotDiagnosticMXBean;
import java.lang.management.ManagementFactory;
import java.util.TreeSet;

// Sandbox self-test for the identity-hash variant (-XX:hashCode=2): unlike IdentityProbe (which
// checks the user the program runs as), this checks the identity HASH itself. Under hashCode=2
// every identity hash is 1, so Object.toString text ("Object@1") differs from the base runs and
// generate reports such an example as NONDETERMINISTIC instead of staging it.
class IdentityHashProbe {
    public static void main(String[] args) {
        String mode;
        try {
            mode = ManagementFactory.getPlatformMXBean(HotSpotDiagnosticMXBean.class).getVMOption("hashCode").getValue();
        } catch (IllegalArgumentException e) {
            mode = "unavailable";
        }
        TreeSet<Integer> hashes = new TreeSet<>();
        for (int i = 0; i < 16; i++) {
            hashes.add(System.identityHashCode(new Object()));
        }
        Object probe = new Object();
        String text = probe.toString();
        boolean consistent = text.equals("java.lang.Object@" + Integer.toHexString(System.identityHashCode(probe)));
        System.out.println("identity-hash: mode=" + mode + " distinct=" + hashes.size()
                + " allOne=" + (hashes.size() == 1 && hashes.first() == 1)
                + " text=" + (text.endsWith("@1") ? "Object@1" : "Object@<hash>")
                + " consistent=" + consistent);
    }
}
