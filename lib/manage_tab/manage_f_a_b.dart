import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../core/pubox_fab.dart';
import 'manage_state_provider.dart';

class ManageFAB extends StatelessWidget {
  const ManageFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ManageStateProvider>(
      builder: (context, fetchState, _) {
        final isLoading = fetchState.isLoading;
        return PuboxFab(
          onPressed: context.read<ManageStateProvider>().startLoading,
          isLoading: isLoading,
          icon: Icon(
            PlatformIcons(context).add,
          ),
        );
      },
    );
  }
}
