import 'package:flutter_riverpod/flutter_riverpod.dart';

//Main page index
final pgIndexProvider = StateProvider<int>((ref) => 2);

//Sub page index
final subPgIndexProvider = StateProvider<int>((ref) => 2);

//Navigation History provider
final navStackProvider = StateNotifierProvider<NavStackNotifier, List<int>>(
  (ref) => NavStackNotifier(),
);

// Update Page Index
void updatePgIndex(WidgetRef ref, int newPageIndex, int subPageIndex) {
  ref.read(pgIndexProvider.notifier).state = newPageIndex;
  ref.read(subPgIndexProvider.notifier).state = subPageIndex;
}

// Navigation History Stack
class NavStackNotifier extends StateNotifier<List<int>> {
  NavStackNotifier() : super([2]); // Default to Home index

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
