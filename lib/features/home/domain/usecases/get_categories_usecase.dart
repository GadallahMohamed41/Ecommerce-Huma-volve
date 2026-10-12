import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository repository;

  const GetCategoriesUseCase(this.repository);

  List<String> call() {
    return repository.getCategories();
  }
}
