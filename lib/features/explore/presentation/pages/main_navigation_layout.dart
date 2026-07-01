import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'home_page.dart';
import 'home_guardian_page.dart';
import '../../../narrator/presentation/pages/narrador_page.dart';
import '../../../guardian/presentation/pages/record_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class MainNavigationLayout extends ConsumerStatefulWidget {
  const MainNavigationLayout({super.key});

  @override
  ConsumerState<MainNavigationLayout> createState() => _MainNavigationLayoutState();
}

class _MainNavigationLayoutState extends ConsumerState<MainNavigationLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isGuardian = auth.isGuardian;

    final pages = <Widget>[
      isGuardian ? const HomeGuardianPage() : const HomePage(),
      const NarradorChatPage(),
      const RecordMemoryPage(),
      const SearchPage(),
      const UserProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
