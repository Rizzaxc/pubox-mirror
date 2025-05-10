import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ProfileFAB extends StatelessWidget {
  const ProfileFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {}, // open fullscreen modal
      onDoubleTap: () {}, // reload
      child: PlatformIconButton(
        onPressed: () {}, // open submenu
        color: Colors.green.shade600,
        padding: EdgeInsets.zero,
        icon: Icon(
          PlatformIcons(context).checkMark,
          color: Colors.white,
          size: 24,
        ),
        cupertino: (_, __) => CupertinoIconButtonData(
            borderRadius: BorderRadius.circular(32), minSize: 56),
        material: (_, __) => MaterialIconButtonData(
          padding: EdgeInsets.all(16),
          iconSize: 24,
        ),
      ),
    );
  }
}
