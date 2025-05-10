import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class FabLoadStateProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> startLoading() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));

    _isLoading = false;
    notifyListeners();
  }
}

class SimpleFab extends StatelessWidget {
  const SimpleFab({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FabLoadStateProvider(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Consumer<FabLoadStateProvider>(
            builder: (context, state, _) {
              if (state.isLoading) {
                return const CircularProgressIndicator(
                  strokeWidth: 2,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          PlatformElevatedButton(
            onPressed: context.watch<FabLoadStateProvider>().isLoading
                ? null
                : onPressed,
            material: (_, __) => MaterialElevatedButtonData(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
            ),
            cupertino: (_, __) => CupertinoElevatedButtonData(
              padding: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(28),
            ),
            child: icon,
          ),
        ],
      ),
    );
  }
}
