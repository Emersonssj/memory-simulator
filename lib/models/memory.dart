import 'package:mobx/mobx.dart';
import '../mobx/queue_controller.dart';
import 'models.dart';
part 'memory.g.dart';

class Memory extends _MemoryBase with _$Memory {
  Memory(int tamanho) {
    super.tamanho = tamanho;
  }
}

abstract class _MemoryBase with Store {
  late int tamanho;

  @observable
  int memoriaUtilizada = 0;

  @action
  void setMemoriaUtilizada(int value) => memoriaUtilizada = value;

  final blocos = QueueController<Bloco>();
}
