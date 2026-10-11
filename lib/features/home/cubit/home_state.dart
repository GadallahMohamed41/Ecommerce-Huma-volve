import '../../../core/dummy_data.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<String> categories;
  final int selectedCategoryIndex;
  final String searchQuery;

  HomeSuccessState({
    required this.products,
    required this.filteredProducts,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.searchQuery,
  });

  HomeSuccessState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    List<String>? categories,
    int? selectedCategoryIndex,
    String? searchQuery,
  }) {
    return HomeSuccessState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}
