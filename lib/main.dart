import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import 'core/network_provider.dart';
import 'core/player_provider.dart';
import 'core/sport_switcher.dart';
import 'health_tab/health_f_a_b.dart';
import 'home_tab/home_f_a_b.dart';
import 'home_tab/neutral_section/professional_state_provider.dart';
import 'home_tab/state_provider.dart';
import 'home_tab/teammate_section/teammate_state_provider.dart';
import 'manage_tab/manage_f_a_b.dart';
import 'manage_tab/manage_state_provider.dart';
import 'manage_tab/schedule_section/schedule_state_provider.dart';
import 'manage_tab/lobby_section/lobby_state_provider.dart';
import 'profile_tab/profile_f_a_b.dart';
import 'profile_tab/profile_state_provider.dart';
import 'router.dart';

Future<void> main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await dotenv.load();

  final env = dotenv.env['ENV'] ?? 'local';
  assert(env == 'local' || env == 'test' || env == 'live');

  final supabaseURL = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  await Supabase.initialize(url: supabaseURL, anonKey: supabaseAnonKey);

  // MobileAds.instance.initialize();

  // GoogleFonts.config.allowRuntimeFetching = env == 'local';
  GoogleFonts.config.allowRuntimeFetching = false;

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final sentryDSN = dotenv.env['SENTRY_DSN']!;
  const Map<String, double?> sampleRates = {
    'local': null,
    'test': 1,
    'live': 0.1
  };
  await SentryFlutter.init((options) {
    options.dsn = sentryDSN;
    options.tracesSampleRate = sampleRates[env];
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  },
      appRunner: () => runApp(EasyLocalization(
          supportedLocales: const [Locale('vi'), Locale('en')],
          path: 'assets/translations',
          startLocale: Locale('vi'),
          child: const Pubox())));
}

class Pubox extends StatelessWidget {
  const Pubox({super.key});

  // Root App
  @override
  Widget build(BuildContext context) {
    // Theming
    final themeMode = ThemeMode.light;
    final materialTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red.shade700, surface: Colors.green.shade50),
      primaryTextTheme: GoogleFonts.notoSerifTextTheme(),
      textTheme: GoogleFonts.notoSerifTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)))),
      buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      tabBarTheme: ThemeData().tabBarTheme.copyWith(
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: Colors.grey.shade800,
          dividerHeight: 0),
      // menuButtonTheme: MenuButtonThemeData(
      //   style: ButtonStyle(splashFactory: InkRipple.splashFactory),
      //     ),
      popupMenuTheme: PopupMenuThemeData(
        position: PopupMenuPosition.over,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder()
        },
      ),
    );
    final cupertinoTheme =
        MaterialBasedCupertinoThemeData(materialTheme: materialTheme);

    return PlatformProvider(
      settings:
          PlatformSettingsData(iosUseZeroPaddingForAppbarPlatformIcon: true),
      builder: (context) => PlatformTheme(
        themeMode: themeMode,
        materialLightTheme: materialTheme,
        cupertinoLightTheme: cupertinoTheme,
        builder: (context) => ToastificationWrapper(
          config: const ToastificationConfig(
              alignment: Alignment.topCenter,
              animationDuration: Duration(milliseconds: 250)),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<PlayerProvider>(
                  create: (_) => PlayerProvider()),

              ChangeNotifierProvider<NetworkProvider>.value(
                value: NetworkProvider.instance,
              ),

              ChangeNotifierProvider<SelectedSportProvider>.value(
                value: SelectedSportProvider.instance,
              ),

              // Home Screen
              ChangeNotifierProxyProvider<PlayerProvider, HomeStateProvider>(
                create: (context) => HomeStateProvider(
                  context.read<PlayerProvider>(),
                ),
                update: (_, playerProvider, previousHomeState) =>
                    previousHomeState ?? HomeStateProvider(playerProvider),
              ),
              ChangeNotifierProxyProvider2<HomeStateProvider,
                  SelectedSportProvider, TeammateStateProvider>(
                create: (context) => TeammateStateProvider(
                  context.read<HomeStateProvider>(),
                  context.read<SelectedSportProvider>(),
                ),
                update: (_, homeState, selectedSport, previousTeammateState) =>
                    previousTeammateState ??
                    TeammateStateProvider(
                      homeState,
                      selectedSport,
                    ),
              ),

              // Manage Screen
              ChangeNotifierProvider<ScheduleStateProvider>(
                  create: (_) => ScheduleStateProvider()),
              ChangeNotifierProvider<LobbyStateProvider>(
                  create: (_) => LobbyStateProvider()),
              ChangeNotifierProxyProvider4<PlayerProvider, SelectedSportProvider, 
                  LobbyStateProvider, ScheduleStateProvider, ManageStateProvider>(
                create: (context) => ManageStateProvider(
                  context.read<PlayerProvider>(),
                  context.read<SelectedSportProvider>(),
                  context.read<LobbyStateProvider>(),
                  context.read<ScheduleStateProvider>(),
                ),
                update: (_, player, sport, lobby, schedule, previousManageState) =>
                    previousManageState ?? ManageStateProvider(
                      player,
                      sport,
                      lobby,
                      schedule,
                    ),
              ),


              // Profile Screen
              ChangeNotifierProxyProvider2<PlayerProvider,
                  SelectedSportProvider, ProfileStateProvider>(
                create: (context) => ProfileStateProvider(
                    context.read<PlayerProvider>(),
                    context.read<SelectedSportProvider>()),
                update: (_, player, selectedSport, previousProfileState) =>
                previousProfileState ??
                    ProfileStateProvider(player, selectedSport),
              ),

              // Professional/Neutral Screen
              ChangeNotifierProxyProvider2<HomeStateProvider,
                  SelectedSportProvider, ProfessionalStateProvider>(
                create: (context) => ProfessionalStateProvider(
                  context.read<HomeStateProvider>(),
                  context.read<SelectedSportProvider>(),
                ),
                update: (_, homeState, selectedSport, previousProfessionalState) =>
                    previousProfessionalState ??
                    ProfessionalStateProvider(homeState, selectedSport),
              ),

            ],
            child: PlatformApp.router(
              title: 'Pubox',
              routerConfig: puboxRouter,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            ),
          ),
        ),
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

  static final tabIcons = <IconData>[
    CupertinoIcons.house_fill,
    Icons.edit_calendar_rounded,
    FontAwesomeIcons.heartPulse,
    CupertinoIcons.profile_circled
  ];

  // TODO: move into their own screen
  static final fabs = [HomeFAB(), ManageFAB(), HealthFAB(), ProfileFAB()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The StatefulNavigationShell from the associated StatefulShellRoute is
      // directly passed as the body of the Scaffold.
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: fabs[navigationShell.currentIndex],
      extendBody: true,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeIndex: navigationShell.currentIndex,
        backgroundColor: Colors.green.shade50,
        splashRadius: 0,
        inactiveColor: Colors.grey.shade600,
        activeColor: Colors.red.shade800,
        iconSize: 28,
        // borderWidth: 1,
        borderColor: Colors.green.shade900,
        onTap: (int index) => _onTap(context, index),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        notchMargin: 8,
        icons: tabIcons,
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
