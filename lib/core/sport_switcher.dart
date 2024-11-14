import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SportSwitcher extends StatefulWidget {
  const SportSwitcher({super.key});

  @override
  _SportSwitcherState createState() => _SportSwitcherState();
}

class _SportSwitcherState extends State<SportSwitcher> {
  static const double appBarIconSize = 28;
  late final Icon _buttonIcon;

  // Initialize from persistence layer
  @override
  void initState() {
    super.initState();
    _buttonIcon = Icon(FontAwesomeIcons.basketball);
  }

  @override
  Widget build(BuildContext context) {
    // _buttonIcon = Icon(Icons.sports_soccer);
    return IconButton(
      onPressed: () {}, icon: Icon(FontAwesomeIcons.basketball),
      iconSize: appBarIconSize,
    );
  }
}
