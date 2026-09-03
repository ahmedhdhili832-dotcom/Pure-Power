import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/admin_api.dart';

class SettingsScreen extends StatelessWidget {
  final AdminApi api;
  const SettingsScreen({super.key, required this.api});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.w800))),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
            const CircleAvatar(radius: 28, backgroundColor: AppTheme.navy, child: Icon(Icons.admin_panel_settings_outlined, color: Colors.white)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Administration Pure & Power', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
              SizedBox(height: 4), Text('Connexion sécurisée via la clé administrateur', style: TextStyle(color: Colors.blueGrey)),
            ])),
          ]))),
          const SizedBox(height: 12),
          Card(child: Column(children: [
            const ListTile(leading: Icon(Icons.cloud_done_outlined, color: AppTheme.green), title: Text('API connectée'), subtitle: Text('Netlify Functions + Supabase')),
            const Divider(height: 1),
            ListTile(leading: const Icon(Icons.refresh), title: const Text('Tester la connexion'), onTap: () async {
              try {
                await api.getBookings();
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion API opérationnelle.')));
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }),
          ])),
          const SizedBox(height: 12),
          const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sécurité', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            SizedBox(height: 8),
            Text('La clé administrateur est utilisée uniquement pour communiquer avec l’API. Elle ne doit jamais être intégrée directement dans le code de l’application.', style: TextStyle(color: Colors.blueGrey, height: 1.45)),
          ]))),
        ]),
      );
}
