import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notes/screens/sigin.dart';
import './screens/home.dart';
import 'config.dart';
import 'package:flutter_notes/dao/database.dart';

void main() async {
  await Config.configure();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Config.apiKey!,
      appId: Config.appId!,
      messagingSenderId: Config.messagingSenderId!,
      projectId: Config.projectId!,
      storageBucket: Config.storageBucket!,
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> handleAppClose() async {
    await Database.closeConnection();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return WillPopScope(
          child: const MaterialApp(
            home: Home(),
          ),
          onWillPop: handleAppClose
      );
    }
    return const MaterialApp(
      home: SignIn(),
    );
  }
}
