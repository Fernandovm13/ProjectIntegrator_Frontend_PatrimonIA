import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/app_container.dart';
import '../data/datasources/community_local_datasource.dart';
import '../data/datasources/memory_local_datasource.dart';
import '../data/repositories/community_repository_impl.dart';
import '../data/repositories/memory_repository_impl.dart';
import '../domain/repositories/community_repository.dart';
import '../domain/repositories/memory_repository.dart';
import '../domain/usecases/add_memory_usecase.dart';
import '../domain/usecases/get_communities_usecase.dart';
import '../domain/usecases/get_memories_usecase.dart';

final exploreDIProvider = Provider<ExploreDI>((ref) {
  final container = ref.watch(appContainerProvider);
  return ExploreDI(container!);
});

class ExploreDI {
  final AppContainer appContainer;

  late final MemoryLocalDataSource memoryLocalDataSource;
  late final MemoryRepository memoryRepository;
  late final GetMemoriesUsecase getMemoriesUsecase;
  late final AddMemoryUsecase addMemoryUsecase;

  late final CommunityLocalDataSource communityLocalDataSource;
  late final CommunityRepository communityRepository;
  late final GetCommunitiesUsecase getCommunitiesUsecase;

  ExploreDI(this.appContainer) {
    _init();
  }

  void _init() {
    memoryLocalDataSource = const MemoryLocalDataSourceImpl();
    memoryRepository = MemoryRepositoryImpl(
      localDataSource: memoryLocalDataSource,
    );
    getMemoriesUsecase = GetMemoriesUsecase(repository: memoryRepository);
    addMemoryUsecase = AddMemoryUsecase(repository: memoryRepository);

    communityLocalDataSource = const CommunityLocalDataSourceImpl();
    communityRepository = CommunityRepositoryImpl(
      localDataSource: communityLocalDataSource,
    );
    getCommunitiesUsecase = GetCommunitiesUsecase(
      repository: communityRepository,
    );
  }
}
