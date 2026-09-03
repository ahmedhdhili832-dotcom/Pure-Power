import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/admin_api.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final keyController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool loading = true, obscure = true;
  String? error;

  @override void initState() { super.initState(); _restore(); }
  Future<void> _restore() async {
    final key = await storage.read(key: 'admin_key');
    if (key != null && key.isNotEmpty && mounted) _open(key);
    if (mounted) setState(() => loading = false);
  }
  Future<void> _open(String key) async {
    try { await AdminApi(key).getBookings(); await storage.write(key: 'admin_key', value: key); if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen(api: AdminApi(key)))); }
    catch (e) { if (mounted) setState(() { error = 'Clé administrateur invalide ou serveur indisponible.'; }); }
  }
  @override Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(28), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(width: 76, height: 76, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFF2F6B4F), borderRadius: BorderRadius.circular(22)), child: const Text('P&P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21))),
      const SizedBox(height: 24), const Text('PURE & POWER', style: TextStyle(fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w800, color: Color(0xFF2F6B4F))),
      const SizedBox(height: 8), const Text('Administration', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF102A43))),
      const SizedBox(height: 8), const Text('Connectez-vous pour gérer les demandes et les contrats.', style: TextStyle(color: Colors.blueGrey, height: 1.5)),
      const SizedBox(height: 30), TextField(controller: keyController, obscureText: obscure, decoration: InputDecoration(labelText: 'Clé administrateur', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
      if (error != null) ...[const SizedBox(height: 12), Text(error!, style: const TextStyle(color: Color(0xFFA33D3D), fontWeight: FontWeight.w600))],
      const SizedBox(height: 20), FilledButton(onPressed: () { final k = keyController.text.trim(); if (k.isNotEmpty) _open(k); }, style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: const Color(0xFF2F6B4F)), child: const Text('Accéder à l’administration')),
    ])))));
  }
  @override void dispose() { keyController.dispose(); super.dispose(); }
}
