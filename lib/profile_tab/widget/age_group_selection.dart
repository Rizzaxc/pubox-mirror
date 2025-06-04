import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/model/enum.dart';
import '../profile_state_provider.dart';

class AgeGroupSelection extends StatelessWidget {
  const AgeGroupSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileStateProvider>();
    final currentAgeGroup = profileState.ageGroup;

    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: const Text('Age Group'),
      subtitle: _buildAgeGroupText(currentAgeGroup),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showAgeGroupDialog(context, profileState, currentAgeGroup),
    );
  }

  Widget _buildAgeGroupText(AgeGroup? ageGroup) {
    if (ageGroup == null) {
      return const Text('Not set');
    }

    switch (ageGroup) {
      case AgeGroup.student:
        return const Text('Student');
      case AgeGroup.mature:
        return const Text('Mature');
      case AgeGroup.middleAge:
        return const Text('Middle Age');
      }
  }

  void _showAgeGroupDialog(
      BuildContext context, ProfileStateProvider profileState, AgeGroup? currentAgeGroup) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Age Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AgeGroup>(
                title: const Text('Student'),
                value: AgeGroup.student,
                groupValue: currentAgeGroup,
                onChanged: (AgeGroup? value) {
                  profileState.updateAgeGroup(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<AgeGroup>(
                title: const Text('Mature'),
                value: AgeGroup.mature,
                groupValue: currentAgeGroup,
                onChanged: (AgeGroup? value) {
                  profileState.updateAgeGroup(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<AgeGroup>(
                title: const Text('Middle Age'),
                value: AgeGroup.middleAge,
                groupValue: currentAgeGroup,
                onChanged: (AgeGroup? value) {
                  profileState.updateAgeGroup(value);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}