import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldKeyProvider = Provider((ref) => GlobalKey<ScaffoldState>());

//Main page index
final pgIndexProvider = NotifierProvider<PageNotifier, int>(PageNotifier.new);

class PageNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setState(int newState) {
    state = newState;
  }
}

// Update Page Index
void updatePgIndex(WidgetRef ref, int newPageIndex) {
  // Update page index
  ref.read(pgIndexProvider.notifier).setState(newPageIndex);
}
