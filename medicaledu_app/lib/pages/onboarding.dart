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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    _controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
                onPageChanged: (p) => setState(() => _index = p),
                children: [
                  _buildPage(
                    title: 'Welcome!',
                    body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                    imageSize: 260,
                  ),
                  _buildPage(
                    title: 'Discover',
                    body: 'Find the best content to help you learn and grow.',
                  ),
                  _buildPage(
                    title: 'Get Started',
                    body: 'Create your profile and join the community.',
                  ),
                ],
              ),
            ),

            // bottom nav
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back circular outline
                  IconButton(
                    onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                    icon: const Icon(Icons.arrow_back),
                    color: _index > 0 ? Colors.black87 : Colors.black26,
                    splashRadius: 22,
                  ),

                  // dots (clickable)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final active = i == _index;
                      return GestureDetector(
                        onTap: () => _goTo(i),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: active ? 10 : 8,
                          height: active ? 10 : 8,
                          decoration: BoxDecoration(color: active ? Colors.black87 : Colors.black26, shape: BoxShape.circle),
                        ),
                      );
                    }),
                  ),

                  // forward circular filled
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey[800],
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

  Widget _buildPage({required String title, required String body, double imageSize = 220}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
