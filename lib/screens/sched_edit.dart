import 'dart:convert';

import 'package:json_store/json_store.dart';
import 'package:zen/zen_barrel.dart';

class ManualSchedEdit extends ConsumerStatefulWidget {
  const ManualSchedEdit({super.key});

  @override
  ConsumerState<ManualSchedEdit> createState() => _ManualSchedEditState();
}

class _ManualSchedEditState extends ConsumerState<ManualSchedEdit> {
  final TextEditingController _scheduleController = TextEditingController();
  final JsonStore _jsonStore = JsonStore();
  String scheduleKey = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final username = ref.read(userNameProvider);
    scheduleKey = 'saved_sched_${username.value}';

    final storedSchedule = await _jsonStore.getItem(scheduleKey);
    if (storedSchedule != null) {
      setState(
        () {
          _scheduleController.text = const JsonEncoder.withIndent('  ')
              .convert(storedSchedule['schedule']);
          _isLoading = false;
        },
      );
    } else {
      setState(
        () {
          _scheduleController.text = "No saved schedule found.";
          _isLoading = false;
        },
      );
    }
  }

  Future<void> _saveSchedule() async {
    try {
      final List<dynamic> updatedSchedule =
          jsonDecode(_scheduleController.text);
      await _jsonStore.setItem(scheduleKey, {'schedule': updatedSchedule});

      if (mounted) {
        showHeadsupNoti(context, ref, "Schedule saved!");
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showHeadsupNoti(context, ref, "Oops! Something went wrong.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Schedule Editor',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 26),
          _isLoading
              ? Center(
                  child: showRunningIndicator(
                      context, "Loading Saved Schedule..."),
                )
              : TextField(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(height: 2),
                  controller: _scheduleController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: "Edit your schedule (JSON format)",
                    alignLabelWithHint: true,
                  ),
                ),
          const SizedBox(height: 135),
        ],
      ),
      floatingActionButton:
          fabButton(context, () => _saveSchedule(), "Save Schedule", 26),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
