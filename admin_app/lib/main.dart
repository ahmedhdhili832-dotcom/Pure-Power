import 'package:flutter/material.dart';

void main() => runApp(const PurePowerAdminApp());

class PurePowerAdminApp extends StatelessWidget {
  const PurePowerAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pure & Power Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6B4F)),
        scaffoldBackgroundColor: const Color(0xFFF7F9F7),
        fontFamily: 'Roboto',
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <_StatData>[
      _StatData('Réservations', '0', Icons.calendar_month_outlined),
      _StatData('En attente', '0', Icons.pending_actions_outlined),
      _StatData('Clients', '0', Icons.people_outline),
      _StatData('Revenus estimés', '0 €', Icons.euro_outlined),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pure & Power'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          const Padding(
            padding: EdgeInsets.only(right: 14),
            child: CircleAvatar(child: Text('A')),
          ),
        ],
      ),
      drawer: const _AdminDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Vue d’ensemble de l’activité Pure & Power', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 22),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.35),
              itemCount: cards.length,
              itemBuilder: (_, i) => _StatCard(data: cards[i]),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Réservations récentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text('Les demandes envoyées par les clients apparaîtront ici.', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 18),
                  FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.list_alt), label: const Text('Gérer les réservations')),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Accès rapide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _QuickAction(icon: Icons.people_outline, title: 'Clients', onTap: () {}),
            _QuickAction(icon: Icons.description_outlined, title: 'Contrats', onTap: () {}),
            _QuickAction(icon: Icons.payments_outlined, title: 'Paiements', onTap: () {}),
            _QuickAction(icon: Icons.cleaning_services_outlined, title: 'Services & tarifs', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();
  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(padding: EdgeInsets.zero, children: [
      DrawerHeader(decoration: const BoxDecoration(color: Color(0xFF2F6B4F)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [CircleAvatar(radius: 25, child: Text('P&P')), SizedBox(height: 12), Text('PURE & POWER', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)), Text('Administration', style: TextStyle(color: Colors.white70))])),
      _DrawerItem(Icons.dashboard_outlined, 'Dashboard'),
      _DrawerItem(Icons.calendar_month_outlined, 'Réservations'),
      _DrawerItem(Icons.people_outline, 'Clients'),
      _DrawerItem(Icons.description_outlined, 'Contrats'),
      _DrawerItem(Icons.payments_outlined, 'Paiements'),
      _DrawerItem(Icons.cleaning_services_outlined, 'Services'),
      _DrawerItem(Icons.euro_outlined, 'Tarifs'),
      _DrawerItem(Icons.settings_outlined, 'Paramètres'),
    ]),
  );
}

class _DrawerItem extends StatelessWidget {
  final IconData icon; final String title;
  const _DrawerItem(this.icon, this.title);
  @override
  Widget build(BuildContext context) => ListTile(leading: Icon(icon), title: Text(title), onTap: () => Navigator.pop(context));
}

class _StatData { final String title, value; final IconData icon; const _StatData(this.title, this.value, this.icon); }
class _StatCard extends StatelessWidget {
  final _StatData data; const _StatCard({required this.data});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(data.icon, color: const Color(0xFF2F6B4F)), Text(data.value, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)), Text(data.title, style: TextStyle(color: Colors.grey.shade700))])));
}

class _QuickAction extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(leading: Icon(icon, color: const Color(0xFF2F6B4F)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), trailing: const Icon(Icons.chevron_right), onTap: onTap));
}
