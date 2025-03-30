import 'dart:convert';
import 'package:zen/zen_barrel.dart';
import 'package:json_store/json_store.dart';

class NotePage extends ConsumerStatefulWidget {
  const NotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final JsonStore _jsonStore = JsonStore();

  @override
  void dispose() {
    _headingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    final note = {
      'heading': _headingController.text,
      'content': _controller.text,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _jsonStore.setItem('noteKey', note);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 80, 0, 16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            TextField(
              controller: _headingController,
              style: Theme.of(context).textTheme.headlineLarge,
              decoration: InputDecoration(
                hintText: 'Note Heading...',
                hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: theme == ThemeMode.dark
                          ? Colors.white38
                          : Colors.black45,
                    ),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                minLines: null,
                keyboardType: TextInputType.multiline,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: fabButton(context, () {
        saveNote();
      }, 'Save Note', 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
