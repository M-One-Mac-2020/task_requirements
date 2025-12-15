import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:task_requirements/action/load_articles_action.dart';
import 'package:task_requirements/core/service/api/api_service.dart';
import 'package:task_requirements/core/service/firebase_service.dart';
import 'package:task_requirements/core/service/notification/notification_service.dart';
import 'package:task_requirements/state/news_state.dart';
import 'package:task_requirements/widgets/news_card.dart';
import 'package:async_redux/async_redux.dart';
import '../core/models/alticle.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Store<AppState> store;
  final apiService = ApiService();

  @override
  void initState() {
    store = Store<AppState>(initialState: AppState.initial());
    store.dispatch(LoadArticlesAction(apiService));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // newsProvider.loadArticles();
      await FirebaseService.initializeFirebase();
      await NotificationService.initialize();
    });

    super.initState();
  }

  @override
  void dispose() {
    // newsProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top News'),
          actions: [
            ElevatedButton(
              onPressed: () {
                NotificationService.fcmService.sendCustomNotification();
              },
              child: Text("Send Notification"),
            ),
          ],
        ),
        body: StoreConnector<AppState, _NewsScreenViewModel>(
          converter: (store) => _NewsScreenViewModel.fromStore(store),
          builder: (context, vm) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final articles = vm.articles;
            if (articles.isEmpty) {
              return const Center(child: Text("No articles found."));
            }
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return NewsCard(article: articles[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _NewsScreenViewModel {
  final List<Article> articles;
  final bool isLoading;

  _NewsScreenViewModel({required this.articles, required this.isLoading});

  factory _NewsScreenViewModel.fromStore(Store<AppState> store) {
    final loadingState = store.state.getOperationState(Operation.loadArticles);

    return _NewsScreenViewModel(
      articles: store.state.articles.toList(), // Convert BuiltList back to List
      isLoading: loadingState.isInProgress,
    );
  }
}
