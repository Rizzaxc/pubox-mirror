import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../core/model/enum.dart';
import '../../core/model/timeslot.dart';

class TimeslotSelection extends StatefulWidget {

  const TimeslotSelection(
      {super.key, required this.onSelectionChanged, required this.initialSelection});

  final Function(List<Timeslot>) onSelectionChanged;
  final List<Timeslot> initialSelection;

  @override
  State<TimeslotSelection> createState() => _TimeslotSelectionState();
}

class _TimeslotSelectionState extends State<TimeslotSelection> {
  static const l10nKeyPrefix = 'homeTab.filter';

  final List<Timeslot> _selectedTimeslots = [];
  DayChunk _selectedDayChunk = DayChunk.noon;
  DayOfWeek _selectedDayOfWeek = DayOfWeek.everyday;

  @override
  void initState() {
    _selectedTimeslots.addAll(widget.initialSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          children: [
            Icon(PlatformIcons(context).timeSolid),
            Text(context.tr('$l10nKeyPrefix.time'), // homeTab.filter.time.title
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Card(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selection status indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${_selectedTimeslots.length}/3', // homeTab.filter.time.selectionCount
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedTimeslots.length < 3
                          ? Colors.black87
                          : Colors.red,
                    ),
                  ),
                ),

                // Selected timeslots display - shown only when there are selections
                if (_selectedTimeslots.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _selectedTimeslots
                              .map((timeSlot) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildTimeSlotChip(
                                label:
                                '${timeSlot.dayChunk.getShortName(context)} ${timeSlot.dayOfWeek.getShortName(context)}',
                                isSelected: true,
                                onTap: () => removeTimeSlot(timeSlot),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                // Selection controls
                _buildTimeSlotSelectors(context),
              ],
            ),
          ),
        ),
      ],
    );

  }

  Widget _buildTimeSlotSelectors(
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 8,
        children: [
          Expanded(
            child: _buildDayOfWeekDropdown(context),
          ),
          Expanded(
            child: _buildDayChunkDropdown(context),
          ),
          PlatformIconButton(
            padding: EdgeInsets.zero,
            cupertino: (_, __) =>
                CupertinoIconButtonData(sizeStyle: CupertinoButtonSize.large),
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: () => addTimeSlot()
          ),
        ],
      ),
    );
  }

  Widget _buildDayOfWeekDropdown(
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('$l10nKeyPrefix.weekdayLabel'), // homeTab.filter.time.dayLabel
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

  Widget _buildDayChunkDropdown(
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('$l10nKeyPrefix.dayChunkLabel'), // homeTab.filter.time.dayLabel
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

  void removeTimeSlot(Timeslot timeSlot) {
    setState(() {
      _selectedTimeslots.remove(timeSlot);
      widget.onSelectionChanged(_selectedTimeslots);
    });
  }

  void addTimeSlot() {
    if (_selectedTimeslots.length >= 3) return;
    final toAdd = Timeslot(_selectedDayOfWeek, _selectedDayChunk);
    if (_selectedTimeslots.contains(toAdd)) return;
    setState(() {
      _selectedTimeslots.add(toAdd);
      widget.onSelectionChanged(_selectedTimeslots);
    });
  }

}
