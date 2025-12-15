import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:task_requirements/action/delete_product_action.dart';
import 'package:task_requirements/action/load_products_action.dart';
import 'package:task_requirements/action/update_navbar_action.dart';
import 'package:task_requirements/core/service/api_service.dart';
import 'package:task_requirements/core/service/firebase_service.dart';
import 'package:task_requirements/core/service/notification/notification_service.dart';
import 'package:task_requirements/core/service/product_service.dart';
import 'package:task_requirements/screens/navbar_screen.dart';
import 'package:task_requirements/state/news/product_state.dart';
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
  late Store<ProductState> store;
  final apiService = ApiService();

  @override
  void initState() {
    store = Store<ProductState>(initialState: ProductState.initial());
    store.dispatch(LoadProductsAction(apiService));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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

  void _showAddProductDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    // We assume categoryId is 1 and image is a placeholder for simplicity
    const int defaultCategoryId = 1;
    const List<String> defaultImages = ["https://placehold.co/600x400"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final price = int.tryParse(priceController.text);
                if (titleController.text.isNotEmpty && price != null) {
                  store.dispatch(
                    CreateProductAction(
                      apiService,
                      title: titleController.text,
                      price: price,
                      description: descriptionController.text.isEmpty
                          ? "No description"
                          : descriptionController.text,
                      categoryId: defaultCategoryId,
                      images: defaultImages,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<ProductState>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top Products'),
          actions: [ElevatedButton(onPressed: () {
            _showAddProductDialog();
          }, child: Text("Add Product"))],
        ),
        body: StoreConnector<ProductState, _NewsScreenViewModel>(
          converter: (store) => _NewsScreenViewModel.fromStore(store),
          builder: (context, vm) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final products = vm.articles;
            if (products.isEmpty) {
              return const Center(child: Text("No products found."));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ProductService.instance.updateSelectedProductId(products[index].id);

                    widget.navbarViewModel.dispatch(UpdateNavbarAction(newIndex: 1));
                  },
                  child: NewsCard(
                    product: products[index],
                    onDelete: () {
                      store.dispatch(
                        DeleteProductAction(apiService, productId: products[index].id),
                      );
                    },
                  ),
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

  factory _NewsScreenViewModel.fromStore(Store<ProductState> store) {
    final loadingState = store.state.getOperationState(ProductOperation.loadProducts);

    return _NewsScreenViewModel(
      articles: store.state.articles.toList(), // Convert BuiltList back to List
      isLoading: loadingState.isInProgress,
    );
  }
}
