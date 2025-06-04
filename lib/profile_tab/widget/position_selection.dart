import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile_state_provider.dart';

class PositionSelection extends StatelessWidget {
  const PositionSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileStateProvider>();
    final currentPosition = profileState.position;

    return ListTile(
      leading: const Icon(Icons.group_work),
      title: const Text('Position'),
      subtitle: Text(currentPosition ?? 'Not set'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showPositionDialog(context, profileState, currentPosition),
    );
  }

  void _showPositionDialog(
      BuildContext context, ProfileStateProvider profileState, String? currentPosition) {
    final TextEditingController controller = TextEditingController(text: currentPosition);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Position'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'e.g., Forward, Midfielder, etc.',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newPosition = controller.text.trim();
                if (newPosition.isNotEmpty) {
                  profileState.updatePosition(newPosition);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((_) => controller.dispose());
  }
}