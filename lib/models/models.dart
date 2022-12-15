import 'package:projetoso/mobx/queue_controller.dart';

/*
class Memoria {
  int tamanho;
  int memoriaUtilizada = 0;

  final blocos = QueueController<Bloco>();

  Memoria({
    required this.tamanho,
  });
}
*/
class Bloco extends IListItem {
  int inicio;
  int fim;
  Processo processo;

  Bloco({
    required this.inicio,
    required this.fim,
    required this.processo,
  });

  @override
  String getLabelText() =>
      "bloco ${processo.nome}, TAMANHO ${processo.memoria}kb";

  @override
  String toString() => getLabelText();
}

class Processo extends IListItem {
  String nome;
  int memoria;
  int momentoDeCriacao;
  int duracao;
  int? tempoConclusao;
  int tempoDeEspera = 0;
  int? momentoAlocacao;
  int tempoEmExecucao = 0;

  Processo({
    required this.nome,
    required this.memoria,
    required this.momentoDeCriacao,
    required this.duracao,
    this.tempoConclusao,
    this.momentoAlocacao,
  });

  @override
  String getLabelText() =>
      "$nome> Criado em ${momentoDeCriacao}s > tamanho ${memoria}kb";

  @override
  String toString() => getLabelText();

  Processo copyWith({
    String? nome,
    int? memoria,
    int? momentoDeCriacao,
    int? duracao,
    int? tempoConclusao,
    int? momentoAlocacao,
  }) {
    return Processo(
      nome: nome ?? this.nome,
      memoria: memoria ?? this.memoria,
      momentoDeCriacao: momentoDeCriacao ?? this.momentoDeCriacao,
      duracao: duracao ?? this.duracao,
      tempoConclusao: tempoConclusao ?? this.tempoConclusao,
      momentoAlocacao: momentoAlocacao ?? this.momentoAlocacao,
    );
  }
}
