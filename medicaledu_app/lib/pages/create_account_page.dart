import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sign_in_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _dob;
  bool _obscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 120);
    final last = now;
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25),
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final dob = _dob != null ? _dob!.toIso8601String() : '';

    final usersUrl = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/users';

    // Query Firestore for existing username/email
    final queryUrl = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents:runQuery';
    final queryBody = jsonEncode({
      "structuredQuery": {
        "from": [{"collectionId": "users"}],
        "where": {
          "compositeFilter": {
            "op": "OR",
            "filters": [
              {"fieldFilter": {"field": {"fieldPath": "username"}, "op": "EQUAL", "value": {"stringValue": username}}},
              {"fieldFilter": {"field": {"fieldPath": "email"}, "op": "EQUAL", "value": {"stringValue": email}}}
            ]
          }
        }
      }
    });

    showDialog(context: context, barrierDismissible: false, builder: (ctx) => const Center(child: CircularProgressIndicator()));
    try {
      final queryRes = await http.post(Uri.parse(queryUrl), headers: {'Content-Type': 'application/json'}, body: queryBody);
      Navigator.of(context).pop();
      final queryList = jsonDecode(queryRes.body) as List;
      final exists = queryList.any((item) => item['document'] != null);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username or email already exists. Please sign in.')));
        // Navigate to sign in page
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignInPage()));
        return;
      }
      // Save new user
      final userBody = jsonEncode({
        'fields': {
          'username': {'stringValue': username},
          'email': {'stringValue': email},
          'password': {'stringValue': password},
          'dob': {'stringValue': dob},
        }
      });
      showDialog(context: context, barrierDismissible: false, builder: (ctx) => const Center(child: CircularProgressIndicator()));
      final res = await http.post(Uri.parse(usersUrl), headers: {'Content-Type': 'application/json'}, body: userBody);
      Navigator.of(context).pop();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully!')));
        // Navigate to cards page
        Navigator.of(context).pushReplacementNamed('/cards');
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
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Enter email';
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter password';
    if (v.length < 8) return 'Password must be at least 8 characters';
    final hasUpper = v.contains(RegExp(r'[A-Z]'));
    final hasLower = v.contains(RegExp(r'[a-z]'));
    final hasDigit = v.contains(RegExp(r'\d'));
    final hasSpecial = v.contains(RegExp(r'[!@#\$&*~%^()_+\-=\[\]{};:\\|,.<>\/?]'));
    if (!hasUpper || !hasLower || !hasDigit || !hasSpecial) {
      return 'Password must include upper, lower, number & special char';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.maybePop(context),
                ),
                const SizedBox(height: 8),
                Text('Create an account',
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Enter your account details below or '),
                const SizedBox(height: 24),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Username'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        validator: (v) => (v == null || v.isEmpty) ? 'Enter username' : null,
                      ),
                      const SizedBox(height: 16),

                      const Text('Date of Birth'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDob,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _dob == null ? 'MM / DD / YYYY' : '${_dob!.month}/${_dob!.day}/${_dob!.year}',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _pickDob,
                              ),
                            ),
                            validator: (_) => _dob == null ? 'Select date of birth' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Email'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),

                      const Text('Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Create Account'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignInPage()));
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Sign In'),
                      ),

                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            // Sign in logic: check if username/email exists and password matches
                            final username = _usernameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final queryUrl = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents:runQuery';
                            final queryBody = jsonEncode({
                              "structuredQuery": {
                                "from": [{"collectionId": "users"}],
                                "where": {
                                  "compositeFilter": {
                                    "op": "OR",
                                    "filters": [
                                      {"fieldFilter": {"field": {"fieldPath": "username"}, "op": "EQUAL", "value": {"stringValue": username}}},
                                      {"fieldFilter": {"field": {"fieldPath": "email"}, "op": "EQUAL", "value": {"stringValue": email}}}
                                    ]
                                  }
                                }
                              }
                            });
                            showDialog(context: context, barrierDismissible: false, builder: (ctx) => const Center(child: CircularProgressIndicator()));
                            try {
                              final queryRes = await http.post(Uri.parse(queryUrl), headers: {'Content-Type': 'application/json'}, body: queryBody);
                              Navigator.of(context).pop();
                              final queryList = jsonDecode(queryRes.body) as List;
                              final userDoc = queryList.firstWhere((item) => item['document'] != null, orElse: () => null);
                              if (userDoc == null) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found. Please create an account.')));
                                return;
                              }
                              final fields = userDoc['document']['fields'];
                              if (fields['password'] != null && fields['password']['stringValue'] == password) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in successful!')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect password.')));
                              }
                            } catch (e) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          },
                          child: const Text('Forgot Password'),
                        ),
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
