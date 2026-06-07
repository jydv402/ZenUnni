import 'package:firebase_auth/firebase_auth.dart';
import 'package:zen/zen_barrel.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user is logged in
          if (snapshot.hasData) {
            return const Navbar();
          }
          //if user is not logged in
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
