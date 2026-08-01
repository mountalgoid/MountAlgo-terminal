import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/terminal_provider.dart';
import 'themes/terminal_themes.dart';
import 'screens/dashboard_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/launcher_screen.dart';
import 'screens/discord_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TerminalProvider()),
      ],
      child: const MountAlgoTerminalApp(),
    ),
  );
}

class MountAlgoTerminalApp extends StatelessWidget {
  const MountAlgoTerminalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final terminalProvider = Provider.of<TerminalProvider>(context);

    ThemeData appTheme;
    switch (terminalProvider.currentVisualMode) {
      case VisualMode.light:
        appTheme = TerminalThemes.lightTheme;
        break;
      case VisualMode.glasses:
        appTheme = TerminalThemes.glassesTheme;
        break;
      case VisualMode.dark:
      default:
        appTheme = TerminalThemes.darkTheme;
        break;
    }

    return MaterialApp(
      title: 'MountAlgo Terminal',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({Key? key}) : super(key: key);

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const JournalScreen(),
    const LauncherScreen(),
    const DiscordScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final terminalProvider = Provider.of<TerminalProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.disabledColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch_outlined),
            activeIcon: Icon(Icons.rocket_launch),
            label: 'Launcher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.discord_outlined),
            activeIcon: Icon(Icons.discord),
            label: 'Discord',
          ),
        ],
      ),
    );
  }
}
