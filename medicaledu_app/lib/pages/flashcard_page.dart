import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlashCardPage extends StatelessWidget {
  const FlashCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Disease'),
      ),
      body: SafeArea(
        child: FlipCard(
          key: cardKey,
          direction: FlipDirection.HORIZONTAL,
          front: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    cardKey.currentState?.toggleCard();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/medicaledu-ac337.firebasestorage.app/o/IMG_6025.jpeg?alt=media&token=71cc221b-0b06-427c-9ba7-244d5493588a&cb=',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 32,
                    color: Colors.black,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(Icons.flag, size: 32, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    iconSize: 32,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
          back: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'RPOC',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Retained products of conception (RPOC) refer to the persistence of placental and/or fetal tissue in the uterus following delivery, termination of pregnancy or a miscarriage.\n\nEpidemiology\nRPOC complicates ~2.5% (range 1-5%) of all routine vaginal deliveries.\n\nClinical presentation\nCommon symptoms include vaginal bleeding and abdominal or pelvic pain.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FlashCardDetailsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('View more details'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 32,
                    color: Colors.black,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(Icons.flag, size: 32, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    iconSize: 32,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Retained products of conception (RPOC) refer to the persistence of placental and/or fetal tissue in the uterus following delivery, termination of pregnancy or a miscarriage.\n\nEpidemiology\nRPOC complicates ~2.5% (range 1-5%) of all routine vaginal deliveries.\n\nClinical presentation\nCommon symptoms include vaginal bleeding and abdominal or pelvic pain.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FlashCardDetailsPage(),
                  ),
                );
              },
              child: const Text('View more details'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 32,
                  color: Colors.black,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(Icons.flag, size: 32, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward),
                  iconSize: 32,
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlashCardDetailsPage extends StatelessWidget {
  const FlashCardDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPOC'),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'General'),
                  Tab(text: 'Radiographic features'),
                  Tab(text: 'Images and cases'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTabContent('General information goes here.'),
                    _buildTabContent('Radiographic features information goes here.'),
                    _buildTabContent('Images and cases information goes here.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Add functionality for marking as revision
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.flag, size: 24),
                SizedBox(width: 8),
                Text('Mark for revision', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}