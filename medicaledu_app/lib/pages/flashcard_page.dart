import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Flashcard {
  final String cardId;
  final String deckId;
  final String imageUrl;
  final String text;
  final String general;
  final String radiographicFeatures;
  final String imagesAndCases;
  final bool flagged;

  Flashcard({
    required this.cardId,
    required this.deckId,
    required this.imageUrl,
    required this.text,
    required this.general,
    required this.radiographicFeatures,
    required this.imagesAndCases,
    required this.flagged,
  });

  factory Flashcard.fromFirestore(Map<String, dynamic> fields) {
    return Flashcard(
      cardId: fields['card_id']?['stringValue'] ?? '',
      deckId: fields['deck_id']?['stringValue'] ?? '',
      imageUrl: fields['image_url']?['stringValue'] ?? '',
      text: fields['text']?['stringValue'] ?? '',
      general: fields['general']?['stringValue'] ?? '',
      radiographicFeatures: fields['radiographic_features']?['stringValue'] ?? '',
      imagesAndCases: fields['images_and_cases']?['stringValue'] ?? '',
      flagged: fields['flagged']?['booleanValue'] ?? false,
    );
  }
}

Future<List<Flashcard>> fetchFlashcards() async {
  final url = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/flashcards';
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    final docs = data['documents'] as List<dynamic>;
    return docs.map((doc) => Flashcard.fromFirestore(doc['fields'])).toList();
  } else {
    throw Exception('Failed to load flashcards');
  }
}

Future<Flashcard?> fetchFlashcardById(String cardId) async {
  //final url = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/flashcards/2f$cardId';
  final url ='https://console.firebase.google.com/u/0/project/medicaledu-ac337/firestore/databases/users-test/data/~2Fflashcards~2F$cardId';'
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    if (data['fields'] != null) {
      return Flashcard.fromFirestore(data['fields']);
    }
    return null;
  } else {
    return null;
  }
}

class FlashCardPage extends StatelessWidget {
  final String flashcardId;
  const FlashCardPage({super.key, required this.flashcardId});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcard Details')),
      body: FutureBuilder<Flashcard?>(
        future: fetchFlashcardById(flashcardId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Flashcard not found.'));
          }
          final flashcard = snapshot.data!;
          return FlipCard(
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
                        flashcard.imageUrl,
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
                        children: [
                          Text(
                            flashcard.text,
                            style: const TextStyle(fontSize: 16),
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
                        builder: (context) => FlashCardDetailsPage(flashcard: flashcard),
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
          );
        },
      ),
    );
  }
}

class FlashCardDetailsPage extends StatelessWidget {
  final Flashcard flashcard;
  const FlashCardDetailsPage({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flashcard.cardId),
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
                    _buildTabContent(flashcard.general),
                    _buildTabContent(flashcard.radiographicFeatures),
                    _buildTabContent(flashcard.imagesAndCases),
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