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
    final colors = ref.watch(appColorsProvider);
    return Scaffold(
      body: _notes.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(26, 50, 26, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScoreCard(),
                  Text(
                    "Notes",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "No notes found. Tap the button below to create a new note.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            )
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
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                } else {
                  final key = _notes.keys.elementAt(index - 1);
                  final note = _notes[key]!;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromRGBO(255, 140, 43, 1),
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(note['heading'] ?? 'Untitled',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      subtitle: Text(note['content'] ?? 'No content',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium),
                      onTap: () => _openNotePage(key),
                      trailing: IconButton(
                        icon: Icon(LucideIcons.trash_2, color: colors.iconClr),
                        onPressed: () {
                          showConfirmDialog(
                            context,
                            "Delete Note ?",
                            "Are you sure you want to delete this note ?",
                            "Delete",
                            Colors.red,
                            () => _deleteNote(key, username!),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNotePage(),
        label: const Text(
          "New Note",
          style: TextStyle(
            fontFamily: 'Pop',
            fontSize: 13.0,
          ),
        ),
        icon: const Icon(LucideIcons.plus),
        foregroundColor: Colors.black,
      ),
    );
  }
}
