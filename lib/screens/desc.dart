import 'package:zen/zen_barrel.dart';

class DescPage extends ConsumerStatefulWidget {
  final bool? isEdit;
  final UserModel? user;
  const DescPage({super.key, this.isEdit, this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DescPageState();
}

class _DescPageState extends ConsumerState<DescPage> {
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController freeTimeController = TextEditingController();
  final TextEditingController bedtimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      aboutController.text = widget.user?.about ?? '';
      freeTimeController.text = widget.user?.freeTime ?? '';
      bedtimeController.text = widget.user?.bedtime ?? '';
    }
  }

  @override
  void dispose() {
    aboutController.dispose();
    freeTimeController.dispose();
    bedtimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: pagePadding,
        children: [
          Text(
            "Tell us more about yourself",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 40),
          _buildTextField(aboutController, "What defines you the best?"),
          const SizedBox(height: 20),
          _buildTextField(freeTimeController, "How long is your free time?"),
          const SizedBox(height: 20),
          _buildTextField(bedtimeController, "When is your bedtime?"),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: fabButton(
        context,
        () async {
          final about = aboutController.text.trim();
          final freeTime = freeTimeController.text.trim();
          final bedtime = bedtimeController.text.trim();

          if (about.isNotEmpty && freeTime.isNotEmpty && bedtime.isNotEmpty) {
            if (widget.isEdit == true) {
              await updateUserDesc(about, freeTime, bedtime);
              if (context.mounted) {
                Navigator.pop(context);
                showHeadsupNoti(context, ref, "Profile updated successfully.");
              }
            } else {
              await saveUserDesc(about, freeTime, bedtime);
              if (context.mounted) {
                Navigator.pushNamed(context, '/home');
              }
            }
          } else {
            showHeadsupNoti(context, ref, "Please fill in all fields.");
          }
        },
        widget.isEdit == true ? "Update Details" : "Continue to Home",
        26,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      minLines: null,
      maxLines: null,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: hintText,
      ),
    );
  }
}
