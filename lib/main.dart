import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'router/app_router.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MiApp());

}

class MiApp extends StatelessWidget {

  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(

      debugShowCheckedModeBanner: false,

      routerConfig: router,

    );

  }

}