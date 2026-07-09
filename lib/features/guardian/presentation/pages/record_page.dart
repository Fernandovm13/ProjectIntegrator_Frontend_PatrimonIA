import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../shared/theme/theme_colors_extension.dart';
import '../providers/story_category_provider.dart';

enum _StoryInputMode { write, dictate }

class RecordMemoryPage extends ConsumerStatefulWidget {
  const RecordMemoryPage({super.key});

  @override
  ConsumerState<RecordMemoryPage> createState() => _RecordMemoryPageState();
}

class _RecordMemoryPageState extends ConsumerState<RecordMemoryPage> {
  final _titleController = TextEditingController();
  final _storyController = TextEditingController();
  final _speech = SpeechToText();
  _StoryInputMode _mode = _StoryInputMode.write;
  StoryCategory? _category;
  bool _speechReady = false;

  @override
  void dispose() {
    _speech.stop();
    _titleController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      if (mounted) setState(() {});
      return;
    }

    if (!_speechReady) {
      _speechReady = await _speech.initialize(
        onStatus: (_) {
          if (mounted) setState(() {});
        },
        onError: (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo reconocer la voz: ${error.errorMsg}'),
            ),
          );
          setState(() {});
        },
      );
    }
    if (!_speechReady) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El reconocimiento de voz no esta disponible.'),
          ),
        );
      }
      return;
    }

    await _speech.listen(
      listenOptions: SpeechListenOptions(
        localeId: 'es_MX',
        listenMode: ListenMode.dictation,
      ),
      onResult: (result) {
        _storyController.text = result.recognizedWords;
        _storyController.selection = TextSelection.collapsed(
          offset: _storyController.text.length,
        );
        if (mounted) setState(() {});
      },
    );
    if (mounted) setState(() {});
  }

  void _continue() {
    if (_category == null ||
        _titleController.text.trim().isEmpty ||
        _storyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa el titulo, la categoria y la historia.'),
        ),
      );
      return;
    }
    context.push(
      '/preview',
      extra: {
        'categoryId': _category!.id,
        'category': _category!.name,
        'title': _titleController.text.trim(),
        'transcription': _storyController.text.trim(),
        'wasDictated': _mode == _StoryInputMode.dictate,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(storyCategoryProvider);
    return Scaffold(
      backgroundColor: context.surface,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Guardar una memoria',
          style: TextStyle(color: context.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '¿Como quieres contar tu historia?',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<_StoryInputMode>(
            segments: const [
              ButtonSegment(
                value: _StoryInputMode.write,
                icon: Icon(Icons.edit_outlined),
                label: Text('Escribir'),
              ),
              ButtonSegment(
                value: _StoryInputMode.dictate,
                icon: Icon(Icons.mic_none),
                label: Text('Dictar'),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (value) async {
              if (_speech.isListening) await _speech.stop();
              setState(() => _mode = value.first);
            },
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Titulo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (categoryState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (categoryState.errorMessage != null)
            Row(
              children: [
                Expanded(child: Text(categoryState.errorMessage!)),
                IconButton(
                  tooltip: 'Reintentar',
                  onPressed: () =>
                      ref.read(storyCategoryProvider.notifier).load(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            )
          else
            DropdownButtonFormField<StoryCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: categoryState.categories
                  .map(
                    (item) =>
                        DropdownMenuItem(value: item, child: Text(item.name)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _category = value),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _storyController,
            minLines: 8,
            maxLines: 14,
            readOnly: _mode == _StoryInputMode.dictate && _speech.isListening,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: _mode == _StoryInputMode.write
                  ? 'Escribe tu historia'
                  : 'Texto reconocido',
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
          ),
          if (_mode == _StoryInputMode.dictate) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _toggleListening,
              icon: Icon(_speech.isListening ? Icons.stop : Icons.mic),
              label: Text(
                _speech.isListening ? 'Detener dictado' : 'Comenzar dictado',
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _continue,
            icon: const Icon(Icons.preview_outlined),
            label: const Text('Revisar antes de guardar'),
          ),
        ],
      ),
    );
  }
}
