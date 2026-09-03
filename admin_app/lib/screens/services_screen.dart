import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const services = [
    ('Ménage courant', 'Aide à domicile', '20 €/h', Icons.home_outlined),
    ('Ménage approfondi', 'Aide à domicile', '25 €/h', Icons.cleaning_services_outlined),
    ('Nettoyage bureaux', 'Nettoyage professionnel', '25 €/h', Icons.business_outlined),
    ('Vitres', 'Nettoyage professionnel', '5 €/unité', Icons.window_outlined),
    ('Repassage', 'Aide à domicile', '20 €/h', Icons.iron_outlined),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Services & tarifs', style: TextStyle(fontWeight: FontWeight.w800))),
        body: ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: services.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final s = services[i];
            return Card(child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(backgroundColor: const Color(0xFFEAF2EC), child: Icon(s.$4, color: AppTheme.green)),
              title: Text(s.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(s.$2),
              trailing: Text(s.$3, style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.green)),
            ));
          },
        ),
      );
}
