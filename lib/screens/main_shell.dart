import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'invoices_screen.dart';
import 'settings_screen.dart';

// ─────────────────────────────────────────────────────────────
// Main navigation shell with Settings
// ─────────────────────────────────────────────────────────────
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  /// Shared "which tab is active" state. Any screen anywhere in the app
  /// (e.g. Settings' "All Invoices" tile) can jump to a specific tab by
  /// just setting `MainShell.currentTab.value = 1` — no need to pop
  /// routes or guess navigation structure.
  static final ValueNotifier<int> currentTab = ValueNotifier<int>(0);

  static const _titles = ['Home', 'Invoices', 'Settings'];

  static const _icons = [
    Icons.home_rounded,
    Icons.receipt_long_rounded,
    Icons.settings_rounded,
  ];

  static const _cupertinoIcons = [
    CupertinoIcons.house_fill,
    CupertinoIcons.doc_text_fill,
    CupertinoIcons.gear_alt_fill,
  ];

  static const _screens = [
    HomeScreen(),
    InvoicesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const _WebShell(titles: _titles, icons: _icons, screens: _screens);
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const _IOSShell(
          titles: _titles, icons: _cupertinoIcons, screens: _screens);
    }
    return const _AndroidShell(titles: _titles, icons: _icons, screens: _screens);
  }
}

// Web Shell (Top tabs)
class _WebShell extends StatefulWidget {
  final List<String> titles;
  final List<IconData> icons;
  final List<Widget> screens;
  const _WebShell({required this.titles, required this.icons, required this.screens});

  @override
  State<_WebShell> createState() => _WebShellState();
}

class _WebShellState extends State<_WebShell> {
  late int _index = MainShell.currentTab.value;

  @override
  void initState() {
    super.initState();
    MainShell.currentTab.addListener(_onExternalChange);
  }

  @override
  void dispose() {
    MainShell.currentTab.removeListener(_onExternalChange);
    super.dispose();
  }

  void _onExternalChange() {
    if (mounted && MainShell.currentTab.value != _index) {
      setState(() => _index = MainShell.currentTab.value);
    }
  }

  void _select(int i) {
    setState(() => _index = i);
    MainShell.currentTab.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(widget.titles[_index]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: List.generate(widget.titles.length, (i) {
                final selected = i == _index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextButton.icon(
                    onPressed: () => _select(i),
                    icon: Icon(widget.icons[i],
                        size: 18,
                        color: selected ? AppColors.brand : AppColors.slateLight),
                    label: Text(widget.titles[i]),
                    style: TextButton.styleFrom(
                      foregroundColor: selected ? AppColors.brand : AppColors.slateLight,
                      textStyle: TextStyle(
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: IndexedStack(index: _index, children: widget.screens),
        ),
      ),
    );
  }
}

// iOS Shell
// iOS Shell
class _IOSShell extends StatefulWidget {
  final List<String> titles;
  final List<IconData> icons;
  final List<Widget> screens;
  const _IOSShell({required this.titles, required this.icons, required this.screens});

  @override
  State<_IOSShell> createState() => _IOSShellState();
}

class _IOSShellState extends State<_IOSShell> {
  late final CupertinoTabController _controller =
      CupertinoTabController(initialIndex: MainShell.currentTab.value);

  @override
  void initState() {
    super.initState();
    MainShell.currentTab.addListener(_onExternalChange);
  }

  @override
  void dispose() {
    MainShell.currentTab.removeListener(_onExternalChange);
    _controller.dispose();
    super.dispose();
  }

  void _onExternalChange() {
    if (MainShell.currentTab.value != _controller.index) {
      _controller.index = MainShell.currentTab.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _controller,
      backgroundColor: AppColors.paper,
      tabBar: CupertinoTabBar(
        backgroundColor: AppColors.paperCard,
        activeColor: AppColors.brand,
        inactiveColor: AppColors.slateLight,
        border: const Border(top: BorderSide(color: AppColors.divider)),
        items: List.generate(
          widget.titles.length,
          (i) => BottomNavigationBarItem(icon: Icon(widget.icons[i]), label: widget.titles[i]),
        ),
        onTap: (i) => MainShell.currentTab.value = i,
      ),
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
          backgroundColor: AppColors.paper,
          navigationBar: CupertinoNavigationBar(
            middle: Text(widget.titles[index]),
            backgroundColor: AppColors.paper,
            border: const Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: widget.screens[index],
            ),
          ),
        );
      },
    );
  }
}
// Android/Desktop Shell
class _AndroidShell extends StatefulWidget {
  final List<String> titles;
  final List<IconData> icons;
  final List<Widget> screens;
  const _AndroidShell({required this.titles, required this.icons, required this.screens});

  @override
  State<_AndroidShell> createState() => _AndroidShellState();
}

class _AndroidShellState extends State<_AndroidShell> {
  late int _index = MainShell.currentTab.value;

  @override
  void initState() {
    super.initState();
    MainShell.currentTab.addListener(_onExternalChange);
  }

  @override
  void dispose() {
    MainShell.currentTab.removeListener(_onExternalChange);
    super.dispose();
  }

  void _onExternalChange() {
    if (mounted && MainShell.currentTab.value != _index) {
      setState(() => _index = MainShell.currentTab.value);
    }
  }

  void _select(int i) {
    setState(() => _index = i);
    MainShell.currentTab.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(widget.titles[_index])),
      body: SafeArea(
        top: false,
        child: IndexedStack(index: _index, children: widget.screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        backgroundColor: AppColors.paperCard,
        destinations: List.generate(
          widget.titles.length,
          (i) => NavigationDestination(
            icon: Icon(widget.icons[i]),
            label: widget.titles[i],
          ),
        ),
      ),
    );
  }
}