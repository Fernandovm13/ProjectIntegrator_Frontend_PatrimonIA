import '../models/community.dart';
import '../repositories/community_repository.dart';

class GetCommunitiesUsecase {
  final CommunityRepository _repository;

  const GetCommunitiesUsecase({required CommunityRepository repository})
      : _repository = repository;

  Future<List<Community>> call() {
    return _repository.getCommunities();
  }
}
