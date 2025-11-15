import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'create_account_page.dart';
import 'profile_info_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _pinControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _pinFocus = List.generate(4, (_) => FocusNode());

  String? _maskedPhone;

  String _maskPhone(String digits) {
    if (digits.length <= 4) return digits;
    final last4 = digits.substring(digits.length - 4);
    return '****$last4';
  }

  void _goTo(int i) {
    _controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocus) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  _buildPage(
                    title: 'Welcome',
                    body: 'Discover medical education content tailored for you.',
                  ),
                  _buildPage(
                    title: 'Track Progress',
                    body: 'Watch your learning progress with simple milestones.',
                  ),
                  _buildPage(
                    title: 'Get Certified',
                    body: 'Complete courses and earn recognition for your skills.',
                  ),
                  _buildOtpPage(),
                  _buildVerificationPage(), // OTP verification page commented out
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                    icon: const Icon(Icons.arrow_back),
                  ),

                  // show dots only on the first three onboarding pages
                  if (_index <= 2)
                    Row(
                      children: List.generate(3, (i) {
                        final active = i == _index;
                        return GestureDetector(
                          onTap: () => _goTo(i),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 12 : 8,
                            height: active ? 12 : 8,
                            decoration: BoxDecoration(
                              color: active ? Colors.black54 : Colors.black26,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    )
                  else
                    const SizedBox(width: 48),

                  // show next circle only on the first three info pages
                  if (_index <= 2)
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.black87,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          if (_index < 4) {
                            _goTo(_index + 1);
                          } else {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfileInfoPage()));
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String body}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 260, height: 260, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                    const SizedBox(height: 24),
                    Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(body, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54))),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildOtpPage() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Welcome!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Learn, practice, and excel with curated medical content and exam-focused study plans.', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 24),
                  const Text('Phone Number'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF49505A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final phone = _phoneController.text.trim();
                    var digits = phone.replaceAll(RegExp(r'\D'), '');
                    if (digits.length > 10) digits = digits.substring(0, 10);
                    if (digits.isEmpty || digits.length < 7) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid phone number')));
                      return;
                    }
                    setState(() {
                      _maskedPhone = _maskPhone(digits);
                    });

                    // normalize and push to Firestore named DB
                    var digitsNorm = digits;
                    if (digitsNorm.length == 10) digitsNorm = '91$digitsNorm';
                    final e164 = '+$digitsNorm';
                    final masked = _maskPhone(digitsNorm);
                    final url = Uri.parse('https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/phone-numbers');
                    final body = jsonEncode({
                      'fields': {
                        'phone': {'stringValue': e164},
                        'phoneMasked': {'stringValue': masked},
                        'createdAt': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
                      }
                    });
                    try {
                      print('[Onboarding] POST $url');
                      print('[Onboarding] body: $body');
                      final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);
                      print('[Onboarding] response: ${res.statusCode} ${res.body}');
                      if (res.statusCode >= 200 && res.statusCode < 300) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone saved')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: ${res.statusCode}')));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save error: $e')));
                    }

                    _goTo(4);
                  },
                  child: const Text('Get OTP'),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildVerificationPage() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Verification', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('Enter the 4-digit PIN code sent to your phone ${_maskedPhone ?? '****2469'}.', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: SizedBox(
                            width: 40,
                            child: TextField(
                              controller: _pinControllers[i],
                              focusNode: _pinFocus[i],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: const InputDecoration(counterText: ''),
                              onChanged: (v) {
                                if (v.isNotEmpty && i < 3) {
                                  _pinFocus[i + 1].requestFocus();
                                }
                                if (v.isEmpty && i > 0) {
                                  _pinFocus[i - 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF49505A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // validate PIN (basic)
                    final pin = _pinControllers.map((c) => c.text).join();
                    if (pin.length == 4) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfileInfoPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter the 4-digit code')));
                    }
                  },
                  child: const Text('Verify'),
                ),
              ),
            ),
            TextButton(onPressed: () => _goTo(3), child: const Text('Request new code')),
          ],
        ),
      );
}
