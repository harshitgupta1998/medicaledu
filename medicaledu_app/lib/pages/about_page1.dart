import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'about_page2.dart';

class AboutPage1 extends StatefulWidget {
  const AboutPage1({super.key});

  @override
  State<AboutPage1> createState() => _AboutPage1State();
}

class _AboutPage1State extends State<AboutPage1> {
  final TextEditingController _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _maskPhone(String digits) {
    if (digits.length <= 4) return digits;
    final last4 = digits.substring(digits.length - 4);
    return '****$last4';
  }

  Future<void> _savePhone() async {
    final raw = _phoneController.text.trim();
    var digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter phone number')));
      return;
    }
    // Normalise: if 10 digits assume +91 (you can adjust for other countries)
    if (digits.length == 10) digits = '91$digits';
    final e164 = '+$digits';
    final masked = _maskPhone(digits);

    setState(() => _loading = true);
    final scaffold = ScaffoldMessenger.of(context);
    try {
      final url = Uri.parse('https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/phone-numbers');
      final body = jsonEncode({
        'fields': {
          'phone': {'stringValue': e164},
          'phoneMasked': {'stringValue': masked},
          'createdAt': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
        }
      });
      final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);
      if (!mounted) return;
      if (res.statusCode >= 200 && res.statusCode < 300) {
        String docName = '';
        try {
          final Map<String, dynamic> parsed = jsonDecode(res.body);
          docName = parsed['name'] ?? '';
        } catch (_) {}
        scaffold.showSnackBar(SnackBar(content: Text('Phone saved ${docName.isNotEmpty ? docName : ''}')));
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutPage2()));
      } else {
        scaffold.showSnackBar(SnackBar(content: Text('Save failed: ${res.statusCode} ${res.body}')));
      }
    } catch (e) {
      if (mounted) scaffold.showSnackBar(SnackBar(content: Text('Save error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
        actions: [TextButton(onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AboutPage2())), child: const Text('Skip'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: ClipOval(
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/medicaledu-ac337.firebasestorage.app/o/IMG_6426.jpeg?alt=media&token=ac162a89-cea3-4e65-9513-8c6199d9c924&cb=${DateTime.now().millisecondsSinceEpoch}',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Welcome!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Learn, practice, and excel with curated medical content and exam-focused study plans.'),
            const SizedBox(height: 24),
            const Text('Phone Number'),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)],
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '+911234567890 or 9123456789'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _savePhone,
                child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Next'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
