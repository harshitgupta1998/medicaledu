import 'package:flutter/material.dart';
import 'about_page2.dart';

class AboutPage1 extends StatelessWidget {
  const AboutPage1({super.key});

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
            Text('Welcome!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor'),
            const SizedBox(height: 24),
            const Text('Phone Number'),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(border: OutlineInputBorder())),
            const Spacer(),
            ElevatedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutPage2())), child: const Text('Next')),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
