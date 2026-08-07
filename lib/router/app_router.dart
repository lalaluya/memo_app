import 'package:flutter/material.dart';

import '../screens/about/about_screen.dart';
import '../screens/detail/memo_detail_screen.dart';
import '../screens/edit/memo_edit_screen.dart';
import '../screens/empty/empty_screen.dart';
import '../screens/my/my_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/tags/tag_filter_screen.dart';
import '../screens/tags/tags_cloud_screen.dart';
import '../widgets/tab_bar.dart';

class AppRoutes {
  static const home = '/';
  static const list = '/list';
  static const tags = '/tags';
  static const my = '/my';
  static const detail = '/detail';
  static const edit = '/edit';
  static const search = '/search';
  static const settings = '/settings';
  static const about = '/about';
  static const tagFilter = '/tag-filter';
  static const empty = '/empty';
}

/// 鑷畾涔夎矾鐢憋細鍙虫粦鍏?宸︽粦鍏ュ垏鎹㈠姩鐢伙紝瀵瑰簲鍘熷瀷 anim-forward / anim-backward
Route<T> slideRoute<T>(
  WidgetBuilder builder, {
  required bool forward,
}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (ctx, anim, sec) => builder(ctx),
    transitionsBuilder: (ctx, anim, sec, child) {
      final begin = forward
          ? const Offset(0.3, 0)
          : const Offset(-0.15, 0);
      final end = Offset.zero;
      final curve = Curves.easeOutCubic;
      final tween =
          Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
      final opacity = Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: curve))
          .animate(anim);
      return SlideTransition(
        position: anim.drive(tween),
        child: FadeTransition(opacity: opacity, child: child),
      );
    },
  );
}

Map<String, WidgetBuilder> appRoutes({
  required HomeTab currentTab,
  required void Function(HomeTab) onTabTap,
}) {
  return {
    AppRoutes.list: (ctx) => _HomeRoute(child: _Placeholder(), tab: currentTab, onTabTap: onTabTap),
    AppRoutes.tags: (ctx) => const _TagsScreenRoute(),
    AppRoutes.my: (ctx) => _MyScreenRoute(onTabTap: onTabTap),
    AppRoutes.detail: (ctx) {
      final id = ModalRoute.of(ctx)!.settings.arguments as int;
      return MemoDetailScreen(memoId: id);
    },
    AppRoutes.edit: (ctx) {
      final id = ModalRoute.of(ctx)!.settings.arguments as int?;
      return MemoEditScreen(memoId: id);
    },
    AppRoutes.search: (ctx) => const SearchScreen(),
    AppRoutes.settings: (ctx) => const SettingsScreen(),
    AppRoutes.about: (ctx) => const AboutScreen(),
    AppRoutes.tagFilter: (ctx) => const TagFilterScreen(),
    AppRoutes.empty: (ctx) => const EmptyScreen(),
  };
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _HomeRoute extends StatelessWidget {
  const _HomeRoute({required this.child, required this.tab, required this.onTabTap});
  final Widget child;
  final HomeTab tab;
  final void Function(HomeTab) onTabTap;
  @override
  Widget build(BuildContext context) => Container();
}

class _TagsScreenRoute extends StatelessWidget {
  const _TagsScreenRoute();
  @override
  Widget build(BuildContext context) => const TagsCloudScreen();
}

class _MyScreenRoute extends StatelessWidget {
  const _MyScreenRoute({required this.onTabTap});
  final void Function(HomeTab) onTabTap;
  @override
  Widget build(BuildContext context) => const MyScreen();
}
