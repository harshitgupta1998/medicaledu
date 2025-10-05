import 'package:flutter/material.dart';
import 'about_page1.dart';
import 'about_page3.dart';

class AboutPage2 extends StatelessWidget {
  const AboutPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // large circular placeholder
              Expanded(
                child: Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 40),

              // bottom nav
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back circular outline
                  Ink(
                    decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.white),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AboutPage1())),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),

                  // indicators
                  Row(
                    children: [
                      _dot(true),
                      const SizedBox(width: 6),
                      _dot(false),
                      const SizedBox(width: 6),
                      _dot(false),
                    ],
                  ),

                  // forward circular filled
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[700],
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutPage3())),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) => Container(
        width: active ? 10 : 8,
        height: active ? 10 : 8,
        decoration: BoxDecoration(color: active ? Colors.black54 : Colors.black26, shape: BoxShape.circle),
      );
}
