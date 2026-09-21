import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_project/app/di/injection.dart';
import 'package:flutter_base_project/features/shell/presentation/bloc/shell_bloc.dart';
import 'package:flutter_base_project/features/shell/presentation/bloc/shell_state.dart';
import 'package:flutter_base_project/features/shell/presentation/views/home_tab_view.dart';
import 'package:flutter_base_project/features/shell/presentation/views/settings_tab_view.dart';
import 'package:flutter_base_project/features/shell/presentation/widgets/bottom_navigation.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final ShellBloc _shellBloc = getIt<ShellBloc>();

  @override
  void initState() {
    super.initState();
    _shellBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShellBloc, ShellState>(
      bloc: _shellBloc,
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentTab.index,
            children: const [HomeTabView(), SettingsTabView()],
          ),
          bottomNavigationBar: BottomNavigation(
            currentTab: state.currentTab,
            onTabChanged: _shellBloc.changeTab,
          ),
        );
      },
    );
  }
}
