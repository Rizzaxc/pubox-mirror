import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
import '../../core/model/enum.dart';
import '../../core/model/timeslot.dart';
import '../profile_state_provider.dart';

const l10nKeyPrefix = "profileView";

class PlaytimeSelection extends StatelessWidget {
  const PlaytimeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return isCupertino(context)
        ? _buildIOSPlaytimeListTile(context)
        : _buildAndroidPlaytimeListTile(context);
  }

  Widget _buildAndroidPlaytimeListTile(BuildContext context) {
    return ListTile(
      leading: PuboxIcons.playtime,
      title: Text(context.tr('$l10nKeyPrefix.playtimeLabel')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _showTimeslotModal(context),
    );
  }

  void _showTimeslotModal(BuildContext context) {
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
        initialChildSize: 0.35,
        minChildSize: 0.35,
        maxChildSize: 0.40,
        snap: true,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('$l10nKeyPrefix.playtimeLabel'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PlatformTextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                ),

                PlaytimeSelectionModal()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIOSPlaytimeListTile(BuildContext context) {
    return CupertinoListTile.notched(
      title: Text(context.tr('$l10nKeyPrefix.playtimeLabel')),
      leading: PuboxIcons.playtime,
      trailing: const CupertinoListTileChevron(),
      onTap: () => _showTimeslotModal(context),
    );
  }
}

class PlaytimeSelectionModal extends StatefulWidget {
  const PlaytimeSelectionModal({super.key});

  @override
  State<PlaytimeSelectionModal> createState() => _PlaytimeSelectionModalState();
}

class _PlaytimeSelectionModalState extends State<PlaytimeSelectionModal> {
  DayChunk _selectedDayChunk = DayChunk.noon;
  DayOfWeek _selectedDayOfWeek = DayOfWeek.everyday;

  @override
  Widget build(BuildContext context) {
    final selectedTimeslots = context.select<ProfileStateProvider, List<Timeslot>>(
      (provider) => provider.playtime ?? [],
    );

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selection status indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Chọn: ${selectedTimeslots.length}/3',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    selectedTimeslots.length < 3 ? Colors.black87 : Colors.red,
              ),
            ),
          ),

          // Selected timeslots display - shown only when there are selections
          if (selectedTimeslots.isNotEmpty)
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: selectedTimeslots.map((timeSlot) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildTimeSlotChip(
                        label:
                            '${timeSlot.dayChunk.getShortName(context)} ${timeSlot.dayOfWeek.getShortName(context)}',
                        isSelected: true,
                        onTap: () => _removeTimeSlot(timeSlot),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Selection controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: _buildTimeSlotSelectors(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSelectors() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _buildDayOfWeekDropdown(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDayChunkDropdown(),
          ),
          PlatformIconButton(
              padding: EdgeInsets.zero,
              cupertino: (_, __) =>
                  CupertinoIconButtonData(sizeStyle: CupertinoButtonSize.large),
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () => _addTimeSlot()),
        ],
      ),
    );
  }

  Widget _buildDayOfWeekDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DayOfWeek>(
              isExpanded: true,
              value: _selectedDayOfWeek,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              menuMaxHeight: 200,
              borderRadius: BorderRadius.circular(8),
              items: DayOfWeek.values.map((day) {
                return DropdownMenuItem<DayOfWeek>(
                  value: day,
                  child: Text(
                    day.getFullName(context),
                    maxLines: 2,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              }).toList(),
              onChanged: (DayOfWeek? value) {
                if (value == null) return;
                setState(() {
                  _selectedDayOfWeek = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayChunkDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giờ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DayChunk>(
              isExpanded: true,
              value: _selectedDayChunk,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              menuMaxHeight: 200,
              borderRadius: BorderRadius.circular(8),
              items: DayChunk.values.map((chunk) {
                return DropdownMenuItem<DayChunk>(
                  value: chunk,
                  child: Text(
                    chunk.getFullName(context),
                    maxLines: 2,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedDayChunk = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 60),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: Colors.blue.shade700,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  void _removeTimeSlot(Timeslot timeSlot) {
    final provider = context.read<ProfileStateProvider>();
    final currentTimeslots = provider.playtime as List<Timeslot>? ?? [];
    final updatedTimeslots = List<Timeslot>.from(currentTimeslots)..remove(timeSlot);
    provider.updatePlaytime(updatedTimeslots);
  }

  void _addTimeSlot() {
    final provider = context.read<ProfileStateProvider>();
    final currentTimeslots = provider.playtime as List<Timeslot>? ?? [];

    if (currentTimeslots.length >= 3) return;

    final toAdd = Timeslot(_selectedDayOfWeek, _selectedDayChunk);
    if (currentTimeslots.contains(toAdd)) return;

    final updatedTimeslots = List<Timeslot>.from(currentTimeslots)..add(toAdd);
    provider.updatePlaytime(updatedTimeslots);
  }
}
