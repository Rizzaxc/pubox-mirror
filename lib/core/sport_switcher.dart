import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SportSwitcher extends StatefulWidget {
  const SportSwitcher({super.key});

  @override
  State<SportSwitcher> createState() => _SportSwitcherState();
}

class _SportSwitcherState extends State<SportSwitcher> {
  static const double appBarIconSize = 28;
  static const storedSportKey = 'STORED_SPORT_PERSISTENT_KEY';

  int selectedSport = 0;

  final FocusNode _buttonFocusNode =
      FocusNode(debugLabel: 'SportSwitcher Button');

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    setState(() {
      selectedSport = localStorage.getInt(storedSportKey) ?? 0;
    });
  }

  Future<void> _changeSport(int sport) async {
    setState(() {
      selectedSport = sport;
    });

    // Asynchronously save current state to storage
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setInt(storedSportKey, selectedSport); // do not await
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(), // TODO
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        MenuItemButton(
            onPressed: () => _changeSport(0),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.sports_soccer),
                ),
                Text('Bóng Đá'),
              ],
            )),
        MenuItemButton(
            onPressed: () => _changeSport(1),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.sports_tennis),
                ),
                Text('Tennis'),
              ],
            )),
        MenuItemButton(
          onPressed: () => _changeSport(2),
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.sports_basketball),
              ),
              Text('Bóng Rổ'),
            ],
          ),
        ),
      ],
      builder: (_, MenuController controller, Widget? child) {
        return IconButton(
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: _getSportIcon(selectedSport),
          iconSize: appBarIconSize,
        );
      },
    );
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }
}

Icon _getSportIcon(int value) {
  switch (value) {
    case 0:
      return Icon(Icons.sports_soccer);
    case 1:
      return Icon(Icons.sports_tennis);
    case 2:
      return Icon(Icons.sports_basketball);
    default:
      return Icon(Icons.question_mark);
  }
}
