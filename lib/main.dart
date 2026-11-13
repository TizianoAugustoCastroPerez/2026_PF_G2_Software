import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'router/app_router.dart';

// If you used the FlutterFire CLI to configure Firebase, it generates
// `lib/firebase_options.dart` with `DefaultFirebaseOptions` for each platform.
// Run `flutterfire configure` to generate that file and then uncomment
// the import below.
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Conectar a emuladores localmente en modo debug
  if (kDebugMode) {
    // Use the emulator host/port configured in firebase.json
    FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8086);
    FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
  }

  runApp(const MiApp());

}

class MiApp extends StatelessWidget {

  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
      ),

      routerConfig: router,

    );

  }

}