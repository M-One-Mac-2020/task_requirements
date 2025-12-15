import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'navbar_state.g.dart';

abstract class NavbarState implements Built<NavbarState, NavbarStateBuilder>, GlobalState {
  factory NavbarState([void Function(NavbarStateBuilder) updates]) = _$NavbarState;

  NavbarState._();

  factory NavbarState.initial() {
    return NavbarState(
      (b) => b
        ..currentIndex = 0
        ..operationsState = BuiltMap<Object, OperationState>().toBuilder(),
    );
  }

  int get currentIndex;

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
