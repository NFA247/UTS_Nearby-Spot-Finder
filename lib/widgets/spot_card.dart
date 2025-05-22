import 'package:flutter/material.dart';

class SpotCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String distance;
  final VoidCallback onTap;

  const SpotCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(distance),
        onTap: onTap,
      ),
    );
  }
}
