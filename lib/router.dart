import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'health_tab/view.dart';
import 'home_tab/view.dart';
import 'main.dart';
import 'manage_tab/view.dart';
import 'profile_tab/view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

final GoRouter puboxRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    // #docregion configuration-builder
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
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
              path: '/manage',
              builder: (context, state) => ManageTab(),
              routes: <RouteBase>[],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
              path: '/health',
              builder: (context, state) => HealthTab(),
              routes: <RouteBase>[],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
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
