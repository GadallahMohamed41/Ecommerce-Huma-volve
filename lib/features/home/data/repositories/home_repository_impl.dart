import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({HomeRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? HomeRemoteDataSourceImpl();

  @override
  Future<List<ProductEntity>> getProducts({int offset = 0, int limit = 10}) {
    return remoteDataSource.getProducts(offset: offset, limit: limit);
  }

  @override
  List<String> getCategories() {
    return remoteDataSource.getCategories();
  }
}
