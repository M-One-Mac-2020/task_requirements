import 'package:task_requirements/core/models/alticle.dart';

abstract class NewsService {
  Future<List<Article>?> fetchProducts();
}
