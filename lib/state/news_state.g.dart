// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final BuiltList<Article> articles;
  @override
  final BuiltMap<Object, OperationState> operationsState;

  factory _$AppState([void Function(AppStateBuilder)? updates]) =>
      (AppStateBuilder()..update(updates))._build();

  _$AppState._({required this.articles, required this.operationsState})
    : super._();
  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        articles == other.articles &&
        operationsState == other.operationsState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, articles.hashCode);
    _$hash = $jc(_$hash, operationsState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppState')
          ..add('articles', articles)
          ..add('operationsState', operationsState))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState? _$v;

  ListBuilder<Article>? _articles;
  ListBuilder<Article> get articles =>
      _$this._articles ??= ListBuilder<Article>();
  set articles(ListBuilder<Article>? articles) => _$this._articles = articles;

  MapBuilder<Object, OperationState>? _operationsState;
  MapBuilder<Object, OperationState> get operationsState =>
      _$this._operationsState ??= MapBuilder<Object, OperationState>();
  set operationsState(MapBuilder<Object, OperationState>? operationsState) =>
      _$this._operationsState = operationsState;

  AppStateBuilder();

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _articles = $v.articles.toBuilder();
      _operationsState = $v.operationsState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppState build() => _build();

  _$AppState _build() {
    _$AppState _$result;
    try {
      _$result =
          _$v ??
          _$AppState._(
            articles: articles.build(),
            operationsState: operationsState.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'articles';
        articles.build();
        _$failedField = 'operationsState';
        operationsState.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AppState',
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
