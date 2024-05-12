import 'package:flutter/material.dart';
import 'package:disposebag/disposebag.dart';

mixin Disposer implements ChangeNotifier {
  @protected
  final DisposeBag disposeBag = DisposeBag();

  @override
  void dispose() {
    disposeBag.dispose();
  }
}
