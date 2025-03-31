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
    return Scaffold(
      appBar: AppBar(title: Text(noteId == null ? "New Note" : "Edit Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _headingController,
              decoration: const InputDecoration(labelText: 'Note Heading'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration:
                    const InputDecoration(labelText: 'Write your note...'),
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
