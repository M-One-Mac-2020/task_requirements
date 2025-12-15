import 'package:flutter/material.dart' hide Action;
import 'package:task_requirements/core/service/product_service.dart';
import 'package:task_requirements/path_file.dart';
import 'package:task_requirements/state/product_details/product_details_state.dart';

import '../core/service/api_service.dart';

class ProductDetailsAction extends Action<ProductDetailsState> {
  final ApiService _apiService;

  ProductDetailsAction(this._apiService);

  @override
  Future<ProductDetailsState> reduce() async {
    debugPrint("=======");
    int? id = ProductService.instance.selectedProductId;

    if (id == null) {
      return state;
    }
    final res = await _apiService.fetchProduct(id!);

    return state.rebuild((data) {
      return data.product = res;
    });
  }
}
