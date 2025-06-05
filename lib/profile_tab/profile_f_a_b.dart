import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../core/utils.dart';
import 'profile_state_provider.dart';

class ProfileFAB extends StatelessWidget {
  const ProfileFAB({super.key});

  @override
  Widget build(BuildContext context) {

    return PlatformIconButton(
      onPressed: () async {
        // Commit changes to the server
        final ok = await context.read<ProfileStateProvider>().commitChanges();
        if (context.mounted) {
          if (ok) {
            context.showToast('Profile updated',
                type: ToastificationType.success);
          } else {
            context.showToast(genericErrorMessage,
                type: ToastificationType.error);
          }
        }
      },
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
    );
  }
}
