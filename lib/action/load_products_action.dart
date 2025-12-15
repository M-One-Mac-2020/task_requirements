import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:task_requirements/core/service/api_service.dart';
import 'package:task_requirements/state/news/news_state.dart';

class LoadProductsAction extends Action<NewsState> {
  final ApiService _apiService;

  LoadProductsAction(this._apiService);

  @override
  LoadProductsOperation get operationKey => LoadProductsOperation.loadProducts;

  @override
  Future<NewsState> reduce() async {
    final fetchedArticles = await _apiService.fetchProducts();

    return state.rebuild((b) => b.articles.replace(fetchedArticles ?? []));
  }
}
