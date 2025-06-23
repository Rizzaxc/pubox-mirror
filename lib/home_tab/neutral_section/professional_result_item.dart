import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/icons/main.dart';
import '../model.dart';

class ProfessionalResultItem extends StatelessWidget {
  final ProfessionalModel professional;
  final VoidCallback? onBookingTap;
  final VoidCallback? onTap;

  const ProfessionalResultItem({
    super.key,
    required this.professional,
    this.onBookingTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap ?? () => _showProfessionalDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and basic info
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: professional.avatarUrl != null
                        ? NetworkImage(professional.avatarUrl!)
                        : null,
                    child: professional.avatarUrl == null
                        ? PuboxIcons.coach
                        : null,
                  ),
                  const SizedBox(width: 12),
                  
                  // Name and role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          professional.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildRoleBadge(context),
                            if (professional.isVerified) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: Colors.blue.shade600,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Rating
                  if (professional.rating != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRatingColor(professional.rating!).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: _getRatingColor(professional.rating!),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            professional.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              color: _getRatingColor(professional.rating!),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Bio/Description
              if (professional.bio.isNotEmpty)
                Text(
                  professional.bio,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
              
              // Services and pricing
              if (professional.services.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: professional.services.take(3).map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        service.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
              
              // Action buttons
              Row(
                children: [
                  // Experience/Reviews count
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.history_edu,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.tr('homeTab.professional.experience', namedArgs: {
                            'years': professional.experienceYears.toString(),
                          }),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.reviews,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.tr('homeTab.professional.reviews', namedArgs: {
                            'count': professional.reviewCount.toString(),
                          }),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  
                  // Book button
                  ElevatedButton.icon(
                    onPressed: onBookingTap,
                    icon: const Icon(Icons.event_available, size: 16),
                    label: Text(context.tr('homeTab.professional.book')),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context) {
    final roleColor = professional.role == ProfessionalRole.coach
        ? Colors.green
        : Colors.orange;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: roleColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: roleColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        context.tr('homeTab.professional.role.${professional.role.name}'),
        style: TextStyle(
          color: roleColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.orange;
    if (rating >= 3.0) return Colors.amber;
    return Colors.red;
  }

  void _showProfessionalDetails(BuildContext context) {
    // TODO: Navigate to professional details page
    // This could be a full-screen modal or a new route
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        useSafeArea: true,
      ),
      builder: (context) => ProfessionalDetailsPage(professional: professional),
    );
  }
}

/// Professional details page (placeholder)
class ProfessionalDetailsPage extends StatelessWidget {
  final ProfessionalModel professional;

  const ProfessionalDetailsPage({
    super.key,
    required this.professional,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(professional.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: professional.avatarUrl != null
                        ? NetworkImage(professional.avatarUrl!)
                        : null,
                    child: professional.avatarUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    professional.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // TODO: Add more professional details
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Bio section
            Text(
              context.tr('homeTab.professional.details.bio'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              professional.bio,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            // TODO: Add more sections (services, reviews, availability, etc.)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: Show booking modal
          },
          child: Text(context.tr('homeTab.professional.book')),
        ),
      ),
    );
  }
}