import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository repository;

  const GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call({int offset = 0, int limit = 10}) {
    return repository.getProducts(offset: offset, limit: limit);
  }
}
