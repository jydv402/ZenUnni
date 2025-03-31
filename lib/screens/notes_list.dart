import 'package:zen/zen_barrel.dart';

class NotesList extends ConsumerStatefulWidget {
  const NotesList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesListState();
}

class _NotesListState extends ConsumerState<NotesList> {
  final NotesService _notesService = NotesService();
  Map<int, Map<String, String>> _notes = {};

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _notesService.getNotes();
    setState(() => _notes = notes);
  }

  Future<void> _deleteNote(int id) async {
    await _notesService.deleteNote(id);
    _loadNotes();
  }

  void _openNotePage([int? noteId]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotePage(noteId: noteId)),
    );
    if (result == true) _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Notes")),
      body: _notes.isEmpty
          ? const Center(child: Text("No notes yet. Add one!"))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final key = _notes.keys.elementAt(index);
                final note = _notes[key]!;
                return ListTile(
                  title: Text(note['heading'] ?? 'Untitled'),
                  subtitle: Text(note['content'] ?? 'No content',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => _openNotePage(key),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNote(key),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNotePage(),
        label: const Text("New Note"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
