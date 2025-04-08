import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../core/model/enum.dart';
import 'state_provider.dart';

class TimeslotSelection extends StatelessWidget {
  const TimeslotSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateProvider>(
      builder: (context, stateProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              children: [
                Icon(PlatformIcons(context).timeSolid),
                Text('Thời Gian',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selection status indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Chọn: ${stateProvider.timeSlots.length}/3',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: stateProvider.timeSlots.length < 3
                              ? Colors.black87
                              : Colors.red,
                        ),
                      ),
                    ),

                    // Selected timeslots display - shown only when there are selections
                    if (stateProvider.timeSlots.isNotEmpty)
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: stateProvider.timeSlots.map((timeSlot) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: _buildTimeSlotChip(
                                    label:
                                        '${timeSlot.dayChunk.getShortName()} ${timeSlot.dayOfWeek.getShortName()}',
                                    isSelected: true,
                                    onTap: () =>
                                        stateProvider.removeTimeSlot(timeSlot),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                    // Selection controls
                    _buildTimeSlotSelectors(context, stateProvider),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeSlotSelectors(
      BuildContext context, HomeStateProvider stateProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 8,
        children: [
          Expanded(
            child: _buildDayOfWeekDropdown(context, stateProvider),
          ),
          Expanded(
            child: _buildDayChunkDropdown(context, stateProvider),
          ),
          PlatformIconButton(
            padding: EdgeInsets.zero,
            cupertino: (_, __) =>
                CupertinoIconButtonData(sizeStyle: CupertinoButtonSize.large),
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: stateProvider.canAddTimeSlot
                ? stateProvider.addCurrentTimeSlotSelection
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDayOfWeekDropdown(
      BuildContext context, HomeStateProvider stateProvider) {
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
              value: stateProvider.selectedDayOfWeek,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              menuMaxHeight: 200,
              borderRadius: BorderRadius.circular(8),
              items: DayOfWeek.values.map((day) {
                return DropdownMenuItem<DayOfWeek>(
                  value: day,
                  child: Text(
                    day.getFullName(),
                    maxLines: 2,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              }).toList(),
              onChanged: (DayOfWeek? value) {
                if (value != null) stateProvider.updateSelectedDayOfWeek(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayChunkDropdown(
      BuildContext context, HomeStateProvider stateProvider) {
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
              value: stateProvider.selectedDayChunk,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              menuMaxHeight: 200,
              borderRadius: BorderRadius.circular(8),
              items: DayChunk.values.map((chunk) {
                return DropdownMenuItem<DayChunk>(
                  value: chunk,
                  child: Text(
                    chunk.getFullName(),
                    maxLines: 2,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) stateProvider.updateSelectedDayChunk(value);
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
}
