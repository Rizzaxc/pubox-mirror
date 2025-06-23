import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../model.dart';
import 'schedule_state_provider.dart';
import 'schedule_item.dart';

class ScheduleSection extends StatefulWidget {
  const ScheduleSection({super.key});

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            context.tr('manageTab.schedule.title'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          titleSpacing: 4,
          centerTitle: false,
          pinned: false,
          primary: false,
        ),
        Consumer<ScheduleStateProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (provider.appointments.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        Text(
                          context.tr('manageTab.schedule.empty.title'),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          context.tr('manageTab.schedule.empty.message'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Group appointments by date
            final groupedAppointments = _groupAppointmentsByDate(provider.appointments);

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final date = groupedAppointments.keys.elementAt(index);
                  final appointments = groupedAppointments[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          _formatDateHeader(date),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      // Appointments for this date
                      ...appointments.map((appointment) => ScheduleItem(
                        appointment: appointment,
                        onTap: () => _onAppointmentTap(appointment),
                      )),
                      const SizedBox(height: 16),
                    ],
                  );
                },
                childCount: groupedAppointments.length,
              ),
            );
          },
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 128),
        ),
      ],
    );
  }

  Map<DateTime, List<AppointmentModel>> _groupAppointmentsByDate(List<AppointmentModel> appointments) {
    final grouped = <DateTime, List<AppointmentModel>>{};
    
    for (final appointment in appointments) {
      final date = DateTime(
        appointment.startTime.year,
        appointment.startTime.month,
        appointment.startTime.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(appointment);
    }
    
    // Sort appointments within each day by start time
    for (final appointments in grouped.values) {
      appointments.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    
    return grouped;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    if (date.isAtSameMomentAs(today)) {
      return context.tr('manageTab.schedule.today');
    } else if (date.isAtSameMomentAs(tomorrow)) {
      return context.tr('manageTab.schedule.tomorrow');
    } else {
      return DateFormat('EEEE, MMM d').format(date);
    }
  }

  void _onAppointmentTap(AppointmentModel appointment) {
    // TODO: Navigate to appointment detail view
    // This could be a modal or a new page depending on the appointment type
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                appointment.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '${DateFormat('MMM d, yyyy • h:mm a').format(appointment.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              // TODO: Add more appointment details and actions
            ],
          ),
        ),
      ),
    );
  }
}