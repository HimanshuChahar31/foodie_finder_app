import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../widgets/app_image.dart';
import 'location_setup_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static final List<Restaurant> _hotels = [
    Restaurant(
      id: 'h1',
      name: 'Kake Di Hatti',
      rating: 4.8,
      distance: 1.2,
      pricePerSeat: 899,
      imageUrl: 'assets/images/real/restaurants/kake-di-hatti.jpg',
      cuisine: 'North Indian - Family Dining',
      description:
          'Rich tandoori platters, warm lighting, and roomy seating for classic family dinners.',
    ),
    Restaurant(
      id: 'h2',
      name: 'Taj Courtyard',
      rating: 4.6,
      distance: 2.4,
      pricePerSeat: 699,
      imageUrl: 'assets/images/real/restaurants/taj-courtyard.jpg',
      cuisine: 'Signature Dining - Fine Casual',
      description:
          'Elegant interiors, attentive service, and polished tables for a refined meal out.',
    ),
    Restaurant(
      id: 'h3',
      name: 'Punjab Grill House',
      rating: 4.7,
      distance: 3.1,
      pricePerSeat: 799,
      imageUrl: 'assets/images/real/restaurants/punjab-grill-house.jpg',
      cuisine: 'Punjabi Grill - Premium',
      description:
          'Smoky grills, paneer platters, and a premium dining room for long evening meals.',
    ),
    Restaurant(
      id: 'h4',
      name: 'Royal Dawat',
      rating: 4.5,
      distance: 4.0,
      pricePerSeat: 1199,
      imageUrl: 'assets/images/real/restaurants/royal-dawat.jpg',
      cuisine: 'Celebration Dining - Mughlai',
      description:
          'A grand dining setup with festive ambience, kebabs, and rich North Indian mains.',
    ),
  ];

  Restaurant _selectedHotel = _hotels.first;
  int _seatCount = 2;
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 2));

  double get _totalCost => _selectedHotel.pricePerSeat * _seatCount;

  void _updateSeats(int delta) {
    setState(() {
      _seatCount = (_seatCount + delta).clamp(1, 12);
    });
  }

  Future<void> _confirmBooking() async {
    final locationSaved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const LocationSetupScreen(forOrderPlacement: true),
      ),
    );
    if (locationSaved != true || !mounted) return;

    final auth = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();
    final userName = (auth.name?.trim().isNotEmpty ?? false)
        ? auth.name!.trim()
        : 'Foodie User';
    final contact = auth.email?.trim().isNotEmpty ?? false
        ? auth.email!.trim()
        : (auth.phone?.trim().isNotEmpty ?? false
              ? auth.phone!.trim()
              : 'No contact');

    bookingProvider.addBooking(
      BookingRecord(
        userName: userName,
        contact: contact,
        hotelName: _selectedHotel.name,
        cuisine: _selectedHotel.cuisine,
        seatCount: _seatCount,
        amount: _totalCost,
        bookedAt: DateTime.now(),
        scheduledAt: _selectedDateTime,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Location saved and booked $_seatCount seats on ${_selectedDateTime.day}/${_selectedDateTime.month} at ${TimeOfDay.fromDateTime(_selectedDateTime).format(context)} for Rs. ${_totalCost.toStringAsFixed(0)}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime.isAfter(now) ? _selectedDateTime : now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (pickedTime == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Book Seats',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.creamDark)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _CompactSeatButton(
                    icon: Icons.remove_rounded,
                    onPressed: _seatCount > 1 ? () => _updateSeats(-1) : null,
                  ),
                  Container(
                    width: 68,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_seatCount',
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          'seats',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CompactSeatButton(
                    icon: Icons.add_rounded,
                    onPressed: _seatCount < 12 ? () => _updateSeats(1) : null,
                  ),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total amount',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Rs. ${_totalCost.toStringAsFixed(0)}',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _confirmBooking,
                  icon: const Icon(Icons.event_available_rounded),
                  label: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Reserve your table',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Choose a hotel and seats',
                    style: AppTextStyles.h2.copyWith(color: AppColors.cream),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Pick a dining spot, adjust seat count, and see the total instantly.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.creamDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule_rounded),
                title: const Text('Booking Date & Time'),
                subtitle: Text(
                  '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} • ${TimeOfDay.fromDateTime(_selectedDateTime).format(context)}',
                ),
                trailing: TextButton(
                  onPressed: _pickDateTime,
                  child: const Text('Change'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Available Hotels',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._hotels.map(
              (hotel) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _HotelBookingCard(
                  hotel: hotel,
                  selected: hotel.id == _selectedHotel.id,
                  onTap: () => setState(() => _selectedHotel = hotel),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _HotelBookingCard extends StatelessWidget {
  final Restaurant hotel;
  final bool selected;
  final VoidCallback onTap;

  const _HotelBookingCard({
    required this.hotel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.creamDark,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Stack(
                children: [
                  AppImage(
                    source: hotel.imageUrl,
                    height: 138,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 138,
                      color: AppColors.cream,
                      child: const Icon(Icons.restaurant_rounded),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.ink.withAlpha(220),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            hotel.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.cream,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hotel.name,
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    hotel.cuisine,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    hotel.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _InfoPill(
                        icon: Icons.location_on_rounded,
                        label: '${hotel.distance.toStringAsFixed(1)} km away',
                      ),
                      _InfoPill(
                        icon: Icons.event_seat_rounded,
                        label:
                            'Rs. ${hotel.pricePerSeat.toStringAsFixed(0)} / seat',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primaryDark),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactSeatButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CompactSeatButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.ink,
        disabledBackgroundColor: AppColors.creamDark,
        foregroundColor: AppColors.cream,
        disabledForegroundColor: AppColors.textSecondary,
        minimumSize: const Size(48, 48),
      ),
    );
  }
}
