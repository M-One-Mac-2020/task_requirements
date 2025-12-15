import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:task_requirements/core/service/api_service.dart';
import 'package:task_requirements/state/news/product_state.dart';

class LoadProductsAction extends Action<ProductState> {
  final ApiService _apiService;

  LoadProductsAction(this._apiService);

  @override
  ProductOperation get operationKey => ProductOperation.loadProducts;

  @override
  Future<ProductState> reduce() async {
    final fetchedArticles = await _apiService.fetchProducts();

    return state.rebuild((b) => b.articles.replace(fetchedArticles ?? []));
  }
}

class CreateProductAction extends Action<ProductState> {
  final ApiService _apiService;
  final String title;
  final int price;
  final String description;
  final int categoryId;
  final List<String> images;

  CreateProductAction(
    this._apiService, {
    required this.title,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.images,
  });

  @override
  ProductOperation get operationKey => ProductOperation.createProduct;

  @override
  Future<ProductState> reduce() async {
    final newProduct = await _apiService.createProduct(
      title: title,
      price: price,
      description: description,
      categoryId: categoryId,
      images: images,
    );

    if (newProduct != null) {
      return state.rebuild((b) => b.articles.insert(0, newProduct));
    }
    return state;
  }
}
