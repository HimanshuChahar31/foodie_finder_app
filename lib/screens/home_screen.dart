import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dish.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/dish_provider.dart';
import '../providers/favorites_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../utils/route_transitions.dart';
import '../widgets/dish_card.dart';
import 'booking_screen.dart';
import 'favorites_screen.dart';
import 'insights_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateTo(Widget page) {
    Navigator.of(context).push(fadeRoute(page: page));
  }

  void _addToCart(Dish dish) {
    final cartProvider = context.read<CartProvider>();
    cartProvider.addDish(dish);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Consumer<CartProvider>(
          builder: (context, cart, _) {
            final quantity = cart.quantityFor(dish.id);
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dish.name, style: AppTextStyles.h4),
                        Text(
                          'Added to cart - Rs. ${dish.price.toStringAsFixed(0)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    onPressed: quantity > 0
                        ? () => cart.decreaseDish(dish.id)
                        : null,
                    icon: const Icon(Icons.remove_rounded),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text('$quantity', style: AppTextStyles.h4),
                  ),
                  IconButton.filled(
                    onPressed: () => cart.addDish(dish),
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dishProvider = context.watch<DishProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final filteredDishes = dishProvider.filteredDishes(
      authProvider.preferenceCategory,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => _navigateTo(const CartScreen()),
            backgroundColor: AppColors.ink,
            foregroundColor: AppColors.cream,
            icon: const Icon(Icons.shopping_cart_rounded),
            label: Text(
              '${cart.itemCount} items - Rs. ${cart.total.toStringAsFixed(0)}',
            ),
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: AppColors.ink,
            elevation: 0,
            expandedHeight: 190,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.ink,
                      AppColors.primaryDark,
                      AppColors.primary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -28,
                      top: 18,
                      child: Icon(
                        Icons.ramen_dining_rounded,
                        size: 132,
                        color: Colors.white.withAlpha(22),
                      ),
                    ),
                    Positioned(
                      left: -22,
                      bottom: -18,
                      child: Icon(
                        Icons.local_pizza_rounded,
                        size: 96,
                        color: AppColors.accent.withAlpha(46),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.xl,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              'Today tastes good',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Foodie Finder',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.cream,
                            ),
                          ),
                          Text(
                            'Discover crave-worthy plates near you',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.creamDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(124),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search biryani, burger, salad...',
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                              ),
                              style: AppTextStyles.bodySmall,
                              onChanged: dishProvider.updateSearchQuery,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          if (authProvider.isAdmin)
                            _HeaderIconButton(
                              icon: Icons.insights_rounded,
                              tooltip: 'Analytics',
                              onPressed: () =>
                                  _navigateTo(const InsightsScreen()),
                            ),
                          _HeaderIconButton(
                            icon: Icons.favorite_rounded,
                            tooltip: 'Favorites',
                            onPressed: () =>
                                _navigateTo(const FavoritesScreen()),
                          ),
                          _HeaderIconButton(
                            icon: Icons.person_rounded,
                            tooltip: 'Profile',
                            onPressed: () => _navigateTo(const ProfileScreen()),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...dishProvider.categoryFilters.map((filter) {
                              final selected =
                                  dishProvider.selectedCategory == filter;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.sm,
                                ),
                                child: FilterChip(
                                  label: Text(
                                    filter,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: selected
                                          ? AppColors.onPrimary
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  selected: selected,
                                  onSelected: (_) =>
                                      dishProvider.updateCategoryFilter(filter),
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.surface,
                                  side: BorderSide(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.creamDark,
                                  ),
                                  checkmarkColor: AppColors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              );
                            }),
                            ActionChip(
                              avatar: const Icon(
                                Icons.event_seat_rounded,
                                size: 18,
                                color: AppColors.ink,
                              ),
                              label: Text(
                                'Book Seats',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              backgroundColor: AppColors.accent,
                              side: const BorderSide(color: AppColors.accent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              onPressed: () =>
                                  _navigateTo(const BookingScreen()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All dishes',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${filteredDishes.length} options',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (filteredDishes.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'No dishes found',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }
              final dish = filteredDishes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: DishCard(
                  dish: dish,
                  isFavorite: favoritesProvider.isFavorite(dish.id),
                  onFavoriteToggle: () =>
                      favoritesProvider.toggleFavorite(dish.id),
                  onOrder: () {
                    _addToCart(dish);
                  },
                ),
              );
            }, childCount: filteredDishes.isEmpty ? 1 : filteredDishes.length),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Tooltip(
            message: tooltip,
            child: SizedBox(
              height: 44,
              width: 44,
              child: Icon(icon, color: AppColors.primaryDark, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
