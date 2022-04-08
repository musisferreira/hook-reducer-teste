import 'dart:async';
import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  // ignore: require_trailing_commas
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((element) => element != null).cast();
}

/// Testando hooks para animações.
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
enum Action { rotateLeft, rotateRight, moreVisible, lessVisible }

@immutable
class State {
  final double rotateDeg;
  final double alpha;

  const State({required this.rotateDeg, required this.alpha});

  const State.zero()
      : rotateDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(rotateDeg: rotateDeg + 10.0, alpha: alpha);

  State rotateLeft() => State(rotateDeg: rotateDeg - 10.0, alpha: alpha);

  State increaseAlpha() => State(
        rotateDeg: rotateDeg,
        alpha: min(alpha + 0.1, 1.0),
      );

  State decreaseAlpha() => State(
        rotateDeg: rotateDeg,
        alpha: max(alpha - 0.1, 0.0),
      );
}

State reducer(State oldState, Action? actions) {
  switch (actions) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action>(
      reducer,
      initialState: const State.zero(),
      initialAction: Action.lessVisible,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => store.dispatch(Action.rotateLeft),
                  child: const Text('Rotate Left'),
                ),
                TextButton(
                  onPressed: () => store.dispatch(Action.rotateRight),
                  child: const Text('Rotate Right'),
                ),
                TextButton(
                  onPressed: () => store.dispatch(Action.lessVisible),
                  child: const Text('- Alpha'),
                ),
                TextButton(
                  onPressed: () => store.dispatch(Action.moreVisible),
                  child: const Text('+ Alpha'),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Opacity(
              opacity: store.state.alpha,
              child: RotationTransition(
                  turns: AlwaysStoppedAnimation(store.state.rotateDeg / 360.0),
                  child: Image.network(url)),
            ),
          ],
        ));
  }
}
