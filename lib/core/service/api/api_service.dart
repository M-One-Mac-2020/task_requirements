import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_requirements/core/models/alticle.dart';
import 'news_service.dart';

class ApiService implements NewsService {
  final String _baseUrl = 'https://api.escuelajs.co/api/v1/products';

  @override
  Future<List<Article>?> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl?country=us&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List)
          .map((articleJson) => Article.fromJson(articleJson))
          .toList();
    } else {
      return null;
    }
  }
}
