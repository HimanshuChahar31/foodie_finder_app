import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../widgets/profile_option_tile.dart';
import 'login_screen.dart';
import 'location_setup_screen.dart';
import 'support_chat_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final contact = auth.email ?? auth.phone ?? 'No contact added';
    final userName = auth.name ?? 'Foodie Guest';
    final address = auth.address ?? 'Address not added';
    final location = auth.location ?? 'Location not added';

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cream, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        userName.trim().isEmpty
                            ? 'F'
                            : userName.trim()[0].toUpperCase(),
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Profile',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.creamDark,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            contact,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.cream,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            address,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.creamDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            location,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.creamDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            _SectionTitle('Account'),
            _OptionCard(
              children: [
                ProfileOptionTile(
                  icon: Icons.shopping_cart_rounded,
                  title: 'Cart',
                  onTap: () => _navigate(context, const CartScreen()),
                ),
                const Divider(height: 1),
                ProfileOptionTile(
                  icon: Icons.history_rounded,
                  title: 'Order History',
                  onTap: () => _navigate(context, const OrderHistoryScreen()),
                ),
                const Divider(height: 1),
                ProfileOptionTile(
                  icon: Icons.event_seat_rounded,
                  title: 'Booking History',
                  onTap: () => _navigate(context, const BookingHistoryScreen()),
                ),
                const Divider(height: 1),
                ProfileOptionTile(
                  icon: Icons.edit_rounded,
                  title: 'Edit Profile',
                  onTap: () => _navigate(context, const EditProfileScreen()),
                ),
              ],
            ),
              const SizedBox(height: AppSpacing.xl),
            _SectionTitle('Support'),
            _OptionCard(
              children: [
                ProfileOptionTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => _navigate(context, const HelpSupportScreen()),
                ),
                const Divider(height: 1),
                ProfileOptionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                  onTap: () => _navigate(context, const AboutUsScreen()),
                ),
                const Divider(height: 1),
                ProfileOptionTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  onTap: () {
                    context.read<AuthProvider>().logout();
                    context.read<CartProvider>().clearAll();
                    context.read<BookingProvider>().clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking History',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: bookings.isEmpty
            ? const _EmptyState(
                icon: Icons.event_busy_outlined,
                title: 'No bookings yet',
                subtitle: 'Your confirmed table bookings will appear here.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booking.hotelName, style: AppTextStyles.h4),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            booking.cuisine,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Booked by: ${booking.userName}',
                            style: AppTextStyles.bodyMedium,
                          ),
                          Text(
                            'Contact: ${booking.contact}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Slot: ${booking.scheduledAt.day}/${booking.scheduledAt.month}/${booking.scheduledAt.year} ${TimeOfDay.fromDateTime(booking.scheduledAt).format(context)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${booking.seatCount} seats',
                                style: AppTextStyles.bodyMedium,
                              ),
                              Text(
                                'Rs. ${booking.amount.toStringAsFixed(0)}',
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      backgroundColor: AppColors.background,
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.creamDark)),
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final locationSaved = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) =>
                            const LocationSetupScreen(forOrderPlacement: true),
                      ),
                    );
                    if (locationSaved != true || !context.mounted) return;
                    cart.placeOrder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Location saved and order placed successfully',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Order Now'),
                ),
              ),
            ),
      body: SafeArea(
        child: cart.items.isEmpty
            ? const _EmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'Your cart is empty',
                subtitle: 'Tap Add on any dish to see it here.',
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  ...cart.items.map((item) => _CartItemTile(item: item)),
                  const SizedBox(height: AppSpacing.md),
                  _PriceRow('Items total', cart.itemsTotal),
                  _PriceRow(
                    'Delivery (Rs. 20 x ${cart.deliveryDistanceKm.toStringAsFixed(1)} km)',
                    cart.deliveryFee,
                  ),
                  _PriceRow('Handling fee', CartProvider.handlingFee),
                  const Divider(height: AppSpacing.xl),
                  _PriceRow('Total', cart.total, important: true),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.dish.name, style: AppTextStyles.h4),
                  Text(
                    'Rs. ${item.dish.price.toStringAsFixed(0)} each',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: () => cart.decreaseDish(item.dish.id),
              icon: const Icon(Icons.remove_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text('${item.quantity}', style: AppTextStyles.h4),
            ),
            IconButton.filled(
              onPressed: () => cart.addDish(item.dish),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<CartProvider>().orders;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order History',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: orders.isEmpty
            ? const _EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No orders yet',
                subtitle: 'Your placed orders will appear here.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${orders.length - index}',
                            style: AppTextStyles.h4,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...order.items.map(
                            (item) => Text(
                              '${item.quantity} x ${item.dish.name}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          const Divider(),
                          Text(
                            'Total: Rs. ${order.total.toStringAsFixed(0)}',
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _locationController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.name ?? '');
    _addressController = TextEditingController(text: auth.address ?? '');
    _locationController = TextEditingController(text: auth.location ?? '');
    _emailController = TextEditingController(text: auth.email ?? '');
    _phoneController = TextEditingController(text: auth.phone ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _Field(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person_rounded,
              ),
              _Field(
                controller: _addressController,
                label: 'Address',
                icon: Icons.home_rounded,
                maxLines: 2,
              ),
              _Field(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on_rounded,
              ),
              _Field(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_rounded,
                required: false,
              ),
              _Field(
                controller: _phoneController,
                label: 'Phone',
                icon: Icons.phone_rounded,
                required: false,
              ),
              _Field(
                controller: _passwordController,
                label: 'New Password',
                icon: Icons.lock_rounded,
                required: false,
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final auth = context.read<AuthProvider>();
                    auth.updateProfile(
                      name: _nameController.text.trim(),
                      address: _addressController.text.trim(),
                      location: _locationController.text.trim(),
                      email: _emailController.text,
                      phone: _phoneController.text,
                    );
                    final nextPassword = _passwordController.text.trim();
                    if (nextPassword.isNotEmpty) {
                      await auth.updatePassword(nextPassword);
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportChatScreen();
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _InfoScreen(
      title: 'About Us',
      children: const [
        'Foodie Finder helps users discover dishes, manage cart orders, and book restaurant seats from one simple app.',
        'Made by Dinesh and Himanshu Chahar.',
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final bool required;
  final bool obscureText;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.required = true,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: required
            ? (value) =>
                  value?.trim().isEmpty ?? true ? 'Please enter $label' : null
            : null,
      ),
    );
  }
}

class _InfoScreen extends StatelessWidget {
  final String title;
  final List<String> children;

  const _InfoScreen({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: children
            .map(
              (text) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(text, style: AppTextStyles.bodyLarge),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool important;

  const _PriceRow(this.label, this.value, {this.important = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: important ? AppTextStyles.h4 : AppTextStyles.bodyMedium,
          ),
          Text(
            'Rs. ${value.toStringAsFixed(0)}',
            style: important
                ? AppTextStyles.h4.copyWith(color: AppColors.primaryDark)
                : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final List<Widget> children;

  const _OptionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(children: children));
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
