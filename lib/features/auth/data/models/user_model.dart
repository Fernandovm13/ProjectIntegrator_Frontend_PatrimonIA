import '../../domain/entities/user_entity.dart';

class UserModel {
  final String name;
  final String email;
  final String role;
  final String community;
  final String location;
  final int storiesSaved;
  final int storiesRead;
  final int communities;

  const UserModel({
    this.name = 'María Xochitl López',
    this.email = 'maria@ejemplo.com',
    this.role = 'Guardián',
    this.community = 'Zinacantán',
    this.location = 'San Cristóbal de las Casas, Chiapas',
    this.storiesSaved = 12,
    this.storiesRead = 45,
    this.communities = 3,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String? ?? 'María Xochitl López',
      email: json['email'] as String? ?? 'maria@ejemplo.com',
      role: json['role'] as String? ?? 'Explorador',
      community: json['community'] as String? ?? 'Zinacantán',
      location:
          json['location'] as String? ?? 'San Cristóbal de las Casas, Chiapas',
      storiesSaved: json['storiesSaved'] as int? ?? 12,
      storiesRead: json['storiesRead'] as int? ?? 45,
      communities: json['communities'] as int? ?? 3,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      role: role,
      community: community,
      location: location,
      storiesSaved: storiesSaved,
      storiesRead: storiesRead,
      communities: communities,
    );
  }
}
