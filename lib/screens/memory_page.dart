import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projetoso/mobx/queue_controller.dart';
import 'package:projetoso/widgets/queue.dart';
import 'package:projetoso/widgets/queue_concluidos.dart';
import '../constantes.dart';
import '../models/memory.dart';
import '../models/models.dart';
import '../widgets/queue_execucao.dart';

class MemoryPage extends StatefulWidget {
  const MemoryPage({
    super.key,
    required this.quantidadeDeProcessos,
    required this.tamanhoMemoria,
    required this.memoriaSO,
    required this.estrategiaAlocacao,
    required this.minMemoriaProcesso,
    required this.maxMemoriaProcesso,
    required this.minMomentoCriacao,
    required this.maxMomentoCriacao,
    required this.minDuracaoProcesso,
    required this.maxDuracaoProcesso,
  });

  final int quantidadeDeProcessos;
  final int tamanhoMemoria;
  final int memoriaSO;
  final String estrategiaAlocacao;
  final int minMemoriaProcesso;
  final int maxMemoriaProcesso;
  final int minMomentoCriacao;
  final int maxMomentoCriacao;
  final int minDuracaoProcesso;
  final int maxDuracaoProcesso;

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  int relogio = 0;

  late String estrategia;

  late Memory memoria;

  final processos = QueueController<Processo>();

  final processosEmFila = QueueController<Processo>();

