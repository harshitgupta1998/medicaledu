// import 'package:flutter/material.dart';
// import 'pages/loader_page.dart';
// import 'pages/cards_page.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'medicaledu',
//       theme: ThemeData(),
//       home: const LoaderPage(),
//       routes: {
//         '/cards': (context) => const CardsPage(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Call the setup method
  await FirebaseSetup.createPhoneNumbersCollection();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Firebase Setup')),
        body: Center(child: Text('Firebase setup completed!')),
      ),
    );
  }
}
