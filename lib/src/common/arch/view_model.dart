import 'dart:collection';

import 'package:flutter/material.dart';

abstract class ViewModel<State, Event> extends ChangeNotifier {
  final _eventQueue = Queue<Event>();
  Event? currentEvent;

  abstract State state;

  @protected
  void setState(State newState) {
    state = newState;
    notifyListeners();
  }

  @protected
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
