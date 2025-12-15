import 'package:flutter/material.dart';
import 'package:task_requirements/core/models/alticle.dart';
import 'package:task_requirements/core/service/api/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService;
  List<Article>? _articles;
  bool _isLoading = false;

  NewsProvider(this._newsService);

  List<Article>? get articles => _articles;

  bool get isLoading => _isLoading;

  Future<void> loadArticles() async {
    updateLoading(true);

    try {
      _articles = await _newsService.fetchTopHeadlines();
    } catch (e) {
      // Handle error
      debugPrint(e.toString());
    }

    updateLoading(false);
  }

  void updateLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
