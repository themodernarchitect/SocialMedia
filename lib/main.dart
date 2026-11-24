
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // On web the persisted Firebase session is restored asynchronously.
  // Reading currentUser immediately returns null even when a saved user
  // exists, which would create a brand-new anonymous UID on every reload.
  // Waiting for the first auth event keeps the same UID (and therefore the
  // same users/<uid>/students records) across app restarts.
  final auth = FirebaseAuth.instance;
  final restoredUser = await auth.authStateChanges().first;

  if (restoredUser == null) {
    await auth.signInAnonymously();
  }

  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
