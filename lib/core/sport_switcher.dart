import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:pubox/core/icons/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedSport extends ChangeNotifier {
  static const storedSportKey = 'STORED_SPORT_PERSISTENT_KEY';

  SelectedSport._() {
    loadFromStorage();
  }
  static final _instance = SelectedSport._();
  static SelectedSport get instance => _instance;

  int _id = 0;
  int get id => _id;

  Future<void> loadFromStorage() async {
    final localStorage = SharedPreferencesAsync();
    final storedSport = await localStorage.getInt(storedSportKey) ?? 0;
    if (storedSport != _id) {
      change(storedSport);
    }
  }

  Future<void> saveToStorage() async {
    final localStorage = SharedPreferencesAsync();

    await localStorage.setInt(storedSportKey, _id);
  }

  void change(int sport) {
    _id = sport;
    notifyListeners();
  }
}

class SportSwitcher extends StatelessWidget {
  const SportSwitcher._({super.key});

  static final _instance = SportSwitcher._();

  static SportSwitcher get instance => _instance;

  static const double appBarIconSize = 16;
  static const double menuItemIconSize = 12;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(), // TODO
      onClose: Provider.of<SelectedSport>(context, listen: false).saveToStorage,
      menuChildren: <Widget>[
        MenuItemButton(
            onPressed: () =>
                Provider.of<SelectedSport>(context, listen: false).change(0),
            child: Row(
              children: [
                SportIcons.soccer(size: menuItemIconSize),
                const Gap(12),
                const Text('Bóng Đá'),
              ],
            )),
        MenuItemButton(
          onPressed: () =>
              Provider.of<SelectedSport>(context, listen: false).change(1),
          child: Row(
            children: [
              SportIcons.basketball(size: menuItemIconSize),
              const Gap(12),
              const Text('Bóng Rổ'),
            ],
          ),
        ),
        MenuItemButton(
            onPressed: () =>
                Provider.of<SelectedSport>(context, listen: false).change(2),
            child: Row(
              children: [
                SportIcons.tennis(size: menuItemIconSize),
                const Gap(12),
                const Text('Tennis'),
              ],
            )),
        MenuItemButton(
            onPressed: () =>
                Provider.of<SelectedSport>(context, listen: false).change(3),
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
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Consumer<SelectedSport>(
              builder: (_, selectedSport, __) =>
                  _getSportIcon(selectedSport.id, appBarIconSize)),
        );
      },
    );
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
