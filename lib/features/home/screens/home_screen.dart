import 'package:flutter/material.dart';

import '../../../core/dummy_data.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/product_api_service.dart';
import '../../../core/theme.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = dummyProducts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final fetched = await ProductApiService().fetchProducts();
    if (mounted) {
      setState(() {
        _products = fetched;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      if (_selectedCategoryIndex == 0) return true; // All

      final selectedCategory = dummyCategories[_selectedCategoryIndex].toLowerCase();
      if (product.category.toLowerCase() == selectedCategory) return true;

      final pName = product.name.toLowerCase();
      if (selectedCategory == 'shoes' &&
          (pName.contains('shoe') || pName.contains('sneaker') || pName.contains('cleats') || pName.contains('heel'))) {
        return true;
      } else if (selectedCategory == 'clothing' &&
          (pName.contains('jacket') || pName.contains('hoodie') || pName.contains('shirt') || pName.contains('pant'))) {
        return true;
      } else if (selectedCategory == 'accessories' &&
          (pName.contains('bag') || pName.contains('sunglass') || pName.contains('backpack') || pName.contains('wallet'))) {
        return true;
      } else if (selectedCategory == 'electronics' &&
          (pName.contains('headphone') || pName.contains('watch') || pName.contains('lamp') || pName.contains('keyboard'))) {
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final int crossAxisCount = screenWidth >= 1000
        ? 4
        : screenWidth >= 600
            ? 3
            : 2;

    final double childAspectRatio = screenWidth < 360
        ? 0.61
        : screenWidth < 500
            ? 0.64
            : screenWidth < 800
                ? 0.68
                : 0.72;

    final double horizontalPadding = screenWidth >= 600 ? 32.0 : 20.0;
    final filtered = _filteredProducts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: _loadProducts,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.menu_rounded,
                                color: AppTheme.primary,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final firebaseUser = FirebaseAuthService().currentUser;
                            final userAvatar = firebaseUser?.photoURL ?? dummyUser.profilePictureUrl;
                            return Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primary.withValues(alpha: 0.1),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  userAvatar,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 44,
                                    height: 44,
                                    color: AppTheme.primary,
                                    child: const Icon(Icons.person, size: 22, color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 15 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Best trendy collection!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.04),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF9E9E9E),
                            size: 22,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 20),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.tune_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 46,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: dummyCategories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return CategoryChip(
                            label: dummyCategories[index],
                            isSelected: _selectedCategoryIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ),

            if (filtered.isEmpty && !_isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for another keyword or select another category.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProductCard(
                        product: filtered[index],
                        index: index,
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    ),
  );
  }
}
