import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../model.dart';

class ScheduleItem extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;

  const ScheduleItem({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('h:mm a').format(appointment.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (appointment.location != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appointment.location!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (appointment.professionalName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (appointment.professionalAvatar != null)
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(appointment.professionalAvatar!),
                      )
                    else
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      appointment.professionalName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (appointment.participants != null && appointment.participants!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.tr('manageTab.schedule.participants', namedArgs: {
                        'count': appointment.participants!.length.toString(),
                      }),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData iconData;
    Color color;

    switch (appointment.type) {
      case AppointmentType.professionalBooking:
        iconData = Icons.school_outlined;
        color = Colors.blue;
        break;
      case AppointmentType.playSession:
        iconData = Icons.sports_tennis_outlined;
        color = Colors.green;
        break;
      case AppointmentType.tournament:
        iconData = Icons.emoji_events_outlined;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        size: 20,
        color: color,
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;

    switch (appointment.status) {
      case AppointmentStatus.pending:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case AppointmentStatus.confirmed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case AppointmentStatus.cancelled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case AppointmentStatus.completed:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        appointment.status.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}