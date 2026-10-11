import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/dummy_data.dart';
import '../../../core/services/product_api_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductApiService _productApiService;

  HomeCubit({ProductApiService? productApiService})
      : _productApiService = productApiService ?? ProductApiService(),
        super(HomeInitialState());

  static HomeCubit get(BuildContext context) => BlocProvider.of<HomeCubit>(context);

  List<Product> _allProducts = [];
  final List<String> _categories = dummyCategories;
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';

  int get selectedCategoryIndex => _selectedCategoryIndex;
  List<String> get categories => _categories;

  Future<void> getProducts() async {
    emit(HomeLoadingState());
    try {
      final products = await _productApiService.fetchProducts();
      _allProducts = products;
      _applyFilter();
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    _applyFilter();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    final query = _searchQuery.trim().toLowerCase();
    final selectedCategory = _categories[_selectedCategoryIndex].toLowerCase();

    final filtered = _allProducts.where((product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      if (_selectedCategoryIndex == 0) return true;

      if (product.category.toLowerCase() == selectedCategory) return true;

      final pName = product.name.toLowerCase();
      if (selectedCategory == 'shoes' &&
          (pName.contains('shoe') ||
              pName.contains('sneaker') ||
              pName.contains('cleats') ||
              pName.contains('heel'))) {
        return true;
      } else if (selectedCategory == 'clothing' &&
          (pName.contains('jacket') ||
              pName.contains('hoodie') ||
              pName.contains('shirt') ||
              pName.contains('pant'))) {
        return true;
      } else if (selectedCategory == 'accessories' &&
          (pName.contains('bag') ||
              pName.contains('sunglass') ||
              pName.contains('backpack') ||
              pName.contains('wallet'))) {
        return true;
      } else if (selectedCategory == 'electronics' &&
          (pName.contains('headphone') ||
              pName.contains('watch') ||
              pName.contains('lamp') ||
              pName.contains('keyboard'))) {
        return true;
      }
      return false;
    }).toList();

    emit(
      HomeSuccessState(
        products: _allProducts,
        filteredProducts: filtered,
        categories: _categories,
        selectedCategoryIndex: _selectedCategoryIndex,
        searchQuery: _searchQuery,
      ),
    );
  }
}
