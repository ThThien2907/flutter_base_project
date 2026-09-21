import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/features/shell/presentation/bloc/shell_event.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  final ShellTab currentTab;
  final ValueChanged<ShellTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentTab.index,
      onDestinationSelected: (index) {
        if (index >= 0 && index < ShellTab.values.length) {
          onTabChanged(ShellTab.values[index]);
        }
      },
      backgroundColor: colorScheme.surface,
      elevation: 3,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_rounded),
          label: 'shell.home_tab'.tr(),
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings_rounded),
          label: 'shell.settings_tab'.tr(),
        ),
      ],
    );
  }
}
