import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  void run(FutureOr<void> Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () async {
      await action();
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
