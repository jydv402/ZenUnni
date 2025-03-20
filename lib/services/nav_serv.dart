import 'package:flutter_riverpod/flutter_riverpod.dart';

final pgIndexProvider = StateProvider<int>((ref) => 0);

final subPgIndexProvider = StateProvider<int>((ref) => 0);

void updatePgIndex(WidgetRef ref, int newPageIndex, int subPageIndex) {
  ref.read(pgIndexProvider.notifier).state = newPageIndex;
  ref.read(subPgIndexProvider.notifier).state = subPageIndex;
}
