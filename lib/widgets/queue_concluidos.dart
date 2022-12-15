import 'package:flutter/material.dart';
import 'package:projetoso/mobx/queue_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/models.dart';

class QueueConcluidos extends StatefulWidget {
  const QueueConcluidos({super.key, required this.controller});

  final QueueController<Processo> controller;

  @override
  State<QueueConcluidos> createState() => _QueueConcluidosState();
}

class _QueueConcluidosState extends State<QueueConcluidos> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return ListView.builder(
        itemBuilder: (_, idx) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
              '${widget.controller.list[idx].nome}, Criado ${widget.controller.list[idx].momentoDeCriacao}s, Alocado ${widget.controller.list[idx].momentoAlocacao}s, Concluido ${widget.controller.list[idx].tempoConclusao}s, Tempo de espera ${widget.controller.list[idx].tempoDeEspera}s'),
        ),
        itemCount: widget.controller.list.length,
      );
    });
  }
}
//PROCESSO 1> Criado em 15s > alocado na memoria em 16s > concluido em 20s > tempo de espera 50s