import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/models/memory.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class MemoryNotifier extends StateNotifier<List<Memory>> {
  MemoryNotifier(this._ref, this._apiClient) : super(const []);

  final Ref _ref;
  final ApiClient _apiClient;
  bool isLoading = false;
  String? errorMessage;

  List<Memory> get featured => state.where((m) => m.isFeatured).toList();
  List<Memory> get recent =>
      List.from(state)..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Memory> byCategory(String category) {
    if (category == 'Todos') return state;
    return state.where((m) => m.category == category).toList();
  }

  List<Memory> search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return state.where((m) {
      return m.title.toLowerCase().contains(q) ||
          m.content.toLowerCase().contains(q) ||
          m.category.toLowerCase().contains(q) ||
          m.location.toLowerCase().contains(q);
    }).toList();
  }

  void addMemory(Memory memory) {
    state = [memory, ...state];
  }

  Future<void> loadStories({
    String? status,
    int? categoryId,
    int? communityId,
    String? query,
    bool mine = false,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final response = await _apiClient.get(
        '/stories',
        token: _token,
        queryParameters: {
          'status': status,
          'category_id': categoryId?.toString(),
          'community_id': communityId?.toString(),
          'q': query,
          'mine': mine ? 'true' : null,
        },
      );

      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ?? 'No se pudieron cargar las historias.',
        );
      }

      state = _extractList(response.data).map(_memoryFromJson).toList();
    } catch (error) {
      state = const [];
      errorMessage = _friendlyError(error);
    } finally {
      isLoading = false;
    }
  }

  Future<List<Memory>> loadFavoriteStories() async {
    final token = _token;
    if (token == null) return const [];

    final response = await _apiClient.get(
      '/users/profile/favorites',
      token: token,
    );
    if (!response.isSuccess) {
      throw Exception(
        _errorFrom(response.data) ?? 'No se pudieron cargar favoritos.',
      );
    }
    return _extractList(response.data).map(_memoryFromJson).toList();
  }

  Future<List<Memory>> loadMyStories() async {
    final token = _token;
    if (token == null) return const [];

    final response = await _apiClient.get(
      '/users/profile/stories',
      token: token,
    );
    if (!response.isSuccess) {
      throw Exception(
        _errorFrom(response.data) ?? 'No se pudieron cargar tus historias.',
      );
    }
    return _extractList(response.data).map(_memoryFromJson).toList();
  }

  Future<Memory?> fetchStoryById(String id) async {
    try {
      final response = await _apiClient.get('/stories/$id', token: _token);

      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ?? 'No se pudo obtener la historia.',
        );
      }

      final memory = _memoryFromJson(_extractObject(response.data));
      state = [
        for (final item in state)
          if (item.id == memory.id) memory else item,
        if (!state.any((item) => item.id == memory.id)) memory,
      ];
      return memory;
    } catch (error) {
      errorMessage = _friendlyError(error);
      return null;
    }
  }

  Future<Memory?> createStory({
    required int categoryId,
    required int communityId,
    required String title,
    required String contentText,
    String? audioUrl,
    double? latitude,
    double? longitude,
  }) async {
    final token = _token;
    if (token == null) {
      errorMessage = 'Inicia sesion para guardar historias.';
      return null;
    }

    try {
      final response = await _apiClient.post(
        '/stories',
        token: token,
        body: {
          'category_id': categoryId,
          'community_id': communityId,
          'title': title,
          'content_text': contentText,
          if (audioUrl != null) 'audio_url': audioUrl,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
      );

      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ?? 'No se pudo crear la historia.',
        );
      }

      final memory = _memoryFromJson(_extractObject(response.data));
      state = [memory, ...state];
      return memory;
    } catch (error) {
      errorMessage = _friendlyError(error);
      return null;
    }
  }

  Future<void> toggleLike(String id) async {
    final token = _token;
    if (token == null) {
      errorMessage = 'Inicia sesion para guardar favoritos.';
      return;
    }

    try {
      final response = await _apiClient.post(
        '/stories/$id/favorite',
        token: token,
      );

      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ?? 'No se pudo actualizar el favorito.',
        );
      }

      final data = _asMap(response.data);
      final isFavorite =
          _boolFrom(data['isFavorite'] ?? data['is_favorite']) ?? false;
      state = state.map((m) {
        if (m.id != id) return m;
        return m.copyWith(
          isFavorite: isFavorite,
          likes: isFavorite ? m.likes + 1 : (m.likes > 0 ? m.likes - 1 : 0),
        );
      }).toList();
    } catch (error) {
      errorMessage = _friendlyError(error);
    }
  }

  Future<bool> markStoryRead(String id) async {
    final token = _token;
    if (token == null) return false;

    final response = await _apiClient.post('/stories/$id/read', token: token);
    if (!response.isSuccess) {
      errorMessage =
          _errorFrom(response.data) ?? 'No se pudo marcar como leida.';
      return false;
    }
    return true;
  }

  Future<Memory?> updateStory({
    required String id,
    int? categoryId,
    int? communityId,
    String? title,
    String? contentText,
    String? audioUrl,
    double? latitude,
    double? longitude,
  }) async {
    final token = _token;
    if (token == null) return null;

    final response = await _apiClient.patch(
      '/stories/$id',
      token: token,
      body: {
        if (categoryId != null) 'category_id': categoryId,
        if (communityId != null) 'community_id': communityId,
        if (title != null) 'title': title,
        if (contentText != null) 'content_text': contentText,
        if (audioUrl != null) 'audio_url': audioUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      },
    );

    if (!response.isSuccess) {
      errorMessage =
          _errorFrom(response.data) ?? 'No se pudo actualizar la historia.';
      return null;
    }

    final memory = _memoryFromJson(_extractObject(response.data));
    state = state.map((m) => m.id == memory.id ? memory : m).toList();
    return memory;
  }

  Future<bool> deleteStory(String id) async {
    final token = _token;
    if (token == null) return false;

    final response = await _apiClient.delete('/stories/$id', token: token);
    if (!response.isSuccess) {
      errorMessage =
          _errorFrom(response.data) ?? 'No se pudo eliminar la historia.';
      return false;
    }
    state = state.where((m) => m.id != id).toList();
    return true;
  }

  Future<bool> validateStory({
    required String id,
    required String vote,
    required String comment,
  }) async {
    final token = _token;
    if (token == null) {
      errorMessage = 'Inicia sesion como admin para validar historias.';
      return false;
    }

    try {
      final response = await _apiClient.post(
        '/stories/$id/validate',
        token: token,
        body: {'vote': vote, 'comment': comment},
      );

      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ?? 'No se pudo validar la historia.',
        );
      }

      final nextStatus = vote == 'approve' ? 'approved' : 'rejected';
      state = state
          .map((m) => m.id == id ? m.copyWith(status: nextStatus) : m)
          .toList();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      return false;
    }
  }

  String? get _token => _ref.read(authProvider).token;

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['stories'],
        data['data'],
        data['items'],
        data['results'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) return candidate;
      }
    }
    return [];
  }

  Map<String, dynamic> _extractObject(dynamic data) {
    if (data is Map<String, dynamic>) {
      final candidates = [data['story'], data['data'], data['item']];
      for (final candidate in candidates) {
        if (candidate is Map<String, dynamic>) return candidate;
      }
      return data;
    }
    return {};
  }

  Map<String, dynamic> _asMap(dynamic data) {
    return data is Map<String, dynamic> ? data : {};
  }

  Memory _memoryFromJson(dynamic raw) {
    final json = raw is Map<String, dynamic> ? raw : <String, dynamic>{};
    final categoryId = _intFrom(json['category_id'] ?? json['categoryId']);
    final communityId = _intFrom(json['community_id'] ?? json['communityId']);
    final category = _categoryName(
      json['category'] ?? json['category_name'],
      categoryId,
    );
    final community = _communityName(
      json['community'] ?? json['community_name'],
      communityId,
    );
    final location =
        _communityLocation(json['community'], json['community_location']) ??
        community;
    final createdAt = _dateFrom(json['created_at'] ?? json['createdAt']);

    return Memory(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? 'Historia sin titulo'}',
      category: category,
      location: location,
      community: community,
      content:
          '${json['content_text'] ?? json['contentText'] ?? json['content'] ?? ''}',
      author: _authorName(json['author'] ?? json['user'] ?? json['username']),
      duration: _durationFrom(json),
      icon: _categoryIcon(category),
      color: AppColors.categoryColor(category),
      createdAt: createdAt,
      isFeatured: _boolFrom(json['is_featured'] ?? json['isFeatured']) ?? false,
      audioPath: json['audio_url'] is String
          ? json['audio_url'] as String
          : null,
      likes: _intFrom(json['favorites_count'] ?? json['likes']) ?? 0,
      listens: _intFrom(json['listens']) ?? 0,
      categoryId: categoryId,
      communityId: communityId,
      status: json['status'] is String ? json['status'] as String : null,
      isFavorite: _boolFrom(json['isFavorite'] ?? json['is_favorite']) ?? false,
      latitude: _doubleFrom(json['latitude']),
      longitude: _doubleFrom(json['longitude']),
    );
  }

  String _categoryName(dynamic category, int? categoryId) {
    if (category is Map<String, dynamic>) {
      final name = category['name'];
      if (name is String && name.isNotEmpty) return _singularCategory(name);
    }
    if (category is String && category.isNotEmpty) {
      return _singularCategory(category);
    }

    switch (categoryId) {
      case 1:
        return 'Leyenda';
      case 2:
        return 'Fiesta';
      case 3:
        return 'Ritual';
      case 5:
        return 'Cancion';
      default:
        return 'Historia';
    }
  }

  String _singularCategory(String category) {
    switch (category.toLowerCase()) {
      case 'leyendas':
        return 'Leyenda';
      case 'fiestas':
        return 'Fiesta';
      case 'rituales':
        return 'Ritual';
      case 'historias':
        return 'Historia';
      case 'canciones':
        return 'Cancion';
      default:
        return category;
    }
  }

  String _communityName(dynamic community, int? communityId) {
    if (community is Map<String, dynamic>) {
      final name = community['name'];
      if (name is String && name.isNotEmpty) return name;
    }
    if (community is String && community.isNotEmpty) return community;
    return communityId == null ? 'Comunidad' : 'Comunidad $communityId';
  }

  String? _communityLocation(dynamic community, dynamic location) {
    if (location is String && location.isNotEmpty) return location;
    if (community is Map<String, dynamic>) {
      final value = community['location'];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  String _authorName(dynamic author) {
    if (author is Map<String, dynamic>) {
      final username = author['username'] ?? author['name'] ?? author['email'];
      if (username is String && username.isNotEmpty) return username;
    }
    if (author is String && author.isNotEmpty) return author;
    return 'Anonimo';
  }

  String _durationFrom(Map<String, dynamic> json) {
    final explicit = json['duration'];
    if (explicit is String && explicit.isNotEmpty) return explicit;
    final content =
        json['content_text'] ?? json['contentText'] ?? json['content'];
    if (content is! String || content.trim().isEmpty) return '1 min';
    final words = content.trim().split(RegExp(r'\s+')).length;
    final minutes = (words / 180).ceil().clamp(1, 99);
    return '$minutes min';
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'leyenda':
        return Icons.eco;
      case 'fiesta':
        return Icons.celebration;
      case 'ritual':
        return Icons.auto_awesome;
      case 'cancion':
        return Icons.library_music;
      default:
        return Icons.menu_book;
    }
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

  double? _doubleFrom(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool? _boolFrom(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return null;
  }

  DateTime _dateFrom(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}

final memoryProvider = StateNotifierProvider<MemoryNotifier, List<Memory>>((
  ref,
) {
  final notifier = MemoryNotifier(ref, ref.watch(apiClientProvider));
  Future.microtask(() => notifier.loadStories(status: 'approved'));

  ref.listen<AuthState>(authProvider, (previous, next) {
    if (previous?.token != next.token) {
      notifier.loadStories(status: 'approved');
    }
  });

  return notifier;
});

final featuredMemoryProvider = Provider<Memory?>((ref) {
  final memories = ref.watch(memoryProvider);
  if (memories.isEmpty) return null;
  return memories.firstWhere((m) => m.isFeatured, orElse: () => memories.first);
});
