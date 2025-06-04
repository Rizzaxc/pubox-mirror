import 'package:flutter/material.dart';

import '../model.dart';

class TeammateResultItem extends StatelessWidget {
  final TeammateModel data;
  final Function(String)? onConnect;
  final Function()? onTap;
  final String? avatarUrl;

  const TeammateResultItem({
    super.key,
    required this.data,
    this.onConnect,
    this.onTap,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = _getTypeColor();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            right: BorderSide(
              color: borderColor,
              width: 4,
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildLocation(),
                const SizedBox(height: 12),
                _buildPlaytime(),
                const SizedBox(height: 16),
                _buildBottomRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (data.teammateResultType) {
      case TeammateResultType.lobby:
        return Colors.amber.shade600;
      case TeammateResultType.player:
        return Colors.purple.shade400;
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.resultTitle,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Text(
              //   _getResultTypeLabel(),
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //     color: Colors.grey.shade600,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    final size = 48.0;
    final color = _getTypeColor();

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: color.withValues(alpha: 0.2),
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    // Fallback to type-based icon
    final icon = data.teammateResultType == TeammateResultType.player
        ? Icons.person
        : Icons.group;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color.withValues(alpha: 0.2),
      child: Icon(
        icon,
        color: color,
        size: size / 2,
      ),
    );
  }

  String _getResultTypeLabel() {
    switch (data.teammateResultType) {
      case TeammateResultType.lobby:
        return 'Lobby';
      case TeammateResultType.player:
        return 'Player';
    }
  }

  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            data.location.join(', '),
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaytime() {
    final dayShortName = data.playtime.dayOfWeek.getShortName();
    final timeShortName = data.playtime.dayChunk.getShortName();
    final combinedLabel = '$timeShortName $dayShortName';

    return Row(
      children: [
        const Icon(Icons.access_time, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            combinedLabel,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCompatibilityScore(),
        _buildConnectButton(context),
      ],
    );
  }

  Widget _buildCompatibilityScore() {
    final scorePercentage = (data.compatScore * 100).round();
    final color = _getCompatibilityColor(data.compatScore);

    return Tooltip(
      message: 'Compatibility',
      triggerMode: TooltipTriggerMode.tap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$scorePercentage',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        if (onConnect != null) {
          onConnect!(data.searchableId);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      label: const Text('Connect'),
      icon: const Icon(Icons.person_add, size: 16),
    );
  }

  Color _getCompatibilityColor(double score) {
    if (score >= 0.85) return Colors.red.shade800; // High match
    if (score >= 0.70) return Colors.green.shade600; // Medium match
    return Colors.blue.shade500; // Basic match
  }
}
