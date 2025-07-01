import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../core/icons/main.dart';
import '../model.dart';
import 'neutral_state_provider.dart';

class ProfessionalBookingWidget extends StatefulWidget {
  final ProfessionalModel professional;

  const ProfessionalBookingWidget({
    super.key,
    required this.professional,
  });

  @override
  State<ProfessionalBookingWidget> createState() => _ProfessionalBookingWidgetState();
}

class _ProfessionalBookingWidgetState extends State<ProfessionalBookingWidget> {
  DateTime _selectedDate = DateTime.now();
  ProfessionalService? _selectedService;
  TimeSlot? _selectedTimeSlot;
  final TextEditingController _notesController = TextEditingController();
  
  List<TimeSlot> _availableSlots = [];
  bool _loadingSlots = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableSlots();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableSlots() async {
    setState(() {
      _loadingSlots = true;
    });

    final provider = context.read<NeutralStateProvider>();
    final slots = await provider.getAvailableSlots(
      professionalId: widget.professional.id,
      date: _selectedDate,
    );

    setState(() {
      _availableSlots = slots;
      _loadingSlots = false;
      _selectedTimeSlot = null; // Reset selection when date changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: widget.professional.avatarUrl != null
                          ? NetworkImage(widget.professional.avatarUrl!)
                          : null,
                      child: widget.professional.avatarUrl == null
                          ? PuboxIcons.coach
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('homeTab.professional.booking.title'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            widget.professional.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              const Divider(),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Selection
                      _buildServiceSelection(),
                      
                      const SizedBox(height: 24),
                      
                      // Date Selection
                      _buildDateSelection(),
                      
                      const SizedBox(height: 24),
                      
                      // Time Slot Selection
                      _buildTimeSlotSelection(),
                      
                      const SizedBox(height: 24),
                      
                      // Notes
                      _buildNotesSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Booking Summary
                      if (_selectedService != null && _selectedTimeSlot != null)
                        _buildBookingSummary(),
                    ],
                  ),
                ),
              ),
              
              // Book Button
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedService != null && _selectedTimeSlot != null
                        ? _bookSlot 
                        : null,
                    child: Text(context.tr('homeTab.neutral.booking.confirm')),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('homeTab.professional.booking.selectService'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...widget.professional.services.map((service) {
          final isSelected = _selectedService?.id == service.id;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(service.name),
              subtitle: Text(service.description),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${service.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${service.durationMinutes}min',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              selected: isSelected,
              onTap: () {
                setState(() {
                  _selectedService = service;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('homeTab.neutral.booking.selectDate'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showDatePicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('homeTab.neutral.booking.selectTime'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (_loadingSlots)
          const Center(child: CircularProgressIndicator.adaptive())
        else if (_availableSlots.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.tr('homeTab.neutral.booking.noSlots'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSlots.map((slot) {
              final isSelected = _selectedTimeSlot == slot;
              return FilterChip(
                label: Text(
                  '${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}',
                ),
                selected: isSelected,
                onSelected: slot.isAvailable
                    ? (selected) {
                        setState(() {
                          _selectedTimeSlot = selected ? slot : null;
                        });
                      }
                    : null,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('homeTab.neutral.booking.notes'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: context.tr('homeTab.neutral.booking.notesHint'),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSummary() {
    final totalPrice = _selectedService!.price + (_selectedTimeSlot!.price ?? 0);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('homeTab.neutral.booking.summary'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tr('homeTab.neutral.booking.service')),
                Text(_selectedService!.name),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tr('homeTab.neutral.booking.date')),
                Text(DateFormat('MMM d, y').format(_selectedDate)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tr('homeTab.neutral.booking.time')),
                Text(
                  '${DateFormat('HH:mm').format(_selectedTimeSlot!.startTime)} - ${DateFormat('HH:mm').format(_selectedTimeSlot!.endTime)}',
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('homeTab.neutral.booking.total'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await _loadAvailableSlots();
    }
  }

  Future<void> _bookSlot() async {
    if (_selectedService == null || _selectedTimeSlot == null) return;

    final provider = context.read<NeutralStateProvider>();
    
    final success = await provider.bookSlot(
      professionalId: widget.professional.id,
      serviceId: _selectedService!.id,
      startTime: _selectedTimeSlot!.startTime,
      endTime: _selectedTimeSlot!.endTime,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('homeTab.neutral.booking.success')),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('homeTab.neutral.booking.error')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}