import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pubox/health_tab/screen.dart';
import 'package:pubox/home_tab/screen.dart';
import 'package:pubox/manage_tab/screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);

  // MobileAds.instance.initialize();

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade400),
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
        appBar: AppBar(
            title: Text('Pubox'),
            backgroundColor: Colors.redAccent,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.account_circle))
            ]),
        body: TabBarView(
            controller: _tabController,
            children: [HomeTab(), ManageTab(), HealthTab()]),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          color: Colors.blueAccent.shade100,
          buttonBackgroundColor: Colors.redAccent.shade400,
          backgroundColor: Colors.white,
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
              _tabController.index = _page;
            });
          },
          letIndexChange: (index) => true,
        ));
  }
}
