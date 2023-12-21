import 'package:flutter/material.dart';

FutureBuilder renderOnLoad<T>(
    Future<T> future, Widget Function(T data) onData
) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return onData(snapshot.data);
      } else if (snapshot.hasError) {
        final err = snapshot.error;
        return Text('$err');
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
