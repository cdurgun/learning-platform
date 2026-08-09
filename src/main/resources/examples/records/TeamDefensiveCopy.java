record Team(java.util.List<String> members) {

    // Compact constructor: no need to repeat the parameter list, just the
    // defensive copy. The assignment (this.members = members;) is done
    // implicitly by the compiler after this block.
    Team {
        members = java.util.List.copyOf(members);
    }
}

class TeamDefensiveCopyUsage {
    public static void main(String[] args) {
        java.util.List<String> names = new java.util.ArrayList<>();
        names.add("Ada");
        names.add("Grace");

        Team team = new Team(names);
        names.add("Linus"); // no longer has any effect on team.members()

        System.out.println(team); // Team[members=[Ada, Grace]]

        try {
            team.members().add("Dennis"); // UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("members() üzerinden değiştirilemez: " + e.getClass().getSimpleName());
        }
    }
}
