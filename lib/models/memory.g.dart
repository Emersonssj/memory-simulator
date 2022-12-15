// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Memory on _MemoryBase, Store {
  late final _$memoriaUtilizadaAtom =
      Atom(name: '_MemoryBase.memoriaUtilizada', context: context);

  @override
  int get memoriaUtilizada {
    _$memoriaUtilizadaAtom.reportRead();
    return super.memoriaUtilizada;
  }

  @override
  set memoriaUtilizada(int value) {
    _$memoriaUtilizadaAtom.reportWrite(value, super.memoriaUtilizada, () {
      super.memoriaUtilizada = value;
    });
  }

  late final _$_MemoryBaseActionController =
      ActionController(name: '_MemoryBase', context: context);

  @override
  void setMemoriaUtilizada(int value) {
    final _$actionInfo = _$_MemoryBaseActionController.startAction(
        name: '_MemoryBase.setMemoriaUtilizada');
    try {
      return super.setMemoriaUtilizada(value);
    } finally {
      _$_MemoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
memoriaUtilizada: ${memoriaUtilizada}
    ''';
  }
}
