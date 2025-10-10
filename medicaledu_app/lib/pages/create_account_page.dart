import 'package:flutter/material.dart';
import 'home_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _dob;
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _usernameController.text.trim();
      // After signup, navigate to HomePage and clear the previous stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomePage(userName: name.isEmpty ? 'User' : name, createdAt: DateTime.now().subtract(const Duration(days: 1))),
        ),
        (route) => false,
      );
    }
  }

  String? _validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Confirm password';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter password';
    if (v.length < 8) return 'Password must be at least 8 characters';
    final hasUpper = v.contains(RegExp(r'[A-Z]'));
    final hasLower = v.contains(RegExp(r'[a-z]'));
    final hasDigit = v.contains(RegExp(r'\d'));
    final hasSpecial = v.contains(RegExp(r'[!@#\$&*~%^()_+\-=[\]{};:\\|,.<>\/?]'));
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
                Text('Create an account', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Enter your account details below or '),
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

                      const SizedBox(height: 16),
                      const Text('Verify Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: _validateConfirmPassword,
                      ),

                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Sign In'),
                      ),

                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {},
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
