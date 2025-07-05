import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
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

  Widget _buildAndroidAgeGroupListTile(
      BuildContext context, AgeGroup? ageGroup) {
    late String subtitle;

    if (ageGroup == null) {
      subtitle = context.tr('not_set');
    } else {
      subtitle = ageGroup.getLocalizedName(context);
    }

    return ListTile(
      leading: PuboxIcons.age,
      title: Text(context.tr('$l10nKeyPrefix.ageGroupLabel')),
      subtitle: Text(subtitle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showAgeGroupModal(context, ageGroup),
    );
  }

  void _showAgeGroupModal(BuildContext context, AgeGroup? currentAgeGroup) {
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('$l10nKeyPrefix.ageGroupLabel'),
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
                        title:
                            Text(AgeGroup.middleAge.getLocalizedName(context)),
                        value: AgeGroup.middleAge,
                        groupValue: currentAgeGroup,
                        onChanged: (AgeGroup? value) {
                          profileState.updateAgeGroup(value);
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

  Widget _buildIOSAgeGroupListTile(BuildContext context, AgeGroup? ageGroup) {
    late final Widget? choice;

    if (ageGroup == null) {
      choice = null;
    } else {
      choice = Text(ageGroup.getLocalizedName(context));
    }

    return CupertinoListTile.notched(
      title: Text(context.tr('$l10nKeyPrefix.ageGroupLabel')),
      subtitle: choice,
      leading: PuboxIcons.age,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoListSection.insetGrouped(
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
          ],
        ),
      ),
    );
  }
}
