import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pubox/core/icons/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Singleton that dictates which sport (aka mode) is currently active
class SportSwitcher extends StatefulWidget {
  const SportSwitcher._();
  /// the one and only instance of this singleton
  static final instance = SportSwitcher._();
  @override
  State<SportSwitcher> createState() => _SportSwitcherState();
}

class _SportSwitcherState extends State<SportSwitcher> with WidgetsBindingObserver {
  static const double appBarIconSize = 16;
  static const double menuItemIconSize = 12;
  static const storedSportKey = 'STORED_SPORT_PERSISTENT_KEY';

  int selectedSport = 0;

  final FocusNode _buttonFocusNode =
      FocusNode(debugLabel: 'SportSwitcher Button');

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _loadFromStorage() async {
    final localStorage = SharedPreferencesAsync();
    final storedSport = await localStorage.getInt(storedSportKey) ?? 0;
    setState(() {
      selectedSport = storedSport;
    });
  }

  Future<void> _saveToStorage() async {
    final localStorage = SharedPreferencesAsync();
    await localStorage.setInt(storedSportKey, selectedSport);
  }

  // also triggers dep reload
  Future<void> _changeSport(int sport) async {
    setState(() {
      selectedSport = sport;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(), // TODO
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        MenuItemButton(
            onPressed: () => _changeSport(0),
            child: Row(
              children: [
                SportIcons.soccer(size: menuItemIconSize),
                const Gap(12),
                const Text('Bóng Đá'),
              ],
            )),

        MenuItemButton(
          onPressed: () => _changeSport(1),
          child: Row(
            children: [
              SportIcons.basketball(size: menuItemIconSize),
              const Gap(12),
              const Text('Bóng Rổ'),
            ],
          ),
        ),
        MenuItemButton(
            onPressed: () => _changeSport(2),
            child: Row(
              children: [
                SportIcons.tennis(size: menuItemIconSize),
                const Gap(12),
                const Text('Tennis'),
              ],
            )),

        MenuItemButton(
            onPressed: () => _changeSport(3),
            child: Row(
              children: [
                SportIcons.badminton(size: menuItemIconSize),
                const Gap(12),
                const Text('Cầu Lông'),
              ],
            )),
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
          icon: _getSportIcon(selectedSport, appBarIconSize),
        );
      },
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await _saveToStorage();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

Widget _getSportIcon(int value, double size) {
  switch (value) {
    case 0:
      return SportIcons.soccer(size: size);
    case 1:
      return SportIcons.basketball(size: size);
    case 2:
      return SportIcons.tennis(size: size);
    case 3:
      return SportIcons.badminton(size: size);
    default:
      return Icon(Icons.question_mark, size: size);
  }
}
