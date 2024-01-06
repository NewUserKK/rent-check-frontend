import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/widgets/loader.dart';

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
      return const Loader();
    },
  );
}

void withProviderOnFrame<T>(BuildContext context, void Function(T) block) {
  doOnPostFrame(context, () => block(Provider.of<T>(context, listen: false)));
}

void doOnPostFrame(BuildContext context, void Function() block) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    block();
  });
}
