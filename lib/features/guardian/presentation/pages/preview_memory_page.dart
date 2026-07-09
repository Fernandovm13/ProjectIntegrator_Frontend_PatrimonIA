import 'package:flutter/material.dart';

class PreviewMemoryPage extends StatelessWidget {
  const PreviewMemoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AudioPlayerCard(),
            const SizedBox(height: 20),
            const _TranscriptionCard(),
            const SizedBox(height: 24),
            _buildMetadataSection(context),
            const Spacer(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: cs.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Vista previa',
        style: tt.titleLarge?.copyWith(
          fontFamily: 'Playfair Display',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Categoría: ', style: tt.bodyMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📜', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    'Leyenda',
                    style: tt.bodySmall?.copyWith(color: cs.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📍',
                  style: TextStyle(
                      fontSize: 14, color: cs.error)),
              const SizedBox(width: 4),
              Text(
                'San Cristóbal de las Casas',
                style: tt.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🗃️', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Guardar al corpus comunitario',
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cs.tertiary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Descartar',
              style: tt.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}

class _AudioPlayerCard extends StatefulWidget {
  const _AudioPlayerCard();

  @override
  State<_AudioPlayerCard> createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<_AudioPlayerCard> {
  double _sliderValue = 82 / 222;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.primary,
                ),
                child: Icon(Icons.play_arrow, color: cs.onPrimary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Text('1:22', style: tt.labelSmall),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: cs.tertiary,
                          inactiveTrackColor: cs.surfaceContainerHighest,
                          thumbColor: cs.tertiary,
                          trackHeight: 4,
                          overlayColor: cs.tertiary.withValues(alpha: 0.12),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                        ),
                        child: Slider(
                          value: _sliderValue,
                          onChanged: (v) =>
                              setState(() => _sliderValue = v),
                        ),
                      ),
                    ),
                    Text('3:42', style: tt.labelSmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '1x',
                  style: tt.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TranscriptionCard extends StatelessWidget {
  const _TranscriptionCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Transcripción automática',
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const Spacer(),
              Icon(Icons.edit, color: cs.tertiary, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Mi abuela me contaba que el Nagual del Cerro Tzontehuitz '
            'aparece cuando el pueblo está en peligro. Ella lo vio una '
            'vez, dice, como una luz brillante entre los pinos...',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Text(
            'Editar transcripción',
            style: tt.bodySmall?.copyWith(
              color: cs.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
