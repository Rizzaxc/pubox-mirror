import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
import '../../core/model/enum.dart';
import '../profile_state_provider.dart';

const l10nKeyPrefix = "profileView";

class IndustrySelection extends StatelessWidget {
  const IndustrySelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = Provider.of<ProfileStateProvider>(context);
    final selectedIndustries = profileState.selectedIndustries;

    return isCupertino(context)
        ? _buildIOSIndustryListTile(context, selectedIndustries)
        : _buildAndroidIndustryListTile(context, selectedIndustries);
  }

  Widget _buildAndroidIndustryListTile(
      BuildContext context, List<Industry> selectedIndustries) {
    String subtitle;
    if (selectedIndustries.isEmpty) {
      subtitle = context.tr('not_set');
    } else if (selectedIndustries.length == 1) {
      subtitle = selectedIndustries[0].getLocalizedName(context);
    } else {
      subtitle =
          '${selectedIndustries[0].getLocalizedName(context)}, ${selectedIndustries[1].getLocalizedName(context)}';
    }

    return ListTile(
      leading: PuboxIcons.suitcase,
      title: Text(context.tr('$l10nKeyPrefix.industryLabel')),
      subtitle: Text(subtitle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showAndroidIndustryDialog(context, selectedIndustries),
    );
  }

  void _showAndroidIndustryDialog(
      BuildContext context, List<Industry> selectedIndustries) {
    final selectedIndustries =
        context.select<ProfileStateProvider, List<Industry>>(
            (provider) => provider.selectedIndustries);
    final industries = Industry.values;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('industry_selection_title')),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: industries.length,
              itemBuilder: (context, index) {
                final industry = industries[index];
                final isSelected = selectedIndustries.contains(industry);

                return CheckboxListTile(
                  title: Text(industry.getLocalizedName(context)),
                  value: isSelected,
                  onChanged: (bool? value) {
                    context
                        .read<ProfileStateProvider>()
                        .toggleIndustry(industry);
                  },
                );
              },
            ),
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

  Widget _buildIOSIndustryListTile(
      BuildContext context, List<Industry> selectedIndustries) {
    return CupertinoListTile.notched(
      title: Text(context.tr('$l10nKeyPrefix.industryLabel')),
      // additionalInfo: additionalInfo != null ? Text(additionalInfo) : null,

      leading: PuboxIcons.suitcase,
      trailing: const CupertinoListTileChevron(),
      onTap: () => _iosIndustryListPageBuilder(context),
    );
  }

  void _iosIndustryListPageBuilder(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const IndustryListPage(),
      ),
    );
  }
}

class IndustryListPage extends StatelessWidget {
  const IndustryListPage({super.key});

  final industries = Industry.values;

  @override
  Widget build(BuildContext context) {
    // final industries = Industry.values.sort((a, b) =>
    //     a.getLocalizedName(context).compareTo(b.getLocalizedName(context)));

    final selectedIndustries =
        context.select<ProfileStateProvider, List<Industry>>(
            (provider) => provider.selectedIndustries);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text(context.tr('$l10nKeyPrefix.industryLabel'))),
      child: SingleChildScrollView(
        child: SafeArea(
          child: CupertinoListSection.insetGrouped(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            children: industries.map((industry) {
              final isSelected = selectedIndustries.contains(industry);

              return CupertinoListTile.notched(
                title: Text(industry.getLocalizedName(context)),
                trailing:
                    isSelected ? const Icon(CupertinoIcons.check_mark) : null,
                onTap: () {
                  context.read<ProfileStateProvider>().toggleIndustry(industry);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
