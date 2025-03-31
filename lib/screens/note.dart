import 'package:zen/zen_barrel.dart';

class NotePage extends ConsumerStatefulWidget {
  final int? noteId;
  const NotePage({super.key, this.noteId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NotesService _notesService = NotesService();
  int? noteId;

  @override
  void initState() {
    super.initState();
    noteId = widget.noteId;
    if (noteId != null) {
      _loadNote();
    }
  }

  Future<void> _loadNote() async {
    final notes = await _notesService.getNotes();
    if (notes.containsKey(noteId)) {
      _headingController.text = notes[noteId]!['heading']!;
      _contentController.text = notes[noteId]!['content']!;
    }
  }

  Future<void> _saveNote() async {
    if (_headingController.text.trim().isEmpty) return;
    final newId = noteId ?? DateTime.now().millisecondsSinceEpoch;
    await _notesService.saveNote(
        newId, _headingController.text.trim(), _contentController.text.trim());
    if (context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 2),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            TextField(
              controller: _headingController,
              style: Theme.of(context).textTheme.headlineLarge,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(26, 0, 26, 0),
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
                controller: _contentController,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        label: const Text("Save Note"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
