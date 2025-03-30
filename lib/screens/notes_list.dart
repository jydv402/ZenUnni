import 'package:zen/zen_barrel.dart';

class NotesList extends ConsumerWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(
          "Notes",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      floatingActionButton: fabButton(context, () {
        Navigator.pushNamed(context, '/note');
      }, "Add Note", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
