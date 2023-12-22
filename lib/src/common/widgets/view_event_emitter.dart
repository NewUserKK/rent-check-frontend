import 'dart:collection';

import 'package:flutter/foundation.dart';

abstract class ViewEventEmitter<Event> extends ChangeNotifier {
  final _eventQueue = Queue<Event>();
  Event? currentEvent;

  void emitEvent(Event event) async {
    _eventQueue.addLast(event);
    while (_eventQueue.isNotEmpty) {
      currentEvent = _eventQueue.removeFirst();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 50));
    }
    currentEvent = null;
    notifyListeners();
  }
}
