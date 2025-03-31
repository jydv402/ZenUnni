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
    _loadNotes(ref.read(userNameProvider).value!);
  }

  Future<void> _loadNotes(String username) async {
    final notes = await _notesService.getNotes(username);
    setState(() => _notes = notes);
  }

  Future<void> _deleteNote(int id, String username) async {
    await _notesService.deleteNote(id, username);
    _loadNotes(ref.read(userNameProvider).value!);
  }

  void _openNotePage([int? noteId]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotePage(noteId: noteId)),
    );
    if (result == true) _loadNotes(ref.read(userNameProvider).value!);
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userNameProvider).value;
    return Scaffold(
      body: _notes.isEmpty
          ? Center(
              child: Text(
              "No notes yet. Add one!",
              style: Theme.of(context).textTheme.headlineMedium,
            ))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
              itemCount: _notes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ScoreCard(),
                        Text(
                          "Notes",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  );
                } else {
                  final key = _notes.keys.elementAt(index - 1);
                  final note = _notes[key]!;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromRGBO(255, 140, 43, 1),
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      title: Text(note['heading'] ?? 'Untitled',
                          style: Theme.of(context).textTheme.headlineMedium),
                      subtitle: Text(note['content'] ?? 'No content',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium),
                      onTap: () => _openNotePage(key),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteNote(key, username!),
                      ),
                    ),
                  );
                }
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
