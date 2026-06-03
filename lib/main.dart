import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/today_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/diary_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ArchivalApp(),
    ),
  );
}

class ArchivalApp extends StatelessWidget {
  const ArchivalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archival',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TodayScreen(),
    TasksScreen(),
    NotesScreen(),
    DiaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      _NavItem(icon: Icons.calendar_today_outlined, label: 'Today'),
      _NavItem(icon: Icons.check_circle_outline, label: 'Tasks'),
      _NavItem(icon: Icons.sticky_note_2_outlined, label: 'Notes'),
      _NavItem(icon: Icons.menu_book_outlined, label: 'Diary'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.sidebarBg,
        border: Border(top: BorderSide(color: Color(0x22FFFFFF), width: 0.5)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              items.length,
              (i) => Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _currentIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[i].icon,
                          size: 22,
                          color: _currentIndex == i
                              ? AppTheme.accentLight
                              : Colors.white.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[i].label,
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 10,
                            color: _currentIndex == i
                                ? AppTheme.accentLight
                                : Colors.white.withValues(alpha: 0.4),
                            fontWeight: _currentIndex == i
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: _currentIndex == i ? 20 : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppTheme.accentLight,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
