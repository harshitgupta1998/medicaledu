import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final queryUrl = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents:runQuery';
    final queryBody = jsonEncode({
      "structuredQuery": {
        "from": [{"collectionId": "users"}],
        "where": {
          "fieldFilter": {
            "field": {"fieldPath": "username"},
            "op": "EQUAL",
            "value": {"stringValue": username}
          }
        }
      }
    });
    setState(() => _loading = true);
    try {
      final queryRes = await http.post(Uri.parse(queryUrl), headers: {'Content-Type': 'application/json'}, body: queryBody);
      final queryList = jsonDecode(queryRes.body) as List;
      final userDoc = queryList.firstWhere((item) => item['document'] != null, orElse: () => null);
      if (userDoc == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found.')));
        setState(() => _loading = false);
        return;
      }
      final fields = userDoc['document']['fields'];
      if (fields['password'] != null && fields['password']['stringValue'] == password) {
        // Navigate to cards page
        Navigator.of(context).pushReplacementNamed('/cards');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect password.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _signIn,
                  child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
