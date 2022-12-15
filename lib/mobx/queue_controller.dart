import 'package:mobx/mobx.dart';
part 'queue_controller.g.dart';

class QueueController<T extends IListItem> = _QueueControllerBase<T>
    with _$QueueController;

abstract class _QueueControllerBase<T extends IListItem> with Store {
  @observable
  ObservableList<T> list = <T>[].asObservable();

  @action
  void add(T e, {int? index}) {
    if (index != null)
      list.insert(index, e);
    else
      list.add(e);
  }

  @action
  void remove(T e) => list.remove(e);

  @action
  void update(T e, int index) => list[index] = e;
}

abstract class IListItem {
  String getLabelText();
}
