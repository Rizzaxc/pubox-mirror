import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/model/enum.dart';
import '../profile_state_provider.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final gender = context
        .select<ProfileStateProvider, Gender?>((details) => details.gender);

    return isCupertino(context)
        ? _buildIOSGenderListTile(context, gender)
        : _buildAndroidGenderListTile(context, gender);
  }

  Widget _buildAndroidGenderListTile(BuildContext context, Gender? gender) {
    late String subtitle;
    late Icon leadingIcon;

    if (gender == null) {
      subtitle = 'Not Set';
      leadingIcon = const Icon(Icons.question_mark);
    } else if (gender == Gender.male) {
      subtitle = 'Nam';
      leadingIcon = const Icon(Icons.male);
    } else if (gender == Gender.female) {
      subtitle = 'Nữ';
      leadingIcon = const Icon(Icons.female);
    }

    return ListTile(
      leading: leadingIcon,
      title: const Text('Giới Tính'),
      subtitle: Text(subtitle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showAndroidGenderDialog(context, gender),
    );
  }

  void _showAndroidGenderDialog(BuildContext context, Gender? currentGender) {
    final profileState =
        Provider.of<ProfileStateProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Gender>(
                title: const Text('Nam'),
                value: Gender.male,
                groupValue: currentGender,
                onChanged: (Gender? value) {
                  profileState.updateGender(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<Gender>(
                title: const Text('Nữ'),
                value: Gender.female,
                groupValue: currentGender,
                onChanged: (Gender? value) {
                  profileState.updateGender(value);
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

  Widget _buildIOSGenderListTile(BuildContext context, Gender? gender) {
    late final Widget? choice;
    late final Widget leadingIcon;

    if (gender == null) {
      choice = null;
      leadingIcon = const Icon(Icons.transgender);
    } else if (gender == Gender.male) {
      choice = const Text(
        'Nam',
      );
      leadingIcon = const Icon(Icons.male);
    } else if (gender == Gender.female) {
      choice = const Text('Nữ');
      leadingIcon = const Icon(Icons.female);
    }

    return CupertinoListTile.notched(
      title: const Text('Giới Tính'),
      additionalInfo: choice,
      leading: leadingIcon,
      trailing: gender != null
          ? CupertinoListTileChevron()
          : Icon(Icons.question_mark),
      onTap: () => _iosGenderListPageBuilder(context),
    );
  }

  void _iosGenderListPageBuilder(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => GenderListPage(),
      ),
    );
  }
}

class GenderListPage extends StatelessWidget {
  const GenderListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final gender = context
        .select<ProfileStateProvider, Gender?>((details) => details.gender);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Gender'),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          children: [
            CupertinoListTile.notched(
                title: const Text('Nam'),
                trailing: gender == Gender.male
                    ? const Icon(CupertinoIcons.check_mark)
                    : null,
                onTap: () => context
                    .read<ProfileStateProvider>()
                    .updateGender(Gender.male)),
            CupertinoListTile.notched(
              title: const Text('Nữ'),
              trailing: gender == Gender.female
                  ? const Icon(CupertinoIcons.check_mark)
                  : null,
              onTap: () => context
                  .read<ProfileStateProvider>()
                  .updateGender(Gender.female),
            ),
          ],
        ),
      ),
    );
  }
}
