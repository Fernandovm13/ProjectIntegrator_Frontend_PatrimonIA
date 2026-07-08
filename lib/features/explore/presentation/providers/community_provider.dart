import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/models/community.dart';

class CommunityState {
  final List<Community> communities;
  final Community? selected;
  final bool isLoading;
  final String? errorMessage;

  const CommunityState({
    this.communities = const [],
    this.selected,
    this.isLoading = false,
    this.errorMessage,
  });

  CommunityState copyWith({
    List<Community>? communities,
    Community? selected,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CommunityState(
      communities: communities ?? this.communities,
      selected: selected ?? this.selected,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  CommunityNotifier(this._apiClient) : super(const CommunityState());

  final ApiClient _apiClient;

  Future<void> loadCommunities() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _apiClient.get('/communities');
      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ?? 'No se pudieron cargar las comunidades.',
        );
      }

      final communities = _extractList(
        response.data,
      ).map(_communityFromJson).toList();
      state = state.copyWith(
        communities: communities,
        selected:
            state.selected ?? (communities.isEmpty ? null : communities.first),
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        communities: const [],
        isLoading: false,
        errorMessage: _friendlyError(error),
      );
    }
  }

  void select(Community community) {
    state = state.copyWith(selected: community);
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [data['communities'], data['data'], data['items']];
      for (final candidate in candidates) {
        if (candidate is List) return candidate;
      }
    }
    return [];
  }

  Community _communityFromJson(dynamic raw) {
    final json = raw is Map<String, dynamic> ? raw : <String, dynamic>{};
    final id = json['id'];
    final name = json['name'] is String ? json['name'] as String : 'Comunidad';
    final region = json['location'] is String ? json['location'] as String : '';
    return Community(
      id: '${id ?? name}',
      name: name,
      region: region,
      initials: _initials(name),
      memoryCount: _intFrom(json['memory_count'] ?? json['memoryCount']) ?? 0,
    );
  }

  String _initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'C';
    return words.take(3).map((word) => word[0].toUpperCase()).join();
  }

  String? _errorFrom(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final message = data['message'] ?? data['error'];
    return message is String && message.isNotEmpty ? message : null;
  }

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    if (message.contains('Connection refused') ||
        message.contains('Failed host lookup') ||
        message.contains('Connection timed out')) {
      return 'No se pudo conectar con el backend local configurado.';
    }
    return message;
  }

  int? _intFrom(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
      final notifier = CommunityNotifier(ref.watch(apiClientProvider));
      Future.microtask(notifier.loadCommunities);
      return notifier;
    });
