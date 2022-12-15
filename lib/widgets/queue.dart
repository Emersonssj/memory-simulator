import 'package:flutter/material.dart';
import 'package:projetoso/mobx/queue_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../models/models.dart';

class QueueWidget<T extends IListItem> extends StatefulWidget {
  const QueueWidget({super.key, required this.controller});

  final QueueController<T> controller;

  @override
  State<QueueWidget> createState() => _QueueWidgetState();
}

class _QueueWidgetState extends State<QueueWidget> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return ListView.builder(
        itemBuilder: (_, idx) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(widget.controller.list[idx].getLabelText()),
        ),
        itemCount: widget.controller.list.length,
      );
    });
  }
}
