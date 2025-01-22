import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';


class PuboxFab extends StatelessWidget {
  const PuboxFab({
    super.key,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final Widget icon;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        isLoading
            ? Transform.scale(
                scale: 1.6,
                child: CircularProgressIndicator(
                  strokeWidth: 1.6,
                ),
              )
            : const SizedBox.shrink(),
        PlatformElevatedButton(
          onPressed: isLoading ? null : onPressed,
          material: (_, __) => MaterialElevatedButtonData(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              disabledBackgroundColor: Colors.grey.shade400,
            ),
          ),
          cupertino: (_, __) => CupertinoElevatedButtonData(
            // padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(28),
            padding: EdgeInsets.zero,
            disabledColor: Colors.grey.shade400,
            minSize: isLoading ? 52 : 56,
          ),
          color: Colors.green.shade600,
          child: icon,
        ),
      ],
    );
  }
}
