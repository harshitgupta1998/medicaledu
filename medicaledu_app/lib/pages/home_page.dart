import 'package:flutter/material.dart';
import 'my_decks_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final DateTime createdAt;

  const HomePage({super.key, required this.userName, required this.createdAt});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const _sectionHeight = 120.0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  int get _daysSinceCreation {
    final now = DateTime.now();
    return now.difference(widget.createdAt).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = widget.userName;
    Widget body;
    if (_selectedIndex == 0) {
      body = SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hey! $name', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text('${_daysSinceCreation.toString().padLeft(2, '0')} days', style: theme.textTheme.titleMedium),
                ],
              ),
            ),

            // Sections - placeholders matching the mock (empty containers for now)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  SizedBox(
                    height: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: Colors.grey.shade200,
                      child: const Padding(padding: EdgeInsets.all(12), child: Text('Free experience')),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Text('Featured deck', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(3, (i) => Padding(
                      padding: const EdgeInsets.only(right:12.0),
                      child: Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))),
                    )),
                  ),

                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.grey.shade200,
                    child: SizedBox(
                      height: 88,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                          const SizedBox(width: 12),
                          const Text('Subscribe to see all cards'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                  // Empty container placeholders for future content
                  Container(height: _sectionHeight, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12))),
                  const SizedBox(height: 12),
                  Container(height: _sectionHeight, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12))),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (_selectedIndex == 1) {
      body = const MyDecksPage();
    } else {
      body = const ProfilePage();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'My Decks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
