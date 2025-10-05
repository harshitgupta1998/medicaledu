import 'package:flutter/material.dart';
import 'create_account_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  void _goTo(int i) {
    _controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  ),

                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.black87,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (_index < 2) {
                          _goTo(_index + 1);
                        } else {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const CreateAccountPage()));
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
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
}
