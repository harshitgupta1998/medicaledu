import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'create_account_page.dart';

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
      final date = _date != null ? _date!.toIso8601String() : null;

      final url = Uri.parse('https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/exams');
      final body = jsonEncode({
        'fields': {
          'name': {'stringValue': name},
          'email': {'stringValue': email},
          'exam': {'stringValue': exam},
          'dateOfAppearing': {'stringValue': date ?? ''},
        }
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );
      http.post(url, headers: {'Content-Type': 'application/json'}, body: body).then((res) {
        Navigator.of(context).pop(); // close loading dialog
        if (res.statusCode >= 200 && res.statusCode < 300) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile info saved')));
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const CreateAccountPage()));
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Save Failed'),
              content: SingleChildScrollView(child: Text('Status: ${res.statusCode}\nBody: ${res.body}')),
              actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
            ),
          );
        }
      }).catchError((e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save error: $e')));
      });
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
                const Text('Please provide your details to help us personalize your medical education experience.', style: TextStyle(color: Colors.black54)),
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
