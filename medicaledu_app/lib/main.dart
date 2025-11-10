import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/loader_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Debug-only diagnostics: attempt a single write to Firestore to verify connectivity.
  assert(() {
    () async {
      try {
  final testRef = FirebaseFirestore.instance.collection('users-test').doc();
        await testRef.set({
          'diagnostic': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
        developer.log('Firestore diagnostic write succeeded: ${testRef.id}');
        // Also print so flutter's terminal captures the event when running web.
        print('Firestore diagnostic write succeeded: ${testRef.id}');
      } catch (e, s) {
        developer.log('Firestore diagnostic write failed: $e', error: e, stackTrace: s);
        print('Firestore diagnostic write failed: $e');
      }
    }();
    return true;
  }());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'medicaledu',
      theme: ThemeData(),
      home: const LoaderPage(),
    );
  }
}
