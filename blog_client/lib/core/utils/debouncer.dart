import 'dart:async';

class Debouncer<T> {
  Debouncer({Duration? duration})
    : duration = duration ?? const Duration(milliseconds: 300);
  final Duration duration;
  Timer? _timer;
  Completer<void>? _completer;

  Future<void> run(Future<void> Function() action) {
    // If a timer is active, cancel it and complete its completer if it's not already completed.
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      if (_completer != null && !_completer!.isCompleted) {
        _completer!.complete();
      }
    }

    // Create a new completer for this call.
    final completer = Completer<void>();
    _completer = completer;

    _timer = Timer(duration, () async {
      try {
        await action();
        if (!completer.isCompleted) {
          completer.complete();
        }
      } catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      }
    });

    return completer.future;
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _completer = null;
  }
}
