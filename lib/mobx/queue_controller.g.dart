// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QueueController<T extends IListItem> on _QueueControllerBase<T>, Store {
  late final _$listAtom =
      Atom(name: '_QueueControllerBase.list', context: context);

  @override
  ObservableList<T> get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(ObservableList<T> value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_QueueControllerBaseActionController =
      ActionController(name: '_QueueControllerBase', context: context);

  @override
  void add(T e, {int? index}) {
    final _$actionInfo = _$_QueueControllerBaseActionController.startAction(
        name: '_QueueControllerBase.add');
    try {
      return super.add(e, index: index);
    } finally {
      _$_QueueControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void remove(T e) {
    final _$actionInfo = _$_QueueControllerBaseActionController.startAction(
        name: '_QueueControllerBase.remove');
    try {
      return super.remove(e);
    } finally {
      _$_QueueControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void update(T e, int index) {
    final _$actionInfo = _$_QueueControllerBaseActionController.startAction(
        name: '_QueueControllerBase.update');
    try {
      return super.update(e, index);
    } finally {
      _$_QueueControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
