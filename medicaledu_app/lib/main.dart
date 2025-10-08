import 'package:flutter/material.dart';
import 'pages/loader_page.dart';

void main() => runApp(const MyApp());

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
