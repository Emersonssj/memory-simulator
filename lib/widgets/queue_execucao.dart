import 'package:flutter/material.dart';
import 'package:projetoso/mobx/queue_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/models.dart';

class ExecucaoQueueWidget extends StatefulWidget {
  const ExecucaoQueueWidget({super.key, required this.controller});

  final QueueController<Bloco> controller;

  @override
  State<ExecucaoQueueWidget> createState() => _ExecucaoQueueWidgetState();
}

class _ExecucaoQueueWidgetState extends State<ExecucaoQueueWidget> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return ListView.builder(
        itemBuilder: (_, idx) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(width: 1),
            ),
            child: Column(
              children: [
                Text('${widget.controller.list[idx].inicio}'),
                Text(
                    '${widget.controller.list[idx].processo.nome}, ${widget.controller.list[idx].processo.memoria}mb'),
                Text('${widget.controller.list[idx].fim}'),
              ],
            ),
          ),
        ),
        itemCount: widget.controller.list.length,
      );
    });
  }
}
