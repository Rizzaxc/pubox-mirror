import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'core/utils.dart';
import 'health_tab/view.dart';
import 'home_tab/view.dart';
import 'main.dart';
import 'manage_tab/view.dart';
import 'profile_tab/view.dart';
import 'welcome_flow/auth_form.dart';
import 'welcome_flow/welcome_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionNav');

final supabase = Supabase.instance.client;

final GoRouter puboxRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  routes: <RouteBase>[
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
      redirect: (context, state) {
        // if user is logged in, redirect to home
        if (supabase.auth.currentSession == null) return null;
        if (supabase.auth.currentSession!.isExpired) return null;
        return '/home';
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Return the widget that implements the custom shell (in this case
        // using a BottomNavigationBar). The StatefulNavigationShell is passed
        // to be able access the state of the shell and to navigate to other
        // branches in a stateful way.
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // NavBar routes
        StatefulShellBranch(
          navigatorKey: _sectionANavigatorKey,
          preload: true,
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
              path: '/home',
              builder: (context, state) => HomeTab.instance,
              routes: <RouteBase>[
                // TODO: 4 tabs
                GoRoute(
                    path: '/home/teammate',
                    builder: (context, state) {
                      return const Center(child: Text('Teammate'));
                    }),
                GoRoute(
                    path: '/home/challenger',
                    builder: (context, state) {
                      return const Center(child: Text('Challenger'));
                    }),
                GoRoute(
                    path: '/home/neutral',
                    builder: (context, state) {
                      return const Center(child: Text('Neutral'));
                    }),
                GoRoute(
                    path: '/home/location',
                    builder: (context, state) {
                      return const Center(child: Text('Location'));
                    }),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/manage',
              redirect: (context, state) {
                if (supabase.auth.currentSession == null) return '/manage/auth';
                return null;
              },
              builder: (context, state) {
                return const ManageTab();
              },
              routes: <RouteBase>[
                GoRoute(
                    path: 'auth',
                    redirect: (context, state) {
                      if (supabase.auth.currentSession != null) return '/manage';
                      return null;
                    },
                    pageBuilder: (context, state) {
                      return BottomSheetPage(
                          isDismissible: false,
                          enableDrag: false,
                          constrains: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.8),
                          builder: (context) {
                            return const AuthForm();
                          });
                    }),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/health',
              redirect: (context, state) {
                if (supabase.auth.currentSession == null) return '/health/auth';
                return null;
              },
              builder: (context, state) => const HealthTab(),
              routes: <RouteBase>[
                GoRoute(
                    path: 'auth',
                    redirect: (context, state) {
                      if (supabase.auth.currentSession != null) return '/health';
                      return null;
                    },
                    pageBuilder: (context, state) {
                      return BottomSheetPage(
                          isDismissible: false,
                          enableDrag: false,
                          constrains: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.8),
                          builder: (context) {
                            return const AuthForm();
                          });
                    }),
              ],            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileTab(),
              routes: <RouteBase>[],
            ),
          ],
        ),
      ],
    ),
  ],
);
