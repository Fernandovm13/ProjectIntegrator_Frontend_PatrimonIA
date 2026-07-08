class AppUser {
  final int? id;
  final String name;
  final String email;
  final String role;
  final int? roleId;
  final String? roleName;
  final bool isPremium;
  final int reputationScore;
  final DateTime? createdAt;
  final String community;
  final String location;
  final int storiesSaved;
  final int storiesRead;
  final int storiesCreated;
  final int communities;

  const AppUser({
    this.id,
    this.name = 'Usuario',
    this.email = 'user@patrimonia.app',
    this.role = 'Explorador',
    this.roleId,
    this.roleName,
    this.isPremium = false,
    this.reputationScore = 0,
    this.createdAt,
    this.community = '',
    this.location = '',
    this.storiesSaved = 0,
    this.storiesRead = 0,
    this.storiesCreated = 0,
    this.communities = 1,
  });

  AppUser copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    int? roleId,
    String? roleName,
    bool? isPremium,
    int? reputationScore,
    DateTime? createdAt,
    String? community,
    String? location,
    int? storiesSaved,
    int? storiesRead,
    int? storiesCreated,
    int? communities,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      isPremium: isPremium ?? this.isPremium,
      reputationScore: reputationScore ?? this.reputationScore,
      createdAt: createdAt ?? this.createdAt,
      community: community ?? this.community,
      location: location ?? this.location,
      storiesSaved: storiesSaved ?? this.storiesSaved,
      storiesRead: storiesRead ?? this.storiesRead,
      storiesCreated: storiesCreated ?? this.storiesCreated,
      communities: communities ?? this.communities,
    );
  }
}
