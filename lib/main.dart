import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  // ignore: require_trailing_commas
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((element) => element != null).cast();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.dark(scheme: FlexScheme.materialHc),
      home: const HomePage(),
    );
  }
}

const url = 'https://bit.ly/3x7J5Qt';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late StreamController<double> controller;
    controller = useStreamController<double>(
      onListen: () {
        controller.sink.add(0.0);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder<double>(
        stream: controller.stream,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final rotation = snapshot.data ?? 0.0;
            return GestureDetector(
              onTap: () => controller.sink.add(rotation + 10.0),
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(rotation / 360.0),
                child: Center(
                  child: Image.network(url),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
