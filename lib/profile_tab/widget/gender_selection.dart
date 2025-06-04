import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/model/enum.dart';
import '../profile_state_provider.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileStateProvider>();
    final gender = profileState.gender;

    return ListTile(
      leading: Builder(
        builder: (BuildContext context) {
          if (gender == null) return const Icon(Icons.question_mark);
          if (gender == Gender.male) return const Icon(Icons.male);
          return const Icon(Icons.female);
        },
      ),
      title: const Text('Gender'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RadioListTile<Gender>(
                value: Gender.male,
                groupValue: gender,
                title: const Text('Nam'),
                selected: gender == Gender.male,
                onChanged: (value) => profileState.updateGender(value)),
          ),
          Expanded(
            child: RadioListTile<Gender>(
                value: Gender.female,
                groupValue: gender,
                title: const Text('Nữ'),
                selected: gender == Gender.female,
                onChanged: (value) => profileState.updateGender(value)),
          ),
        ],
      ),
    );
  }
}
