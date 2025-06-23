# Professional Tab Implementation Outline

## Overview

The Professional tab is a new section in the Home tab that allows users to discover, view details, and book sessions with sports professionals (coaches and referees).

## Architecture

### File Structure
```
lib/home_tab/
├── professional_section/
│   ├── professional_section.dart           # Main UI widget ✅
│   ├── professional_state_provider.dart    # State management ✅
│   ├── professional_result_item.dart       # Professional card component ✅
│   └── professional_booking_widget.dart    # Booking modal ✅
└── model.dart                              # Added ProfessionalModel ✅
```

### Database Schema Integration
- **Tables Used**: `professional`, `professional_service`, `professional_booking`, `professional_booking_review`
- **Functions Created**: `get_professionals()`, `get_professional_availability()`, `create_professional_booking()`
- **Supports**: Coach/Referee roles, service offerings, availability management

## Core Features Implemented

### 1. Professional Listings ✅
- **Infinite scroll pagination** with 10 items per page
- **Role filtering** (Coach/Referee/All)
- **Sport-based filtering** (inherited from SelectedSportProvider)
- **Location filtering** (inherited from HomeStateProvider)
- **Rating-based sorting** with fallback to review count

### 2. Professional Cards ✅
- **Avatar display** with fallback icon
- **Role badges** with color coding (Green=Coach, Orange=Referee)
- **Verification status** with blue checkmark
- **Star ratings** with color coding based on score
- **Service preview** (first 3 services as chips)
- **Experience and review counts**
- **Quick book button**

### 3. Professional Details Page ✅
- **Full profile view** (scaffold implemented)
- **Bio section**
- **Service listings**
- **Review system** (placeholder)
- **Share functionality** (placeholder)

### 4. Booking System ✅
- **Service selection** with pricing and duration
- **Date picker** (30-day availability window)
- **Time slot selection** with availability checking
- **Notes field** for special requests
- **Booking summary** with total price calculation
- **Real-time slot availability** via database functions

## State Management Pattern

### ProfessionalStateProvider ✅
- **Extends ChangeNotifier** following app patterns
- **Depends on HomeStateProvider and SelectedSportProvider**
- **Manages pagination** with `PagingController`
- **Handles filtering state** (role, location, timeslots)
- **Provides booking functionality**
- **Error handling** with fallback states

### Provider Integration
```dart
// Add to main.dart:
ChangeNotifierProxyProvider2<HomeStateProvider, SelectedSportProvider, ProfessionalStateProvider>(
  create: (context) => ProfessionalStateProvider(
    context.read<HomeStateProvider>(),
    context.read<SelectedSportProvider>(),
  ),
  update: (_, homeState, sportState, previous) =>
      previous ?? ProfessionalStateProvider(homeState, sportState),
)
```

## UI Components

### ProfessionalSection ✅
- **RefreshIndicator** for pull-to-refresh
- **CustomScrollView** with SliverAppBar
- **Filter button** in app bar for role selection
- **PagedSliverList** for infinite scroll
- **Loading, error, and empty states**

### ProfessionalResultItem ✅
- **Card-based design** consistent with app styling
- **Responsive layout** with proper spacing
- **Interactive elements** (tap for details, book button)
- **Visual hierarchy** with proper typography

### ProfessionalBookingWidget ✅
- **Modal bottom sheet** with drag handle
- **Multi-step form** (service → date → time → notes)
- **Real-time validation** and availability checking
- **Booking summary** with price breakdown
- **Loading states** during booking process

## Database Functions

### get_professionals() ✅
- **Parameters**: sport_id, location_id, role_filter, timeslots, pagination
- **Returns**: Professional data with aggregated services
- **Sorting**: Rating DESC, review count DESC, name ASC
- **Performance**: Optimized with proper indexes

### get_professional_availability() ✅
- **Generates**: 9 AM - 9 PM time slots for target date
- **Checks**: Existing bookings for conflicts
- **Returns**: Available slots with pricing
- **Flexible**: Can be extended for custom schedules

### create_professional_booking() ✅
- **Validates**: Time slot availability
- **Calculates**: Total price (service + hourly rate)
- **Creates**: Booking record with 'pending' status
- **Returns**: Booking ID and confirmation details

## Integration Points

### Home Tab Integration
```dart
// Update HomeTab view.dart:
static final List<Widget> homeSections = [
  TeammateSection(),      // Index 0
  ChallengerSection(),    // Index 1
  NeutralSection(),       // Index 2
  LocationSection(),      // Index 3
  ProfessionalSection(),  // Index 4 - NEW
];

// Update TabController length to 5
// Add professional icon to tab bar
```

### Router Integration
```dart
// Add to router.dart:
GoRoute(
  path: 'professional',
  builder: (context, state) => HomeTab.withInitialTab(4)
)
```

## Missing Implementations (Future Work)

### 1. Advanced Features
- [ ] **Real-time availability** sync
- [ ] **Push notifications** for booking confirmations
- [ ] **Payment integration** for booking fees
- [ ] **Review and rating system** for completed sessions
- [ ] **Professional calendar management**

### 2. Enhanced UI
- [ ] **Map view** for location-based discovery
- [ ] **Advanced filters** (price range, availability, specialties)
- [ ] **Favorites system** for preferred professionals
- [ ] **Chat system** for pre-booking communication

### 3. Business Logic
- [ ] **Automated booking confirmations**
- [ ] **Cancellation policies** and refund handling
- [ ] **Professional onboarding** flow
- [ ] **Earnings dashboard** for professionals
- [ ] **Analytics and reporting**

## Testing Strategy

### Unit Tests Needed
- [ ] `ProfessionalStateProvider` business logic
- [ ] Model serialization/deserialization
- [ ] Database function behavior
- [ ] Booking validation logic

### Widget Tests Needed
- [ ] `ProfessionalSection` rendering
- [ ] `ProfessionalResultItem` interactions
- [ ] `ProfessionalBookingWidget` form validation
- [ ] Error and loading states

### Integration Tests Needed
- [ ] End-to-end booking flow
- [ ] Professional discovery and filtering
- [ ] Cross-provider state management
- [ ] Database integration

## Performance Considerations

### Optimizations Implemented ✅
- **Pagination** to limit data fetching
- **Image lazy loading** for avatars
- **Database indexes** for fast queries
- **Efficient state management** with targeted rebuilds

### Future Optimizations
- [ ] **Image caching** for professional avatars
- [ ] **Background sync** for availability updates
- [ ] **Query result caching** with TTL
- [ ] **Virtual scrolling** for large lists

## Deployment Checklist

### Database Setup
- [ ] Run `professional_functions.sql` migrations
- [ ] Verify table relationships and constraints
- [ ] Test function performance with sample data
- [ ] Set up proper RLS policies

### App Integration
- [ ] Add ProfessionalStateProvider to main.dart
- [ ] Update HomeTab with 5th tab
- [ ] Add professional route to router
- [ ] Run `flutter packages pub run build_runner build` for model generation

### Localization
- [ ] Add professional-related translation keys
- [ ] Test UI in both Vietnamese and English
- [ ] Verify text overflow handling

This outline provides a comprehensive roadmap for implementing the professional services feature within your existing architecture patterns.