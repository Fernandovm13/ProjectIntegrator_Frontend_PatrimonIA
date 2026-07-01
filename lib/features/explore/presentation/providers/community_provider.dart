import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/community.dart';

class CommunityState {
  final List<Community> communities;
  final Community? selected;

  const CommunityState({this.communities = const [], this.selected});
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  CommunityNotifier() : super(CommunityState(communities: _seed)) {
    state = CommunityState(communities: _seed, selected: _seed[1]);
  }

  static const List<Community> _seed = [
    Community(id: 'scl', name: 'San Cristóbal de las Casas', region: 'Altos de Chiapas', initials: 'SCL', memoryCount: 248),
    Community(id: 'zin', name: 'Zinacantán', region: 'Altos de Chiapas', initials: 'ZIN', memoryCount: 156),
    Community(id: 'chm', name: 'Chamula', region: 'Altos de Chiapas', initials: 'CHM', memoryCount: 189),
    Community(id: 'ten', name: 'Tenejapa', region: 'Altos de Chiapas', initials: 'TEN', memoryCount: 92),
    Community(id: 'pal', name: 'Palenque', region: 'Selva Lacandona', initials: 'PAL', memoryCount: 203),
    Community(id: 'ocs', name: 'Ocosingo', region: 'Selva Lacandona', initials: 'OCS', memoryCount: 78),
  ];

  void select(Community community) {
    state = CommunityState(communities: state.communities, selected: community);
  }
}

final communityProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  return CommunityNotifier();
});
