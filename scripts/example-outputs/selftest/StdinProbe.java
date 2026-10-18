// Sandbox self-test: standard input must be empty (end of input right away) -- a program
// that reads it must neither block waiting for a terminal nor see the host's input.
class StdinProbe {
    public static void main(String[] args) throws Exception {
        int first = System.in.read();
        System.out.println(first == -1 ? "stdin: empty" : "stdin: has data");
    }
}
