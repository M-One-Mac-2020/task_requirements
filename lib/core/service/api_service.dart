import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_requirements/core/models/product.dart';

class ApiService {
  String baseUrl = "https://api.escuelajs.co/api/v1/products";

  Future<List<Product>?> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((articleJson) => Product.fromJson(articleJson)).toList();
    } else {
      return null;
    }
  }

  Future<Product?> fetchProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      return null;
    }
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return response.body == "true" ? true : false;
    } else {
      return false;
    }
  }

  Future<Product?> createProduct({
    required String title,
    required int price,
    required String description,
    required int categoryId,
    required List<String> images,
  }) async {
    final body = json.encode({
      "title": title,
      "price": price,
      "description": description,
      "categoryId": categoryId,
      "images": images,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      // 201 Created is the expected response
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      debugPrint(
        'Failed to create product. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return null;
    }
  }
}
