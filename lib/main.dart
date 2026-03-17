import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'pages/activity/activity_list_page.dart';
import 'pages/activity/activity_detail_page.dart';
import 'pages/activity/activity_register_page.dart';
import 'pages/knowledge/knowledge_list_page.dart';
import 'pages/knowledge/knowledge_detail_page.dart';
import 'pages/knowledge/knowledge_publish_page.dart';
import 'pages/mine/mine_page.dart';
import 'services/user_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: const MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/activity',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/activity',
            builder: (context, state) => const ActivityListPage(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) =>
                    ActivityDetailPage(id: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'register/:id',
                builder: (context, state) =>
                    ActivityRegisterPage(id: state.pathParameters['id']!),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/knowledge',
            builder: (context, state) => const KnowledgeListPage(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) =>
                    KnowledgeDetailPage(id: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'publish',
                builder: (context, state) => const KnowledgePublishPage(),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/mine',
            builder: (context, state) => const MinePage(),
          ),
        ]),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '活动 & 知识库',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: '活动',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: '知识库',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
