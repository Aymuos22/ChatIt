import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatit/LoginScreen.dart';
import 'package:chatit/Authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBkcKyliN3KHOf9qsqHYKw5q7TZJomppeA",
      authDomain: "chatapp-92bc9.firebaseapp.com",
      projectId: "chatapp-92bc9",
      storageBucket: "chatapp-92bc9.appspot.com",
      messagingSenderId: "122819236678",
      appId: "1:122819236678:web:4f15b0abd3a2a1b33c4b47",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
