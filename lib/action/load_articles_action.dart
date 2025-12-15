
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:task_requirements/core/service/api/api_service.dart';
import 'package:task_requirements/state/news_state.dart';

class LoadArticlesAction extends Action<AppState> {
  final ApiService _apiService;

  LoadArticlesAction(this._apiService);

  @override
  // Associates this action with the 'loadArticles' operation for status tracking
  Operation get operationKey => Operation.loadArticles;

  @override
  Future<AppState> reduce() async {
    final fetchedArticles = await _apiService.fetchTopHeadlines();

    // The reduce function returns the new state
    return state.rebuild((b) => b.articles.replace(fetchedArticles ?? []));
  }
}
