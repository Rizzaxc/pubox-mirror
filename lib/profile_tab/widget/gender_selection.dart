import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
import '../../core/model/enum.dart';
import '../profile_state_provider.dart';

const l10nKeyPrefix = "profileView";

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
    late Widget leadingIcon;

    if (gender == null) {
      subtitle = context.tr('not_set');
      leadingIcon = PuboxIcons.gender;
    } else if (gender == Gender.male) {
      subtitle = gender.getLocalizedName(context);
      leadingIcon = PuboxIcons.male;
    } else if (gender == Gender.female) {
      subtitle = gender.getLocalizedName(context);
      leadingIcon = PuboxIcons.female;
    }

    return ListTile(
      leading: leadingIcon,
      title: Text(context.tr('$l10nKeyPrefix.genderLabel')),
      subtitle: Text(subtitle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showGenderModal(context, gender),
    );
  }

  void _showGenderModal(BuildContext context, Gender? currentGender) {
    final profileState =
        Provider.of<ProfileStateProvider>(context, listen: false);

    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      cupertino: CupertinoModalSheetData(
          barrierDismissible: true, semanticsDismissible: true),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        snap: true,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('$l10nKeyPrefix.genderLabel'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PlatformTextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.tr('done')),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'TODO',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                      RadioListTile<Gender>(
                        title: Text(Gender.male.getLocalizedName(context)),
                        value: Gender.male,
                        groupValue: currentGender,
                        onChanged: (Gender? value) {
                          profileState.updateGender(value);
                          Navigator.of(context).pop();
                        },
                      ),
                      RadioListTile<Gender>(
                        title: Text(Gender.female.getLocalizedName(context)),
                        value: Gender.female,
                        groupValue: currentGender,
                        onChanged: (Gender? value) {
                          profileState.updateGender(value);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIOSGenderListTile(BuildContext context, Gender? gender) {
    late final Widget? choice;
    late final Widget leadingIcon;

    if (gender == null) {
      choice = null;
      leadingIcon = PuboxIcons.gender;
    } else if (gender == Gender.male) {
      choice = Text(gender.getLocalizedName(context));
      leadingIcon = PuboxIcons.male;
    } else if (gender == Gender.female) {
      choice = Text(gender.getLocalizedName(context));
      leadingIcon = PuboxIcons.female;
    }

    return CupertinoListTile.notched(
      title: Text(context.tr('$l10nKeyPrefix.genderLabel')),
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
        middle: Text(context.tr('$l10nKeyPrefix.genderLabel')),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'TODO',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ),
            CupertinoListSection.insetGrouped(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              children: [
                CupertinoListTile.notched(
                    title: Text(Gender.male.getLocalizedName(context)),
                    trailing: gender == Gender.male
                        ? const Icon(CupertinoIcons.check_mark)
                        : null,
                    onTap: () => context
                        .read<ProfileStateProvider>()
                        .updateGender(Gender.male)),
                CupertinoListTile.notched(
                  title: Text(Gender.female.getLocalizedName(context)),
                  trailing: gender == Gender.female
                      ? const Icon(CupertinoIcons.check_mark)
                      : null,
                  onTap: () => context
                      .read<ProfileStateProvider>()
                      .updateGender(Gender.female),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
