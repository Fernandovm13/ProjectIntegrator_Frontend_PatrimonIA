import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget emoji(String e) => Text(e, style: const TextStyle(fontSize: 22));

    final todayItems = [
      _NotificationData(
        title: 'Nueva memoria agregada en tu comunidad',
        description:
            'Se añadió \'La leyenda del volcán Tacaná\' al corpus de Motozintla',
        time: 'Hace 2 horas',
        icon: emoji('📚'),
        statusDotColor: cs.primary,
        isUnread: true,
      ),
      _NotificationData(
        title: 'El Narrador tiene nuevas historias para ti',
        description:
            'Hay 5 nuevas leyendas disponibles de Los Altos de Chiapas',
        time: 'Hace 4 horas',
        icon: emoji('🗣️'),
        statusDotColor: cs.secondary,
        isUnread: true,
      ),
    ];

    final weekItems = [
      _NotificationData(
        title: 'Tu testimonio fue aprobado al corpus',
        description:
            '\'El Nagual de Tzontehuitz\' ya está disponible para toda la comunidad',
        time: 'Hace 2 días',
        icon: emoji('✅'),
        statusDotColor: cs.tertiary,
        isUnread: false,
      ),
      _NotificationData(
        title: '3 nuevas memorias en Zinacantán',
        description:
            'Testimonios sobre los tejidos tradicionales de Semana Santa',
        time: 'Hace 3 días',
        icon: emoji('📚'),
        statusDotColor: cs.primary,
        isUnread: false,
      ),
      _NotificationData(
        title: '¡Has contribuido 12 memorias!',
        description:
            'Eres uno de los Guardianes más activos de tu comunidad',
        time: 'Hace 5 días',
        icon: emoji('🏆'),
        statusDotColor: cs.secondary,
        isUnread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Notificaciones',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildSection(context, 'Hoy', todayItems),
          const SizedBox(height: 8),
          _buildSection(context, 'Esta semana', weekItems),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<_NotificationData> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
        for (int i = 0; i < items.length; i++) ...[
          _NotificationTile(
            title: items[i].title,
            description: items[i].description,
            time: items[i].time,
            icon: items[i].icon,
            statusDotColor: items[i].statusDotColor,
            isUnread: items[i].isUnread,
          ),
          if (i < items.length - 1)
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
        ],
      ],
    );
  }
}

class _NotificationData {
  final String title;
  final String description;
  final String time;
  final Widget icon;
  final Color statusDotColor;
  final bool isUnread;

  const _NotificationData({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.statusDotColor,
    required this.isUnread,
  });
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final Widget icon;
  final Color statusDotColor;
  final bool isUnread;

  const _NotificationTile({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.statusDotColor,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusDotColor,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            height: 28,
            child: Center(child: icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary,
              ),
            ),
        ],
      ),
    );
  }
}
