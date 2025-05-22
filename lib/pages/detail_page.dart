import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(data['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['desc'] ?? 'Tidak ada deskripsi',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Alamat: ${data['address'] ?? 'N/A'}"),
            const SizedBox(height: 5),
            Text("Jarak: ${data['distance']}"),
          ],
        ),
      ),
    );
  }
}
