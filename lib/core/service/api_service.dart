import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_requirements/core/models/product.dart';

class ApiService {
  Future<List<Product>?> fetchProducts() async {
    final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((articleJson) => Product.fromJson(articleJson)).toList();
    } else {
      return null;
    }
  }

  Future<Product?> fetchProduct(int id) async {
    final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products/$id'));
    debugPrint("fetchProduct: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      return null;
    }
  }
}
