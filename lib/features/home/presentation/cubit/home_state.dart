import '../../domain/entities/product_entity.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<ProductEntity> products;
  final List<ProductEntity> filteredProducts;
  final List<String> categories;
  final int selectedCategoryIndex;
  final String searchQuery;
  final bool hasMore;
  final bool isLoadingMore;

  HomeSuccessState({
    required this.products,
    required this.filteredProducts,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.searchQuery,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  HomeSuccessState copyWith({
    List<ProductEntity>? products,
    List<ProductEntity>? filteredProducts,
    List<String>? categories,
    int? selectedCategoryIndex,
    String? searchQuery,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HomeSuccessState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}
