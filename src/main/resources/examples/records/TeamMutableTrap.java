record Team(java.util.List<String> members) {
}

class TeamMutableTrap {
    public static void main(String[] args) {
        java.util.List<String> names = new java.util.ArrayList<>();
        names.add("Ada");
        names.add("Grace");

        Team team = new Team(names);
        System.out.println(team); // Team[members=[Ada, Grace]]

        // The content changes through the externally held reference, without
        // ever going through Team's own API:
        names.add("Linus");

        System.out.println(team); // Team[members=[Ada, Grace, Linus]] -- the "immutable" object changed!
    }
}
