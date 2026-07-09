import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../explore/presentation/providers/community_provider.dart';
import '../../../explore/presentation/providers/memory_provider.dart';

class RecordingPreviewPage extends ConsumerStatefulWidget {
  const RecordingPreviewPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  ConsumerState<RecordingPreviewPage> createState() =>
      _RecordingPreviewPageState();
}

class _RecordingPreviewPageState extends ConsumerState<RecordingPreviewPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final int _categoryId;
  late final String _category;
  late final bool _wasDictated;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.data['categoryId'] as int;
    _category = widget.data['category'] as String;
    _wasDictated = widget.data['wasDictated'] as bool? ?? false;
    _titleController = TextEditingController(
      text: widget.data['title'] as String? ?? '',
    );
    _contentController = TextEditingController(
      text: widget.data['transcription'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final community = ref.read(communityProvider).selected;
    final communityId = int.tryParse(community?.id ?? '');
    if (communityId == null ||
        _titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa el texto y selecciona una comunidad.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    final notifier = ref.read(memoryProvider.notifier);
    final memory = await notifier.createStory(
      categoryId: _categoryId,
      communityId: communityId,
      title: _titleController.text.trim(),
      contentText: _contentController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (memory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            notifier.errorMessage ?? 'No se pudo guardar la memoria.',
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memoria enviada correctamente.')),
    );
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final community = ref.watch(communityProvider).selected;
    return Scaffold(
      backgroundColor: context.surface,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Revisar memoria',
          style: TextStyle(color: context.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            _wasDictated
                ? 'Revisa la transcripcion y corrige lo necesario.'
                : 'Revisa el texto antes de enviarlo.',
            style: TextStyle(color: context.textBody),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Titulo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            minLines: 10,
            maxLines: 18,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Historia',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.category_outlined),
                label: Text(_category),
              ),
              Chip(
                avatar: const Icon(Icons.location_on_outlined),
                label: Text(community?.name ?? 'Selecciona una comunidad'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_outlined),
            label: Text(_saving ? 'Guardando...' : 'Guardar memoria'),
          ),
        ],
      ),
    );
  }
}
