import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
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
  redirect: (context, state) {
    // Check if user is logged in before any routes are rendered
    if (supabase.auth.currentSession == null) return null;
    if (supabase.auth.currentSession!.isExpired) return null;
    // If the user is trying to access the welcome screen but is already logged in,
    // redirect them to the home screen
    if (state.matchedLocation == '/welcome') {
      return '/home';
    }
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
      redirect: (context, state) {
        if (supabase.auth.currentSession == null) return null;
        if (supabase.auth.currentSession!.isExpired) return null;
        // if user is logged in, redirect to home
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
                GoRoute(
                    path: 'teammate',
                    builder: (context, state) {
                      return HomeTab.withInitialTab(0);
                    }),
                GoRoute(
                    path: 'challenger',
                    builder: (context, state) {
                      return HomeTab.withInitialTab(1);
                    }),
                GoRoute(
                    path: 'neutral',
                    builder: (context, state) {
                      return HomeTab.withInitialTab(2);
                    }),
                GoRoute(
                    path: 'location',
                    builder: (context, state) {
                      return HomeTab.withInitialTab(3);
                    }),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/manage',
              builder: (context, state) {
                return const ManageTab();
              },
              routes: <RouteBase>[],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/health',
              builder: (context, state) => const HealthTab(),
              routes: <RouteBase>[],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              redirect: (context, state) {
                if (supabase.auth.currentSession == null) {
                  return '/profile/auth';
                }
                return null;
              },
              builder: (context, state) => ProfileTab(),
              routes: <RouteBase>[
                GoRoute(
                    path: 'auth',
                    pageBuilder: (context, state) {
                      return BottomSheetPage(
                          isDismissible: false,
                          enableDrag: false,
                          constrains: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height <
                                      900
                                  ? MediaQuery.of(context).size.height * 0.85
                                  : MediaQuery.of(context).size.height * 0.75),
                          builder: (context) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 40, top: 12),
                              child: AuthForm.instance,
                            );
                          });
                    }),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
