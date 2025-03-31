import 'package:json_store/json_store.dart';

class NotesService {
  final JsonStore _jsonStore = JsonStore();

  Future<Map<int, Map<String, String>>> getNotes() async {
    final data = await _jsonStore.getItem('notes');
    if (data == null) return {};
    return Map<int, Map<String, String>>.from(
      data.map((key, value) =>
          MapEntry(int.parse(key), Map<String, String>.from(value))),
    );
  }

  Future<void> saveNote(int id, String heading, String content) async {
    final notes = await getNotes();
    notes[id] = {'heading': heading, 'content': content};
    await _jsonStore.setItem(
        'notes', notes.map((key, value) => MapEntry(key.toString(), value)));
  }

  Future<void> deleteNote(int id) async {
    final notes = await getNotes();
    notes.remove(id);
    await _jsonStore.setItem(
        'notes', notes.map((key, value) => MapEntry(key.toString(), value)));
  }
}
