import 'package:task_requirements/core/models/product.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'product_details_state.g.dart';

abstract class ProductDetailsState
    implements Built<ProductDetailsState, ProductDetailsStateBuilder>, GlobalState {
  // BuiltValue boilerplate
  factory ProductDetailsState([void Function(ProductDetailsStateBuilder) updates]) =
      _$ProductDetailsState;

  ProductDetailsState._();

  factory ProductDetailsState.initial() {
    return ProductDetailsState(
      (b) => b
        ..product = Product.empty()
        ..operationsState = BuiltMap<Object, OperationState>().toBuilder(),
    );
  }

  Product get product;

  @override
  BuiltMap<Object, OperationState> get operationsState;

  @override
  T updateOperation<T extends GlobalState>(Object? operationKey, OperationState operationState) {
    if (operationKey == null) {
      return this as T;
    }

    final GlobalState newState = rebuild((s) => s.operationsState[operationKey] = operationState);
    return newState as T;
  }

  @override
  OperationState getOperationState(Object operationKey) {
    return operationsState[operationKey] ?? OperationState.idle;
  }
}
