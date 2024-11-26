import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pubox/health_tab/view.dart';
import 'package:pubox/home_tab/home_f_a_b.dart';
import 'package:pubox/home_tab/view.dart';
import 'package:pubox/manage_tab/view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/sport_switcher.dart';
import 'health_tab/health_f_a_b.dart';
import 'manage_tab/manage_f_a_b.dart';
import 'profile_tab/profile_f_a_b.dart';
import 'profile_tab/view.dart';

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
  runApp(Pubox());
}

class Pubox extends StatelessWidget {
  const Pubox({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pubox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade800),
        textTheme: GoogleFonts.bitterTextTheme(),
        useMaterial3: true,
      ),
      home: _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar();

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar>
    with SingleTickerProviderStateMixin {
  int currentTabIndex = 0;

  static const appBarTitle = ['Home', 'Hội Nhóm', 'Sức Khoẻ', 'Profile'];
  final tabFABs = [
    HomeFAB(),
    ManageFAB(),
    HealthFAB(),
    ProfileFAB(),
  ];

  static var tabIcons = <IconData>[
    FontAwesomeIcons.house,
    FontAwesomeIcons.users,
    FontAwesomeIcons.heartPulse,
    FontAwesomeIcons.solidUser
  ];

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  // final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
          title: Text(
            appBarTitle[currentTabIndex],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_active_outlined)),
          backgroundColor: Colors.green.shade50,
          actions: [
            SportSwitcher.instance,
          ]),
      body: [
        HomeTab(),
        ManageTab(),
        HealthTab(),
        ProfileTab()
      ][currentTabIndex],
      extendBody: true,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        // color: Colors.blueAccent.shade100,
        // buttonBackgroundColor: Colors.redAccent.shade400,
        activeIndex: currentTabIndex,
        backgroundColor: Colors.green.shade100,
        splashRadius: 0,
        activeColor: Colors.red.shade900,
        icons: tabIcons,
        iconSize: 28,
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        notchMargin: 8,
      ),
      floatingActionButton: tabFABs[currentTabIndex],
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
