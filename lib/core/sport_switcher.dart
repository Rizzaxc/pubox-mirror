import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'icons/main.dart';

import 'model/enum.dart';
import 'user_preferences.dart';

class SelectedSportProvider extends ChangeNotifier {
  static const _prefKey = 'STORED_SPORT_PERSISTENT_KEY';
  late final UserPreferences localStorage;
  bool _isInitialized = false;

  SelectedSportProvider._() {
    localStorage = UserPreferences.instance;
    loadFromStorage();
  }

  static final _instance = SelectedSportProvider._();

  static SelectedSportProvider get instance => _instance;

  int _id = 0;

  bool get isInitialized => _isInitialized;

  int get id => _id;

  Sport get self => Sport.values[_id];

  Future<void> loadFromStorage() async {
    _id = await localStorage.getInt(_prefKey) ?? 0;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> saveToStorage() async {
    await localStorage.setInt(_prefKey, _id);
  }

  void change(Sport sport) {
    _id = sport.index;
    saveToStorage();
    notifyListeners();
  }
}

class SportSwitcher extends StatelessWidget {
  SportSwitcher._();

  static final _instance = SportSwitcher._();

  static SportSwitcher get instance => _instance;

  static const double appBarIconSize = 16;
  static const double menuItemIconSize = 12;

  final labelBoxWidth = Platform.isIOS ? 96.0 : 72.0;
  Widget _buildMenuOptionChild(
      BuildContext context, Sport sport, String displayName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        _getSportIcon(sport, menuItemIconSize),
        SizedBox(
          width: labelBoxWidth,
          child: Text(
            displayName,
            maxLines: 1,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformPopupMenu(
      material: (_, __) => MaterialPopupMenuData(
          position: PopupMenuPosition.under,
          padding: EdgeInsets.zero,
          splashRadius: 32,
          constraints: BoxConstraints(maxWidth: 128),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200)),
          popUpAnimationStyle: AnimationStyle(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 250))),
      cupertino: (_, __) => CupertinoPopupMenuData(
        title: Text(
          'Chuyển Môn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      options: [
        PopupMenuOption(
          label: 'soccer',
          material: (_, __) => MaterialPopupMenuOptionData(
              child: _buildMenuOptionChild(context, Sport.soccer, 'Bóng Đá')),
          cupertino: (_, __) => CupertinoPopupMenuOptionData(
              child: _buildMenuOptionChild(context, Sport.soccer, 'Bóng Đá')),
          onTap: (_) =>
              context.read<SelectedSportProvider>().change(Sport.soccer),
        ),
        PopupMenuOption(
          label: 'basketball',
          material: (_, __) => MaterialPopupMenuOptionData(
              child:
                  _buildMenuOptionChild(context, Sport.basketball, 'Bóng Rổ')),
          cupertino: (_, __) => CupertinoPopupMenuOptionData(
              child:
                  _buildMenuOptionChild(context, Sport.basketball, 'Bóng Rổ')),
          onTap: (_) =>
              context.read<SelectedSportProvider>().change(Sport.basketball),
        ),
        PopupMenuOption(
          label: 'badminton',
          material: (_, __) => MaterialPopupMenuOptionData(
              child:
                  _buildMenuOptionChild(context, Sport.badminton, 'Cầu Lông')),
          cupertino: (_, __) => CupertinoPopupMenuOptionData(
              child:
                  _buildMenuOptionChild(context, Sport.badminton, 'Cầu Lông')),
          onTap: (_) =>
              context.read<SelectedSportProvider>().change(Sport.badminton),
        ),
        PopupMenuOption(
          label: 'tennis',
          material: (_, __) => MaterialPopupMenuOptionData(
              child: _buildMenuOptionChild(context, Sport.tennis, 'Tennis')),
          cupertino: (_, __) => CupertinoPopupMenuOptionData(
              child: _buildMenuOptionChild(context, Sport.tennis, 'Tennis')),
          onTap: (_) =>
              context.read<SelectedSportProvider>().change(Sport.tennis),
        ),
        PopupMenuOption(
          label: 'pickleball',
          material: (_, __) => MaterialPopupMenuOptionData(
              child: _buildMenuOptionChild(
                  context, Sport.pickleball, 'Pickleball')),
          cupertino: (_, __) => CupertinoPopupMenuOptionData(
              child: _buildMenuOptionChild(
                  context, Sport.pickleball, 'Pickleball')),
          onTap: (_) =>
              context.read<SelectedSportProvider>().change(Sport.pickleball),
        )
      ],
      icon: PlatformIconButton(
        padding: const EdgeInsets.all(8),
        icon: Consumer<SelectedSportProvider>(
            builder: (_, selectedSport, __) =>
                _getSportIcon(selectedSport.self, appBarIconSize)),
      ),
    );
  }
}

Widget _getSportIcon(Sport sport, double size) {
  switch (sport) {
    case Sport.soccer:
      return SportIcons.soccer(size: size);
    case Sport.basketball:
      return SportIcons.basketball(size: size);
    case Sport.badminton:
      return SportIcons.badminton(size: size);
    case Sport.tennis:
      return SportIcons.tennis(size: size);
    case Sport.pickleball:
      return SportIcons.pickleball(size: size);
    case Sport.others:
      return Icon(Icons.question_mark);
  }
}
