import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notes/screens/sigin.dart';
import './screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAAX5TXvcMsk6krGXhoVMNXP8q2v0xfM40',
      appId: '1:58792502861:android:779f8594a02f674b505e04',
      messagingSenderId: '58792502861',
      projectId: 'flutternotes-cd107',
      storageBucket: 'flutternotes-cd107.appspot.com',
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return const MaterialApp(
        home: Home(),
      );
    }
    return const MaterialApp(
      home: SignIn(),
    );
  }
}
