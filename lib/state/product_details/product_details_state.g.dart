// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductDetailsState extends ProductDetailsState {
  @override
  final Product product;
  @override
  final BuiltMap<Object, OperationState> operationsState;

  factory _$ProductDetailsState([
    void Function(ProductDetailsStateBuilder)? updates,
  ]) => (ProductDetailsStateBuilder()..update(updates))._build();

  _$ProductDetailsState._({
    required this.product,
    required this.operationsState,
  }) : super._();
  @override
  ProductDetailsState rebuild(
    void Function(ProductDetailsStateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProductDetailsStateBuilder toBuilder() =>
      ProductDetailsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductDetailsState &&
        product == other.product &&
        operationsState == other.operationsState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jc(_$hash, operationsState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductDetailsState')
          ..add('product', product)
          ..add('operationsState', operationsState))
        .toString();
  }
}

class ProductDetailsStateBuilder
    implements Builder<ProductDetailsState, ProductDetailsStateBuilder> {
  _$ProductDetailsState? _$v;

  Product? _product;
  Product? get product => _$this._product;
  set product(Product? product) => _$this._product = product;

  MapBuilder<Object, OperationState>? _operationsState;
  MapBuilder<Object, OperationState> get operationsState =>
      _$this._operationsState ??= MapBuilder<Object, OperationState>();
  set operationsState(MapBuilder<Object, OperationState>? operationsState) =>
      _$this._operationsState = operationsState;

  ProductDetailsStateBuilder();

  ProductDetailsStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _product = $v.product;
      _operationsState = $v.operationsState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductDetailsState other) {
    _$v = other as _$ProductDetailsState;
  }

  @override
  void update(void Function(ProductDetailsStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductDetailsState build() => _build();

  _$ProductDetailsState _build() {
    _$ProductDetailsState _$result;
    try {
      _$result =
          _$v ??
          _$ProductDetailsState._(
            product: BuiltValueNullFieldError.checkNotNull(
              product,
              r'ProductDetailsState',
              'product',
            ),
            operationsState: operationsState.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operationsState';
        operationsState.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ProductDetailsState',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
