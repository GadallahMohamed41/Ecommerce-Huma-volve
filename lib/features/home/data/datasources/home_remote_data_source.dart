import '../../../../core/dummy_data.dart';
import '../../../../core/services/product_api_service.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<Product>> getProducts();
  List<String> getCategories();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ProductApiService _productApiService;

  HomeRemoteDataSourceImpl({ProductApiService? productApiService})
      : _productApiService = productApiService ?? ProductApiService();

  @override
  Future<List<Product>> getProducts() async {
    final products = await _productApiService.fetchProducts();
    return products
        .map(
          (p) => ProductModel(
            id: p.id,
            name: p.name,
            description: p.description,
            price: p.price,
            imageUrl: p.imageUrl,
            colors: p.colors,
            sizes: p.sizes,
            category: p.category,
          ),
        )
        .toList();
  }

  @override
  List<String> getCategories() {
    return List<String>.from(dummyCategories);
  }
}
