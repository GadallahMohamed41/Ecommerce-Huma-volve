import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<List<ProductEntity>> getProducts();
  List<String> getCategories();
}
