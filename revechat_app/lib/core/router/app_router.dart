import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:revechat_app/features/auth/login_screen.dart';
import 'package:revechat_app/features/auth/org_selection_screen.dart';
import 'package:revechat_app/features/inbox/inbox_list_screen.dart';
import 'package:revechat_app/features/chat/chat_screen.dart';
import 'package:revechat_app/features/ai/ai_tab_screen.dart';
import 'package:revechat_app/features/contacts/contacts_screen.dart';
import 'package:revechat_app/features/orders/orders_screen.dart';
import 'package:revechat_app/features/profile/profile_screen.dart';
import 'package:revechat_app/shared/widgets/bottom_nav.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/org',
        builder: (context, state) => const OrgSelectionScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavScaffold(child: child),
        routes: [
          GoRoute(
            path: '/inbox',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InboxListScreen(),
            ),
          ),
          GoRoute(
            path: '/ai',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AiTabScreen(),
            ),
          ),
          GoRoute(
            path: '/contacts',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ContactsScreen(),
            ),
          ),
          GoRoute(
            path: '/orders',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: OrdersScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) => ChatScreen(
          conversationId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
