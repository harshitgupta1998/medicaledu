import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profile = UserProfile.instance;

  Future<void> _addExamDialog() async {
    final nameController = TextEditingController();
    DateTime? picked;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add exam'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Exam name')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final res = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: DateTime(now.year + 10));
                if (res != null) picked = res;
              },
              child: const Text('Pick date'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty && picked != null) {
                profile.addExam(nameController.text.trim(), picked!);
                setState(() {});
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profile.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Email: ${profile.email}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Exams', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: profile.exams.length,
                itemBuilder: (ctx, i) {
                  final e = profile.exams[i];
                  return ListTile(
                    leading: const Icon(Icons.school),
                    title: Text(e.name),
                    subtitle: Text('${e.date.month}/${e.date.day}/${e.date.year}'),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addExamDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add exam'),
            ),
          ],
        ),
      ),
    );
  }
}

