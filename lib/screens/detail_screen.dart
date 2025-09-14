import 'package:flutter/material.dart';
import 'package:geny_businesses/models/business.dart';

class DetailScreen extends StatelessWidget {
  final Business business;
  const DetailScreen({required this.business, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(business.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              business.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 6),
                Text(business.location),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone_outlined),
                const SizedBox(width: 6),
                Text(business.contactNumber),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'This screen demonstrates how we pass normalized domain models to detail views.',
            ),
          ],
        ),
      ),
    );
  }
}
