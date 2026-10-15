import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/core/dummy_data.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_state.dart';

class FakeHomeRepository implements HomeRepository {
  final List<ProductEntity> mockProducts;

  FakeHomeRepository(this.mockProducts);

  @override
  Future<List<ProductEntity>> getProducts({int offset = 0, int limit = 10}) async {
    if (offset >= mockProducts.length) return [];
    final end = (offset + limit < mockProducts.length) ? offset + limit : mockProducts.length;
    return mockProducts.sublist(offset, end);
  }

  @override
  List<String> getCategories() {
    return ['All', 'Shoes', 'Clothing', 'Electronics'];
  }
}

void main() {
  group('HomeCubit', () {
    late FakeHomeRepository fakeRepo;
    late List<ProductEntity> testProducts;

    setUp(() {
      testProducts = List.generate(
        15,
        (i) => Product(
          id: 'prod-$i',
          name: i.isEven ? 'Shoe Item $i' : 'Shirt Item $i',
          description: 'Description $i',
          price: 50.0 + i,
          imageUrl: 'https://example.com/img-$i.jpg',
          colors: [Colors.black],
          sizes: ['M'],
          category: i.isEven ? 'Shoes' : 'Clothing',
        ),
      );
      fakeRepo = FakeHomeRepository(testProducts);
    });

    HomeCubit buildCubit() {
      return HomeCubit(
        repository: fakeRepo,
        getProductsUseCase: GetProductsUseCase(fakeRepo),
        getCategoriesUseCase: GetCategoriesUseCase(fakeRepo),
      );
    }

    test('initial state is HomeInitialState', () {
      final cubit = buildCubit();
      expect(cubit.state, isA<HomeInitialState>());
      expect(cubit.categories, contains('All'));
    });

    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoadingState, HomeSuccessState] on getProducts()',
      build: buildCubit,
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeSuccessState>()
            .having((s) => s.products.length, 'products.length', 10)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'loads more products on loadMoreProducts() and appends to list',
      build: buildCubit,
      act: (cubit) async {
        await cubit.getProducts();
        await cubit.loadMoreProducts();
      },
      skip: 2, // skip initial loading and first success
      expect: () => [
        isA<HomeSuccessState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<HomeSuccessState>()
            .having((s) => s.products.length, 'products.length', 15)
            .having((s) => s.hasMore, 'hasMore', false)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'filters products by category correctly',
      build: buildCubit,
      act: (cubit) async {
        await cubit.getProducts();
        cubit.selectCategory(1); // Select 'Shoes'
      },
      skip: 2,
      expect: () => [
        isA<HomeSuccessState>()
            .having((s) => s.selectedCategoryIndex, 'category', 1)
            .having(
              (s) => s.filteredProducts.every((p) => p.category == 'Shoes'),
              'only shoes',
              true,
            ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'filters products by search query correctly',
      build: buildCubit,
      act: (cubit) async {
        await cubit.getProducts();
        cubit.searchProducts('Shoe Item 0');
      },
      skip: 2,
      expect: () => [
        isA<HomeSuccessState>()
            .having((s) => s.searchQuery, 'query', 'Shoe Item 0')
            .having((s) => s.filteredProducts.length, 'filtered.length', 1)
            .having((s) => s.filteredProducts.first.name, 'matched name', 'Shoe Item 0'),
      ],
    );
  });
}
