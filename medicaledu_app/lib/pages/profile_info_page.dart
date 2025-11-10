import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_account_page.dart';
import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../models/user_profile.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _examController = TextEditingController();
  DateTime? _date;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _examController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final last = DateTime(now.year + 10);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? first,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) setState(() => _date = picked);
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Enter email';
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final exam = _examController.text.trim();
      // Save to singleton profile
      UserProfile.instance.setBasicInfo(name: name, email: email, examName: exam, examDate: _date ?? DateTime.now());
      // Debug print: entering submit and values
      // ignore: avoid_print
      print('[_submit] name=$name email=$email exam=$exam date=${_date ?? DateTime.now()}');
      // Save to Firestore
      _saveToFirestore(name: name, email: email, exam: exam, date: _date ?? DateTime.now());
    }
  }

  Future<void> _saveToFirestore({required String name, required String email, required String exam, required DateTime date}) async {
    // Use a local mounted flag to avoid using BuildContext after async gaps.
    final messenger = ScaffoldMessenger.of(context);
    // Show UI and print to terminal immediately so we know the save started.
    // ignore: avoid_print
    print('[save] Showing saving SnackBar');
    messenger.showSnackBar(const SnackBar(content: Text('Saving profile...')));
    try {
      // Ensure Firebase is initialized (protect against cases where this page
      // is reached before main() finished initialization). Calling
      // initializeApp again is a no-op if an app already exists.
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
  // Use the default Firestore database and collection 'users-test'.
  final users = FirebaseFirestore.instance.collection('users-test');
      // Debug print: about to set document
      // ignore: avoid_print
      print('[save] About to set document in users-test');
      final doc = users.doc();
      await doc.set({
        'name': name,
        'email': email,
        'exam': exam,
        'examDate': Timestamp.fromDate(date),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Debug print after set completed
      // ignore: avoid_print
      print('[save] await doc.set() completed');

      // After awaiting, ensure widget is still mounted before using context.
      if (!mounted) return;

      // Show the created document ID in the UI so you get immediate confirmation.
      final createdId = doc.id;
  developer.log('Firestore write succeeded, docId=$createdId');
  // Also print to the terminal so `flutter run` output shows the doc id.
  // This helps when DevTools isn't open.
  // ignore: avoid_print
  print('Firestore write succeeded, docId=$createdId');
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text('Profile saved (id: $createdId)')));

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateAccountPage()));
    } catch (e, s) {
      // Log to browser/console for easier debugging (shows network/errors in DevTools).
  developer.log('Firestore save failed', error: e, stackTrace: s);
  // ignore: avoid_print
  print('Firestore save failed: $e');
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text('Failed to save profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tell us about yourself', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Lorem Ipsum', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Name*'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 16),

                      const Text('Email*'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),

                      const Text('Name of exam'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _examController,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),

                      const Text('Date of appearing'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _date == null ? 'MM / DD / YYYY' : '${_date!.month}/${_date!.day}/${_date!.year}',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate),
                            ),
                            validator: (_) {
                              if (_date == null) return 'Select date of appearing';
                              // require date strictly in the future
                              final today = DateTime.now();
                              final pickedDate = DateTime(_date!.year, _date!.month, _date!.day);
                              final compareDate = DateTime(today.year, today.month, today.day);
                              if (!pickedDate.isAfter(compareDate)) return 'Select a future date';
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