  final processosConcluidos = QueueController<Processo>();

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    estrategia = widget.estrategiaAlocacao;
    memoria = Memory(widget.tamanhoMemoria);
    criarProcessos(widget.quantidadeDeProcessos);
    addSo(widget.memoriaSO);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      incrementarTempoEspera();
      ajustarTempoEmExecucao();
      verificarProcessosParaFila();
      verificarProcessosParaExecucao();
      verificarProcessosParaConcluido();
      tornarEmHole();
      relogio++;
      print(processos.list.toString());
      print(processosEmFila.list.toString());
      print(memoria.blocos.list.toString());
      print(processosConcluidos.list.toString());
      print("------------------------------------------------");
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(builder: (_) {
          return Text(
              'Memoria utilizada: ${memoria.memoriaUtilizada} de ${widget.tamanhoMemoria}');
        }),
        leading: SizedBox(
          child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/FortalezaEsporteClube.svg/1200px-FortalezaEsporteClube.svg.png'),
          width: 100,
          height: 100,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: QueueWidget(controller: processosEmFila),
                    ),
                  ),
                  SizedBox(height: 4),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: QueueConcluidos(controller: processosConcluidos),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: ExecucaoQueueWidget(controller: memoria.blocos),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void criarProcessos(int qtdProcessos) {
    print("_-_QTD PROCESSOS: $qtdProcessos");
    for (int i = 0; i < qtdProcessos; i++) {
      processos.add(
        Processo(
          nome: 'Processo $i',
          memoria: widget.minMemoriaProcesso +
              Random().nextInt(
                  widget.maxMemoriaProcesso - widget.minMemoriaProcesso + 1),
          momentoDeCriacao: widget.minMomentoCriacao +
              Random().nextInt(
                  widget.maxMomentoCriacao - widget.minMomentoCriacao + 1),
          duracao: widget.minDuracaoProcesso +
              Random().nextInt(
                  widget.maxDuracaoProcesso - widget.minDuracaoProcesso + 1),
        ),
      );
    }
  }

  void addSo(int value) {
    memoria.blocos.add(
      Bloco(
        inicio: 0,
        fim: value - 1,
        processo: Processo(
          nome: 'So',
          memoria: value,
          momentoDeCriacao: 0,
          duracao: 3000,
        ),
      ),
    );

    incrementarMemoria(value, 'addSo');
    //memoria.memoriaUtilizada += value;
    memoria.blocos.add(
      Bloco(
        inicio: value,
        fim: memoria.tamanho - 1,
        processo: Processo(
          nome: BURACO,
          memoria: memoria.tamanho - value,
          momentoDeCriacao: 0,
          duracao: 3000,
        ),
      ),
    );
  }

  void firstFit(Processo processo) {
    for (int i = 1; i < memoria.blocos.list.length; i++) {
      if (memoria.blocos.list[i].processo.nome == BURACO &&
          ((memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio) >
              processo.memoria)) {
        memoria.blocos.add(
          Bloco(
            inicio: memoria.blocos.list[i].inicio,
            fim: memoria.blocos.list[i].inicio + processo.memoria - 1,
            processo: processo,
          ),
          index: i,
        );
        final Bloco b = memoria.blocos.list[i + 1];
        b.inicio = memoria.blocos.list[i].fim + 1;
        b.processo.memoria = b.fim - b.inicio + 1;
        memoria.blocos.update(b, i + 1);

        incrementarMemoria(processo.memoria, 'firstFit');

        processosEmFila.remove(processosEmFila.list[0]);
        break;
      }
      if (memoria.blocos.list[i].processo.nome == BURACO &&
          ((memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio) ==
              processo.memoria)) {
        final Bloco b = memoria.blocos.list[i];
        b.processo = processo;

        memoria.blocos.update(b, i);

        incrementarMemoria(processo.memoria, 'firstFit');
        //memoria.memoriaUtilizada += processo.memoria;

        processosEmFila.remove(processosEmFila.list[0]);
        break;
      }
    }
  }

  void bestFit(Processo processo) {
    int bestFitItem = 0;
    int bestFitLenght = 0;
    for (int i = 1; i < memoria.blocos.list.length; i++) {
      if (memoria.blocos.list[i].processo.nome == BURACO &&
          ((memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio) >=
              processo.memoria)) {
        if (bestFitItem == 0) {
          bestFitItem = i;
          bestFitLenght =
              memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio;
        } else {
          if (memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio <
              bestFitLenght) {
            bestFitItem = i;
            bestFitLenght =
                memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio + 1;
          }
        }
      }
    }
    if (bestFitItem != 0) {
      if (bestFitLenght == processo.memoria) {
        final Bloco b = memoria.blocos.list[bestFitItem];
        b.processo = processo;
        memoria.blocos.update(b, bestFitItem);

        incrementarMemoria(processo.memoria, 'bestFit');

        processosEmFila.remove(processosEmFila.list[0]);
      } else {
        memoria.blocos.add(
          Bloco(
            inicio: memoria.blocos.list[bestFitItem].inicio,
            fim: memoria.blocos.list[bestFitItem].inicio + processo.memoria - 1,
            processo: processo,
          ),
          index: bestFitItem,
        );
        final Bloco b = memoria.blocos.list[bestFitItem + 1];
        b.inicio = memoria.blocos.list[bestFitItem].fim + 1;
        b.processo.memoria = b.fim - b.inicio + 1;
        memoria.blocos.update(b, bestFitItem + 1);

        incrementarMemoria(processo.memoria, 'bestFit');

        processosEmFila.remove(processosEmFila.list[0]);
      }
    }
  }

  void worstFit(Processo processo) {
    int worstFitItem = 0;
    int worstFitLenght = 0;
    for (int i = 1; i < memoria.blocos.list.length; i++) {
      if (memoria.blocos.list[i].processo.nome == BURACO &&
          ((memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio) >
              processo.memoria)) {
        if (worstFitItem == 0) {
          worstFitItem = i;
          worstFitLenght =
              memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio;
        } else {
          if (memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio >
              worstFitLenght) {
            worstFitItem = i;
            worstFitLenght =
                memoria.blocos.list[i].fim - memoria.blocos.list[i].inicio;
          }
        }
      }
    }
    if (worstFitItem != 0) {
      if (worstFitLenght == processo.memoria) {
        final Bloco b = memoria.blocos.list[worstFitItem];
        b.processo = processo;
        memoria.blocos.update(b, worstFitItem);

        incrementarMemoria(processo.memoria, 'worstFit');

        processosEmFila.remove(processosEmFila.list[0]);
      } else {
        memoria.blocos.add(
          Bloco(
            inicio: memoria.blocos.list[worstFitItem].inicio,
            fim:
                memoria.blocos.list[worstFitItem].inicio + processo.memoria - 1,
            processo: processo,
          ),
          index: worstFitItem,
        );
        final Bloco b = memoria.blocos.list[worstFitItem + 1];
        b.inicio = memoria.blocos.list[worstFitItem].fim + 1;
        b.processo.memoria = b.fim - b.inicio + 1;
        memoria.blocos.update(b, worstFitItem + 1);

        incrementarMemoria(processo.memoria, 'worstFit');

        processosEmFila.remove(processosEmFila.list[0]);
      }
    }
  }

  void tornarEmHole() {
    for (int i = 1; i < memoria.blocos.list.length; i++) {
      if (memoria.blocos.list[i].processo.duracao == 0) {
        incrementarMemoria(
            -memoria.blocos.list[i].processo.memoria, 'tornarEmHole');
        final Bloco b = memoria.blocos.list[i];
        b.processo.nome = BURACO;
        b.processo.duracao = 1000;

        memoria.blocos.update(b, i);
        verificarHolesVizinhos(i);
      }
    }
  }

  void verificarHolesVizinhos(int i) {
    if (memoria.blocos.list[i - 1].processo.nome == BURACO) {
      final Bloco b = memoria.blocos.list[i - 1];
      b.fim = memoria.blocos.list[i].fim;
      b.processo.memoria += memoria.blocos.list[i].processo.memoria;
      memoria.blocos.update(b, i - 1);

      memoria.blocos.remove(memoria.blocos.list[i]);

      if (memoria.blocos.list[i].processo.nome == BURACO) {
        final Bloco b = memoria.blocos.list[i];
        b.inicio = memoria.blocos.list[i - 1].inicio;
        b.processo.memoria += memoria.blocos.list[i - 1].processo.memoria;
        memoria.blocos.update(b, i);

        memoria.blocos.remove(memoria.blocos.list[i - 1]);
      }
    } else if (memoria.blocos.list[i + 1].processo.nome ==
        BURACO /*&& i>memoria.blocos.list.length*/) {
      final Bloco b = memoria.blocos.list[i + 1];
      b.inicio = memoria.blocos.list[i].inicio;
      b.processo.memoria += memoria.blocos.list[i].processo.memoria;

      memoria.blocos.remove(memoria.blocos.list[i]);
    }
  }

  void incrementarTempoEspera() {
    if (processosEmFila.list.isNotEmpty) {
      for (int i = 0; i < processosEmFila.list.length; i++) {
        final Processo p = processosEmFila.list[i];
        p.tempoDeEspera++;
        processosEmFila.update(p, i);
      }
    }
  }

  void ajustarTempoEmExecucao() {
    for (int i = 1; i < memoria.blocos.list.length; i++) {
      if (memoria.blocos.list[i].processo.nome != BURACO &&
          memoria.blocos.list[i].processo.duracao > 0) {
        final Bloco b = memoria.blocos.list[i];
        b.processo.duracao--;
        b.processo.tempoEmExecucao++;
        memoria.blocos.update(b, i);
      }
    }
  }

  void verificarProcessosParaFila() {
    if (processos.list.isNotEmpty &&
        processos.list[0].momentoDeCriacao == relogio) {
      processosEmFila.add(processos.list[0]);
      processos.remove(processos.list[0]);
      relogio = 0;
    }
  }

  void verificarProcessosParaExecucao() {
    if (processosEmFila.list.isNotEmpty) {
      if (estrategia == 'First fit') {
        firstFit(processosEmFila.list[0]);
      }
      if (estrategia == 'Best fit') {
        bestFit(processosEmFila.list[0]);
      }
      if (estrategia == 'Worst fit') {
        worstFit(processosEmFila.list[0]);
      }
    }
  }

  void verificarProcessosParaConcluido() {
    for (int i = 1; i < memoria.blocos.list.length; i++) {
      if ((!memoria.blocos.list[i].processo.nome.contains('Buraco')) &&
          (memoria.blocos.list[i].processo.duracao == 0)) {
        final Processo b = memoria.blocos.list[i].processo;
        b.momentoAlocacao = b.momentoDeCriacao + b.tempoDeEspera;
        b.tempoConclusao =
            b.momentoDeCriacao + b.tempoEmExecucao + b.tempoDeEspera;

        processosConcluidos.add(b.copyWith());
      }
    }
  }

  void incrementarMemoria(int incremento, String fname) {
    print('função: $fname , incremento: $incremento');
    memoria.setMemoriaUtilizada(memoria.memoriaUtilizada + incremento);
  }
}
