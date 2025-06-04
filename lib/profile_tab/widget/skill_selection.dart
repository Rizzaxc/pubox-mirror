import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile_state_provider.dart';

class SkillSelection extends StatelessWidget {
  const SkillSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileStateProvider>();
    final currentSkill = profileState.skill;

    return ListTile(
      leading: const Icon(Icons.star),
      title: const Text('Skill'),
      subtitle: Text(currentSkill != null ? 'Level $currentSkill' : 'Not set'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showSkillDialog(context, profileState, currentSkill),
    );
  }

  void _showSkillDialog(
      BuildContext context, ProfileStateProvider profileState, int? currentSkill) {
    int? selectedSkill = currentSkill;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Skill Level'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 1; i <= 5; i++)
                    RadioListTile<int>(
                      title: Text('Level $i'),
                      value: i,
                      groupValue: selectedSkill,
                      onChanged: (int? value) {
                        setState(() {
                          selectedSkill = value;
                        });
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
                TextButton(
                  onPressed: () {
                    profileState.updateSkill(selectedSkill);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}