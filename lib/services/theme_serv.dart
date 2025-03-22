import 'package:zen/zen_barrel.dart';
import 'package:json_store/json_store.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = "dark_mode"; // Key for storage
  final JsonStore _jsonStore = JsonStore(); // JSON Store instance
  bool _isDarkMode = false;

  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final storedData = await _jsonStore.getItem(_themeKey);
    _isDarkMode = storedData?['darkMode'] ?? false;
    state = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    state = _isDarkMode ? ThemeMode.dark : ThemeMode.light;

    // Save theme preference in json_store
    await _jsonStore.setItem(_themeKey, {'darkMode': _isDarkMode});
  }
}

// Riverpod Provider for Theme
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
