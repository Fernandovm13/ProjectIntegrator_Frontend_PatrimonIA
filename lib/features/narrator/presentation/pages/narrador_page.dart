import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isTyping;
  const _ChatMessage({required this.text, this.isUser = false, this.isTyping = false});
}

class NarradorChatPage extends ConsumerStatefulWidget {
  const NarradorChatPage({super.key});

  @override
  ConsumerState<NarradorChatPage> createState() => _NarradorChatPageState();
}

class _NarradorChatPageState extends ConsumerState<NarradorChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Cuenta la leyenda que en las profundidades del Cerro Tzontehuitz habita un espíritu protector ancestral...',
    ),
  ];

  final List<String> _narratorResponses = [
    'Cuenta la leyenda que en las profundidades del Cerro Tzontehuitz habita un espíritu protector ancestral que vigila los bosques desde tiempos inmemoriales...',
    'Los abuelos dicen que antes de entrar al cerro hay que pedir permiso con respeto, llevar una ofrenda de copal y no tener malos pensamientos.',
    "En la cosmovisión tzotzil, cada montaña tiene un dueño, un 'altar' que protege a la comunidad. El Tzontehuitz es el más sagrado de Los Altos.",
    'El nagual no es un ser maligno, es un guardián. Aquellos que respetan la tierra reciben su protección; quienes la dañan, su advertencia.',
    'Las historias se cuentan al calor del fogón, cuando el maíz se tuesta y el copal purifica el ambiente. Así se transmite la memoria de generación en generación.',
  ];

  int _responseIndex = 0;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messageController.clear();
      _messages.add(const _ChatMessage(text: '', isTyping: true));
    });
    _simulateNarratorResponse();
  }

  void _simulateNarratorResponse() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _messages.removeWhere((m) => m.isTyping);
        _messages.add(_ChatMessage(
          text: _narratorResponses[_responseIndex],
        ));
        _responseIndex = (_responseIndex + 1) % _narratorResponses.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surface,
      appBar: AppBar(
        backgroundColor: context.appBarDarkBg,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: Column(
          children: [
            Text(
              'El Narrador',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.bold,
                color: context.maizeGold,
                fontSize: 18,
              ),
            ),
            Text(
              'Comunidad Los Altos, Chiapas',
              style: TextStyle(
                fontSize: 11,
                color: context.textBody,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                for (final msg in _messages) ...[
                  if (msg.isTyping)
                    _buildNarratorTyping(context)
                  else if (msg.isUser)
                    _buildUserMessage(msg.text)
                  else
                    _buildNarratorMessage(context, msg.text),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildNarratorMessage(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: context.sacredJade,
          child: Icon(
            Icons.circle_outlined,
            size: 16,
            color: context.maizeGold,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'El Narrador',
                style: TextStyle(
                  fontSize: 11,
                  color: context.maizeGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.copalBrown,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColors.warmAmber,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarratorTyping(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: context.sacredJade,
          child: Icon(
            Icons.circle_outlined,
            size: 16,
            color: context.maizeGold,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.copalBrown,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\u00B7  ',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                '\u00B7  ',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                '\u00B7',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: context.card,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: context.sacredJade,
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white, size: 18),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Micrófono activado')),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Pregunta sobre tu comunidad...',
                hintStyle: TextStyle(
                  color: context.textSecondary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: context.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 20,
            backgroundColor: context.maizeGold,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
