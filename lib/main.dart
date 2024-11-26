import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubox/health_tab/view.dart';
import 'package:pubox/home_tab/home_f_a_b.dart';
import 'package:pubox/home_tab/view.dart';
import 'package:pubox/manage_tab/view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/sport_switcher.dart';
import 'health_tab/health_f_a_b.dart';
import 'manage_tab/manage_f_a_b.dart';

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
  GoogleFonts.config.allowRuntimeFetching = env == 'dev';

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
        // textTheme: GoogleFonts.playfairDisplayTextTheme(),
        // textTheme: GoogleFonts.nunitoTextTheme(),
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
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late TabController _tabController;

  static const appBarTitle = ['Home', 'Hội Nhóm', 'Sức Khoẻ'];
  final tabFAB = [
    HomeFAB(),
    ManageFAB(),
    HealthFAB(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
          toolbarHeight: 60,
          title: Text(
            appBarTitle[_tabController.index],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green.shade50,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.account_circle,
                size: 32,
              )),
          actions: [
            SportSwitcher.instance,
          ]),
      body: TabBarView(
          controller: _tabController,
          children: [HomeTab(), ManageTab(), HealthTab()]),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        color: Colors.blueAccent.shade100,
        buttonBackgroundColor: Colors.redAccent.shade400,
        backgroundColor: Colors.green.shade50,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.groups,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            FontAwesomeIcons.heartPulse,
            size: 26,
            color: Colors.white,
          ),
        ],
        animationCurve: Curves.easeIn,
        animationDuration: Duration(milliseconds: 250),
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      floatingActionButton: tabFAB[_tabController.index],
    );
  }
}
