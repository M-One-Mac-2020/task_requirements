import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:task_requirements/action/load_products_action.dart';
import 'package:task_requirements/action/update_navbar_action.dart';
import 'package:task_requirements/core/service/api_service.dart';
import 'package:task_requirements/core/service/firebase_service.dart';
import 'package:task_requirements/core/service/notification/notification_service.dart';
import 'package:task_requirements/core/service/product_service.dart';
import 'package:task_requirements/screens/navbar_screen.dart';
import 'package:task_requirements/state/news/news_state.dart';
import 'package:task_requirements/widgets/news_card.dart';
import 'package:async_redux/async_redux.dart';
import '../core/models/product.dart';

class ProductsScreen extends StatefulWidget {
  final NavbarViewModel navbarViewModel;

  const ProductsScreen({super.key, required this.navbarViewModel});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Store<NewsState> store;
  final apiService = ApiService();

  @override
  void initState() {
    store = Store<NewsState>(initialState: NewsState.initial());
    store.dispatch(LoadProductsAction(apiService));
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
    return StoreProvider<NewsState>(
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
        body: StoreConnector<NewsState, _NewsScreenViewModel>(
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
                return InkWell(
                  onTap: () {
                    ProductService.instance.updateSelectedProductId(articles[index].id);

                    widget.navbarViewModel.dispatch(UpdateNavbarAction(newIndex: 1));
                  },
                  child: NewsCard(product: articles[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NewsScreenViewModel {
  final List<Product> articles;
  final bool isLoading;

  _NewsScreenViewModel({required this.articles, required this.isLoading});

  factory _NewsScreenViewModel.fromStore(Store<NewsState> store) {
    final loadingState = store.state.getOperationState(LoadProductsOperation.loadProducts);

    return _NewsScreenViewModel(
      articles: store.state.articles.toList(), // Convert BuiltList back to List
      isLoading: loadingState.isInProgress,
    );
  }
}
