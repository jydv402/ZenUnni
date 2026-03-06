import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zen/zen_barrel.dart';

class ApiKeyPage extends ConsumerStatefulWidget {
  const ApiKeyPage({super.key});

  @override
  ConsumerState<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends ConsumerState<ApiKeyPage> {
  final _keyController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _loadExistingKey();
  }

  Future<void> _loadExistingKey() async {
    final existingKey = await _storage.read(key: 'gemini_api_key');
    if (existingKey != null) {
      setState(() {
        _keyController.text = existingKey;
      });
    }
  }

  Future<void> _saveKey() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      showHeadsupNoti(context, ref, "Please enter a valid API Key");
      return;
    }

    setState(() => _isLoading = true);

    // Save to secure storage
    await _storage.write(key: 'gemini_api_key', value: key);

    setState(() => _isLoading = false);

    if (mounted) {
      setState(() => _canPop = true);
      // Invalidate the aiServiceProvider so it fetches the new key
      ref.invalidate(aiServiceProvider);

      showHeadsupNoti(context, ref, "API Key saved securely!");

      // If we came from the navbar enforcement, pop back. If not it just pops from profile
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = ref.watch(appColorsProvider);
    return PopScope(
        canPop: _canPop,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('API Key Integration',
                style: TextStyle(fontFamily: 'Pop', fontSize: 24)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  LucideIcons.key_round,
                  size: 80,
                  color: colors.iconClr,
                ),
                const SizedBox(height: 24),
                Text(
                  "Bring Your Own Key (BYOK)",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "To keep Unni completely free and independent, you need to provide your own Google Gemini API key.\n\nYour key is stored securely on your device and is only sent directly to Google's servers.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    final url =
                        Uri.parse('https://aistudio.google.com/app/apikey');
                    final launched = await launchUrl(url);
                    if (!launched && mounted) {
                      showHeadsupNoti(
                          context, ref, 'Could not open Google AI Studio');
                    }
                  },
                  child: Text(
                    "Get a free API key from Google AI Studio",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    hintText: "Enter your Gemini API Key",
                    filled: true,
                    fillColor: colors.pillClr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                  obscureText: true, // Hide the key text
                ),
              ],
            ),
          ),
          floatingActionButton: fabButton(context, () {
            _saveKey();
          }, _isLoading ? "Saving..." : "Save API Key", 28),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
