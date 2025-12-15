import 'package:task_requirements/core/service/api_service.dart';
import 'package:task_requirements/state/news/product_state.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class DeleteProductAction extends Action<ProductState> {
  final ApiService _apiService;
  final int productId;

  DeleteProductAction(this._apiService, {required this.productId});

  @override
  ProductOperation get operationKey => ProductOperation.deleteProduct;

  @override
  Future<ProductState> reduce() async {
    final deletedProduct = await _apiService.deleteProduct(productId);

    if (deletedProduct) {
      return state.rebuild((b) => b.articles.removeWhere((p) => p.id == productId));
    }

    return state;
  }
}
