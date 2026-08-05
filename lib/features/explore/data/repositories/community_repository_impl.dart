import '../../domain/models/community.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_local_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityLocalDataSource localDataSource;

  const CommunityRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Community>> getCommunities() {
    return localDataSource.getCommunities();
  }
}
