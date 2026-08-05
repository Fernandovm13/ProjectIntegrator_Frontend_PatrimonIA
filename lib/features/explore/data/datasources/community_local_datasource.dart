import '../../domain/models/community.dart';

abstract class CommunityLocalDataSource {
  Future<List<Community>> getCommunities();
}

class CommunityLocalDataSourceImpl implements CommunityLocalDataSource {
  const CommunityLocalDataSourceImpl();

  @override
  Future<List<Community>> getCommunities() async => const [
    Community(
      id: 'scl',
      name: 'San Cristóbal de las Casas',
      region: 'Altos de Chiapas',
      initials: 'SCL',
      memoryCount: 248,
    ),
    Community(
      id: 'zin',
      name: 'Zinacantán',
      region: 'Altos de Chiapas',
      initials: 'ZIN',
      memoryCount: 156,
    ),
    Community(
      id: 'chm',
      name: 'Chamula',
      region: 'Altos de Chiapas',
      initials: 'CHM',
      memoryCount: 189,
    ),
    Community(
      id: 'ten',
      name: 'Tenejapa',
      region: 'Altos de Chiapas',
      initials: 'TEN',
      memoryCount: 92,
    ),
    Community(
      id: 'pal',
      name: 'Palenque',
      region: 'Selva Lacandona',
      initials: 'PAL',
      memoryCount: 203,
    ),
    Community(
      id: 'ocs',
      name: 'Ocosingo',
      region: 'Selva Lacandona',
      initials: 'OCS',
      memoryCount: 78,
    ),
  ];
}
