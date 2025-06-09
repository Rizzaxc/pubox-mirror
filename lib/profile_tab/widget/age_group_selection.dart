import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/model/enum.dart';
import '../profile_state_provider.dart';

const l10nKeyPrefix = "profileView";

class AgeGroupSelection extends StatelessWidget {
  const AgeGroupSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final ageGroup = context
        .select<ProfileStateProvider, AgeGroup?>((details) => details.ageGroup);

    return isCupertino(context)
        ? _buildIOSAgeGroupListTile(context, ageGroup)
        : _buildAndroidAgeGroupListTile(context, ageGroup);
  }

  Widget _buildAndroidAgeGroupListTile(BuildContext context, AgeGroup? ageGroup) {
    late String subtitle;
    late Icon leadingIcon;

    if (ageGroup == null) {
      subtitle = context.tr('not_set');
      leadingIcon = const Icon(Icons.question_mark);
    } else {
      subtitle = ageGroup.getLocalizedName(context);
      leadingIcon = const Icon(Icons.group);
    }

    return ListTile(
      leading: leadingIcon,
      title: Text(context.tr('$l10nKeyPrefix.ageGroupLabel')),
      subtitle: Text(subtitle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showAndroidAgeGroupDialog(context, ageGroup),
    );
  }

  void _showAndroidAgeGroupDialog(BuildContext context, AgeGroup? currentAgeGroup) {
    final profileState =
        Provider.of<ProfileStateProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('$l10nKeyPrefix.ageGroupLabel')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AgeGroup>(
                title: Text(AgeGroup.student.getLocalizedName(context)),
                value: AgeGroup.student,
                groupValue: currentAgeGroup,
                onChanged: (AgeGroup? value) {
                  profileState.updateAgeGroup(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<AgeGroup>(
                title: Text(AgeGroup.mature.getLocalizedName(context)),
                value: AgeGroup.mature,
                groupValue: currentAgeGroup,
                onChanged: (AgeGroup? value) {
                  profileState.updateAgeGroup(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<AgeGroup>(
                title: Text(AgeGroup.middleAge.getLocalizedName(context)),
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
              child: Text(context.tr('done')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIOSAgeGroupListTile(BuildContext context, AgeGroup? ageGroup) {
    late final Widget? choice;
    final leadingIcon = const Icon(CupertinoIcons.group_solid);

    if (ageGroup == null) {
      choice = null;
    } else {
      choice = Text(ageGroup.getLocalizedName(context));
    }

    return CupertinoListTile.notched(
      title: Text(context.tr('$l10nKeyPrefix.ageGroupLabel')),
      additionalInfo: choice,
      leading: leadingIcon,
      trailing: ageGroup != null
          ? CupertinoListTileChevron()
          : Icon(Icons.question_mark),
      onTap: () => _iosAgeGroupListPageBuilder(context),
    );
  }

  void _iosAgeGroupListPageBuilder(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => AgeGroupListPage(),
      ),
    );
  }
}

class AgeGroupListPage extends StatelessWidget {
  const AgeGroupListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ageGroup = context
        .select<ProfileStateProvider, AgeGroup?>((details) => details.ageGroup);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.tr('$l10nKeyPrefix.ageGroupLabel')),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          children: [
            CupertinoListTile.notched(
                title: Text(AgeGroup.student.getLocalizedName(context)),
                trailing: ageGroup == AgeGroup.student
                    ? const Icon(CupertinoIcons.check_mark)
                    : null,
                onTap: () => context
                    .read<ProfileStateProvider>()
                    .updateAgeGroup(AgeGroup.student)),
            CupertinoListTile.notched(
              title: Text(AgeGroup.mature.getLocalizedName(context)),
              trailing: ageGroup == AgeGroup.mature
                  ? const Icon(CupertinoIcons.check_mark)
                  : null,
              onTap: () => context
                  .read<ProfileStateProvider>()
                  .updateAgeGroup(AgeGroup.mature),
            ),
            CupertinoListTile.notched(
              title: Text(AgeGroup.middleAge.getLocalizedName(context)),
              trailing: ageGroup == AgeGroup.middleAge
                  ? const Icon(CupertinoIcons.check_mark)
                  : null,
              onTap: () => context
                  .read<ProfileStateProvider>()
                  .updateAgeGroup(AgeGroup.middleAge),
            ),
          ],
        ),
      ),
    );
  }
}