import 'package:flutter/material.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();

  ProductService._internal();

  factory ProductService() => _instance;

  static ProductService get instance => _instance;
  int? selectedProductId;

  updateSelectedProductId(int? id) {
    selectedProductId = id;
  }
}
