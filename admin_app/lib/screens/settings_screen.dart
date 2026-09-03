import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/app_theme.dart';
import '../services/admin_api.dart';
import '../main.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final AdminApi api;
  const SettingsScreen({super.key, required this.api});
  @override State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final storage = const FlutterSecureStorage();
  bool testing = false;

  Future<void> testConnection() async {
    setState(() => testing = true);
    try {
      await widget.api.getBookings();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion API opérationnelle.')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion impossible. Vérifiez le serveur.')));
    } finally { if (mounted) setState(() => testing = false); }
  }

  Future<void> logout() async {
    await storage.delete(key: 'admin_key');
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
          const CircleAvatar(radius: 28, backgroundColor: AppTheme.navy, child: Icon(Icons.admin_panel_settings_outlined, color: Colors.white)),
          const SizedBox(width: 14),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Administration Pure & Power', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            SizedBox(height: 4), Text('Espace sécurisé de gestion', style: TextStyle(color: Colors.blueGrey)),
          ])),
        ]))),
        const SizedBox(height: 12),
        Card(child: Column(children: [
          ListTile(leading: const Icon(Icons.dark_mode_outlined), title: const Text('Mode sombre'), subtitle: const Text('Adapter l’interface aux conditions de lumière'), trailing: ValueListenableBuilder<ThemeMode>(valueListenable: appThemeMode, builder: (_, mode, __) => Switch(value: mode == ThemeMode.dark, onChanged: (v) => appThemeMode.value = v ? ThemeMode.dark : ThemeMode.light))),
          const Divider(height: 1),
          ListTile(leading: const Icon(Icons.cloud_done_outlined, color: AppTheme.green), title: const Text('API Pure & Power'), subtitle: const Text('Netlify Functions + Supabase'), trailing: testing ? const SizedBox(width:22,height:22,child:CircularProgressIndicator(strokeWidth:2)) : OutlinedButton(onPressed: testConnection, child: const Text('Tester'))),
        ])),
        const SizedBox(height: 12),
        Card(child: ListTile(leading: const Icon(Icons.logout_rounded, color: Color(0xFFA33D3D)), title: const Text('Déconnexion', style: TextStyle(fontWeight: FontWeight.w800)), subtitle: const Text('Supprimer la clé administrateur de cet appareil'), onTap: logout)),
        const SizedBox(height: 18),
        const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Sécurité', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)), SizedBox(height: 8), Text('La clé administrateur est stockée de manière sécurisée sur l’appareil et n’est pas intégrée dans le code source.', style: TextStyle(color: Colors.blueGrey, height: 1.45))]))),
        const SizedBox(height: 22),
        const Center(child: Text('Pure & Power Admin • v1.0.0', style: TextStyle(color: Colors.blueGrey))),
      ]),
    );
  }
}
