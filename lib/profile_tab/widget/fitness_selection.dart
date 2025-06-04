import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile_state_provider.dart';

class FitnessSelection extends StatelessWidget {
  const FitnessSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileStateProvider>();
    final currentFitness = profileState.fitness;

    return ListTile(
      leading: const Icon(Icons.fitness_center),
      title: const Text('Fitness'),
      subtitle: Text(currentFitness != null ? 'Level $currentFitness' : 'Not set'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showFitnessDialog(context, profileState, currentFitness),
    );
  }

  void _showFitnessDialog(
      BuildContext context, ProfileStateProvider profileState, int? currentFitness) {
    int? selectedFitness = currentFitness;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Fitness Level'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 1; i <= 5; i++)
                    RadioListTile<int>(
                      title: Text('Level $i'),
                      value: i,
                      groupValue: selectedFitness,
                      onChanged: (int? value) {
                        setState(() {
                          selectedFitness = value;
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
                    profileState.updateFitness(selectedFitness);
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