import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/explore_di.dart';
import '../../domain/models/community.dart';
import '../../domain/usecases/get_communities_usecase.dart';

final _getCommunitiesUsecaseProvider = Provider<GetCommunitiesUsecase>((ref) {
  return ref.watch(exploreDIProvider).getCommunitiesUsecase;
});

class CommunityState {
  final List<Community> communities;
  final Community? selected;

  const CommunityState({
    this.communities = const [],
    this.selected,
  });

  CommunityState copyWith({
    List<Community>? communities,
    Community? selected,
  }) {
    return CommunityState(
      communities: communities ?? this.communities,
      selected: selected ?? this.selected,
    );
  }
}

class CommunityNotifier extends AsyncNotifier<CommunityState> {
  @override
  Future<CommunityState> build() async {
    final communities = await ref.read(_getCommunitiesUsecaseProvider)();
    final selected = communities.length > 1 ? communities[1] : null;
    return CommunityState(communities: communities, selected: selected);
  }

  void select(Community community) {
    state = AsyncValue.data(
      state.requireValue.copyWith(selected: community),
    );
  }
}

final communityProvider =
    AsyncNotifierProvider<CommunityNotifier, CommunityState>(
      CommunityNotifier.new,
    );
