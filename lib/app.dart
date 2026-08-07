import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/memo_provider.dart';
import 'providers/settings_provider.dart';
import 'router/app_router.dart';
import 'screens/list/memo_list_screen.dart';
import 'screens/lock/lock_screen.dart';
import 'screens/my/my_screen.dart';
import 'screens/shell/phone_shell.dart';
import 'screens/tags/tags_cloud_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/tab_bar.dart';

class MemoApp extends ConsumerStatefulWidget {
  const MemoApp({super.key});
  @override
  ConsumerState<MemoApp> createState() => _MemoAppState();
}

class _MemoAppState extends ConsumerState<MemoApp> {
  HomeTab _tab = HomeTab.list;

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(effectivePaletteProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '鎷惧厜 路 鐑涚儸绗旇',
      theme: buildThemeData(palette),
      home: settings.lockEnabled
          ? LockScreen(onUnlock: () {
              ref.read(settingsProvider.notifier).setLockEnabled(false);
              Future.delayed(const Duration(milliseconds: 50), () {
                ref.read(settingsProvider.notifier).setLockEnabled(true);
              });
            })
          : PhoneShell(
              currentTab: _tab,
              showTabBar: true,
              onTabTap: (t) {
                setState(() => _tab = t);
                if (t == HomeTab.list) {
                  ref.read(activeTagProvider.notifier).state = null;
                }
              },
              child: _buildBody(),
            ),
      onGenerateRoute: (settings) {
        final routes = appRoutes(
          currentTab: _tab,
          onTabTap: (t) {
            setState(() => _tab = t);
            if (t == HomeTab.list) {
              ref.read(activeTagProvider.notifier).state = null;
            }
          },
        );
        final builder = routes[settings.name];
        if (builder == null) return null;
        return slideRoute<bool>(
          (ctx) => builder(ctx),
          forward: true,
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_tab) {
      case HomeTab.list:
        return MemoListScreen(onTabTap: (t) {
          setState(() => _tab = t);
          if (t == HomeTab.list) {
            ref.read(activeTagProvider.notifier).state = null;
          }
        });
      case HomeTab.tags:
        return const TagsCloudScreen();
      case HomeTab.my:
        return const MyScreen();
    }
  }
}