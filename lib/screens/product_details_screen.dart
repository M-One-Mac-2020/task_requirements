import 'package:flutter/material.dart';
import 'package:task_requirements/action/product_details_action.dart';
import 'package:task_requirements/core/models/product.dart';
import 'package:task_requirements/core/service/api_service.dart';
import 'package:task_requirements/path_file.dart';
import 'package:task_requirements/state/product_details/product_details_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Store<ProductDetailsState> store;
  final apiService = ApiService();
  @override
  void initState() {
    store = Store<ProductDetailsState>(initialState: ProductDetailsState.initial());
    store.dispatch(ProductDetailsAction(apiService));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StoreProvider(
      store: store,
      child: StoreConnector<ProductDetailsState, ProductDetailsViewModel>(
        converter: (store) => ProductDetailsViewModel.fromStore(store),
        builder: (context, vm) {
          return Column(
            children: [
              AppBar(title: Text(vm.product.title), backgroundColor: Colors.deepPurple),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenWidth * 0.8,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: PageView.builder(
                        itemCount: vm.product.images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            vm.product.images[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.broken_image, size: 50)),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              vm.product.title,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '\$${vm.product.price}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(vm.product.category.name, style: const TextStyle(color: Colors.white)),
                            backgroundColor: Colors.deepPurple,
                            avatar: const Icon(Icons.label, color: Colors.white70, size: 18),
                          ),
                          const SizedBox(height: 16),

                          // --- 4. Description ---
                          const Text(
                            'Product Details',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),

                      child: Text(vm.product.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductDetailsViewModel {
  final Product product;

  // The dispatch function is generic over the state type: NavbarState
  final Function(ReduxAction<ProductDetailsState> action) dispatch;

  ProductDetailsViewModel({required this.product, required this.dispatch});

  factory ProductDetailsViewModel.fromStore(Store<ProductDetailsState> store) {
    return ProductDetailsViewModel(product: store.state.product, dispatch: store.dispatch);
  }
}
