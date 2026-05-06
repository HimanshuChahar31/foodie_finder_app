import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dish_provider.dart';
import '../providers/favorites_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../widgets/dish_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _showOrderSnackBar(BuildContext context, String dishName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ordered $dishName'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dishProvider = context.watch<DishProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favoritesFor(dishProvider.dishes);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved items',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'No saved items yet',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap the heart to save your favorite dishes',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final dish = favorites[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: DishCard(
                      dish: dish,
                      isFavorite: true,
                      onFavoriteToggle: () =>
                          favoritesProvider.toggleFavorite(dish.id),
                      onOrder: () {
                        dishProvider.recordOrder(dish.id);
                        _showOrderSnackBar(context, dish.name);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
