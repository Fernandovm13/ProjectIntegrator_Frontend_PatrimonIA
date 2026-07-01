class AppUser {
  final String name;
  final String email;
  final String role;
  final String community;
  final String location;
  final int storiesSaved;
  final int storiesRead;
  final int communities;

  const AppUser({
    this.name = 'María Xochitl López',
    this.email = 'maria@ejemplo.com',
    this.role = 'Guardián',
    this.community = 'Zinacantán',
    this.location = 'San Cristóbal de las Casas, Chiapas',
    this.storiesSaved = 12,
    this.storiesRead = 45,
    this.communities = 3,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? role,
    String? community,
    String? location,
    int? storiesSaved,
    int? storiesRead,
    int? communities,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      community: community ?? this.community,
      location: location ?? this.location,
      storiesSaved: storiesSaved ?? this.storiesSaved,
      storiesRead: storiesRead ?? this.storiesRead,
      communities: communities ?? this.communities,
    );
  }
}
