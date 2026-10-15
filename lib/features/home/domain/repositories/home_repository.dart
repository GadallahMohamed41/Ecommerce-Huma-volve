import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<List<ProductEntity>> getProducts({int offset = 0, int limit = 10});
  List<String> getCategories();
}
