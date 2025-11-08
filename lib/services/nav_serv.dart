import 'package:flutter_riverpod/flutter_riverpod.dart';

//Main page index
final pgIndexProvider = NotifierProvider<PageNotifier, int>(PageNotifier.new);

class PageNotifier extends Notifier<int> {
  @override
  int build() => 2;

  void setState(int newState) {
    state = newState;
  }
}

//Sub page index
final subPgIndexProvider =
    NotifierProvider<SubPageNotifier, int>(SubPageNotifier.new);

class SubPageNotifier extends Notifier<int> {
  @override
  int build() => 2;

  void setState(int newState) {
    state = newState;
  }
}

//Navigation History provider
final navStackProvider = NotifierProvider<NavStackNotifier, List<int>>(
  NavStackNotifier.new,
);

// Update Page Index
void updatePgIndex(WidgetRef ref, int newPageIndex, int subPageIndex) {
  // Update page index
  ref.read(pgIndexProvider.notifier).setState(newPageIndex);
  // Update sub page index
  ref.read(subPgIndexProvider.notifier).setState(subPageIndex);
}

// Navigation History Stack
class NavStackNotifier extends Notifier<List<int>> {
  @override
  List<int> build() => [2]; // Default to Home index

  void push(int index) {
    if (state.last != index) {
      state = [...state, index]; // Add new element
    }
  }

  void pop() {
    if (state.length > 1) {
      state = [...state..removeLast()]; // Remove last element
    }
  }

  void reset() {
    state = [2]; // Reset to Home index
  }
}
