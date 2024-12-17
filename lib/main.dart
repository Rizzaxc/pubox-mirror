import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pubox/home_tab/home_f_a_b.dart';
import 'package:pubox/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/icons/pubox_icons.dart';
import 'core/sport_switcher.dart';
import 'core/utils.dart';
import 'core/player.dart';
import 'health_tab/health_f_a_b.dart';
import 'manage_tab/manage_f_a_b.dart';
import 'profile_tab/profile_f_a_b.dart';

Future<void> main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await dotenv.load();

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);

  // MobileAds.instance.initialize();

  final env = dotenv.env['ENV'] ?? 'dev';

  // GoogleFonts.config.allowRuntimeFetching = env == 'dev';
  GoogleFonts.config.allowRuntimeFetching = false;

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Pubox());
}

final supabase = Supabase.instance.client;

class Pubox extends StatelessWidget {
  const Pubox({super.key});

  // Root App
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Player(),
      child: MaterialApp.router(
        title: 'Pubox',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red.shade800, surface: Colors.green.shade50),
          textTheme: GoogleFonts.bitterTextTheme(),
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.android: ZoomPageTransitionsBuilder()
            },
          ),        ),
        routerConfig: puboxRouter,
      ),
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  static var tabIcons = <IconData>[
    CupertinoIcons.house_fill,
    Icons.edit_calendar_rounded,
    FontAwesomeIcons.heartPulse,
    PuboxIcons.profile
  ];

  // TODO: move into their own screen
  static const fabs = [HomeFAB(), ManageFAB(), HealthFAB(), ProfileFAB()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The StatefulNavigationShell from the associated StatefulShellRoute is
      // directly passed as the body of the Scaffold.
      body: navigationShell,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: fabs[navigationShell.currentIndex],
      extendBody: true,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeIndex: navigationShell.currentIndex,
        backgroundColor: Colors.green.shade100,
        splashRadius: 0,
        activeColor: Colors.red.shade900,
        icons: tabIcons,
        iconSize: 28,
        borderWidth: 1,
        borderColor: Colors.green.shade900,
        onTap: (int index) => _onTap(context, index),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        notchMargin: 8,
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

//
// class _BottomNavBar extends StatefulWidget {
//   const _BottomNavBar();
//
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<_BottomNavBar>
//     with SingleTickerProviderStateMixin {
//   int currentTabIndex = 0;
//   // late final StreamSubscription<AuthState> _authStateSubscription;
//
//   static const appBarTitle = ['Home', 'Quản Lý', 'Sức Khoẻ', 'Profile'];
//
//
//
//
//
//   @override
//   void initState() {
//     // _authStateSubscription = supabase.auth.onAuthStateChange.listen(
//     //   (data) {
//     //     final session = data.session;
//     //   },
//     //   onError: (error) {},
//     // );
//
//     super.initState();
//     // _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     // _tabController.dispose();
//     // _authStateSubscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(
//             appBarTitle[currentTabIndex],
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           leading: IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.notifications_active_outlined)),
//           actions: [
//             SportSwitcher.instance,
//           ]),
//       body: [
//         HomeTab.instance,
//         ManageTab(),
//         HealthTab(),
//         ProfileTab()
//       ][currentTabIndex],
//       extendBody: true,
//
//
//     );
//   }
// }
