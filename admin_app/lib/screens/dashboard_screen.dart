import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/admin_api.dart';
import '../theme/app_theme.dart';
import 'calendar_screen.dart';
import 'clients_screen.dart';
import 'contracts_screen.dart';
import 'payments_screen.dart';
import 'services_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final AdminApi api;
  const DashboardScreen({super.key, required this.api});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Booking>> future;
  @override void initState() { super.initState(); future = widget.api.getBookings(); }
  Future<void> refresh() async { setState(() => future = widget.api.getBookings()); await future; }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Tableau de bord', style: TextStyle(fontWeight: FontWeight.w900)),
      actions: [IconButton(tooltip: 'Actualiser', onPressed: refresh, icon: const Icon(Icons.refresh_rounded))],
    ),
    drawer: _Drawer(api: widget.api),
    body: FutureBuilder<List<Booking>>(
      future: future,
      builder: (context, state) {
        if (state.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (state.hasError) return _Error(onRetry: refresh);
        final bookings = state.data ?? [];
        final pending = bookings.where((x) => x.status == 'pending').length;
        final approved = bookings.where((x) => x.status == 'approved' || x.status == 'client_confirmed').length;
        final revenue = bookings.fold<double>(0, (a, x) => a + x.totalPrice);
        final clients = bookings.map((x) => x.email).where((x) => x.isNotEmpty).toSet().length;
        return RefreshIndicator(
          onRefresh: refresh,
          child: ListView(padding: const EdgeInsets.fromLTRB(18, 10, 18, 30), children: [
            _HeroHeader(pending: pending),
            const SizedBox(height: 18),
            _StatsGrid(bookings: bookings.length, pending: pending, clients: clients, revenue: revenue),
            const SizedBox(height: 20),
            _QuickActions(api: widget.api),
            const SizedBox(height: 24),
            Row(children: [
              const Expanded(child: Text('Demandes récentes', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))),
              Text('${bookings.length} total', style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 10),
            if (bookings.isEmpty) const _Empty() else ...bookings.take(6).map((b) => _BookingTile(booking: b, api: widget.api, onChanged: refresh)),
            if (approved > 0) ...[
              const SizedBox(height: 12),
              Card(child: ListTile(leading: const Icon(Icons.verified_rounded, color: AppTheme.green), title: Text('$approved demande(s) confirmée(s)', style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: const Text('Les prestations validées sont prêtes pour le suivi.'))),
            ],
          ]),
        );
      },
    ),
  );
}

class _HeroHeader extends StatelessWidget {
  final int pending;
  const _HeroHeader({required this.pending});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.navy, Color(0xFF1C4664)]), borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 20, offset: Offset(0, 8))]),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PURE & POWER', style: TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.w800)), const SizedBox(height: 7), const Text('Bonjour 👋', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(pending == 0 ? 'Tout est à jour.' : '$pending nouvelle(s) demande(s) à traiter.', style: const TextStyle(color: Colors.white70, height: 1.4))]),
      Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), shape: BoxShape.circle), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28)),
    ]),
  );
}

class _StatsGrid extends StatelessWidget {
  final int bookings, pending, clients; final double revenue;
  const _StatsGrid({required this.bookings, required this.pending, required this.clients, required this.revenue});
  @override Widget build(BuildContext context) => GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.28, children: [
    _Stat('Réservations', '$bookings', Icons.calendar_month_rounded),
    _Stat('À traiter', '$pending', Icons.pending_actions_rounded, accent: pending > 0),
    _Stat('Clients', '$clients', Icons.people_alt_outlined),
    _Stat('CA estimé', '${revenue.toStringAsFixed(0)} €', Icons.euro_rounded),
  ]);
}

class _Stat extends StatelessWidget {
  final String title, value; final IconData icon; final bool accent;
  const _Stat(this.title, this.value, this.icon, {this.accent = false});
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: accent ? const Color(0xFFFFF3DD) : const Color(0xFFEAF2EC), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: accent ? const Color(0xFF9A6A22) : AppTheme.green, size: 21)), const Spacer(), if (accent) const Icon(Icons.priority_high_rounded, size: 17, color: Color(0xFF9A6A22))]),
    Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.navy)),
    Text(title, style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
  ]));
}

class _QuickActions extends StatelessWidget {
  final AdminApi api; const _QuickActions({required this.api});
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Accès rapide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 10),
    SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
      _Action('Réservations', Icons.calendar_today_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReservationsScreen(api: api)))),
      _Action('Clients', Icons.people_alt_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientsScreen(api: api)))),
      _Action('Calendrier', Icons.event_available_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarScreen(api: api)))),
      _Action('Paiements', Icons.payments_rounded, () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentsScreen(api: api)))),
    ])),
  ]);
}

class _Action extends StatelessWidget { final String label; final IconData icon; final VoidCallback onTap; const _Action(this.label, this.icon, this.onTap); @override Widget build(BuildContext c) => Padding(padding: const EdgeInsets.only(right: 10), child: OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 18), label: Text(label), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))); }

class _BookingTile extends StatelessWidget {
  final Booking booking; final VoidCallback onChanged; final AdminApi api;
  const _BookingTile({required this.booking, required this.onChanged, required this.api});
  @override Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 9), child: InkWell(borderRadius: BorderRadius.circular(20), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailScreen(api: api, booking: booking, onChanged: onChanged))), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
    CircleAvatar(radius: 23, backgroundColor: const Color(0xFFEAF2EC), child: Text(booking.clientName.isEmpty ? '?' : booking.clientName[0].toUpperCase(), style: const TextStyle(color: AppTheme.green, fontWeight: FontWeight.w900))),
    const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(booking.clientName.isEmpty ? 'Client' : booking.clientName, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(booking.service, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blueGrey, fontSize: 13)), const SizedBox(height: 3), Text('${booking.date} • ${booking.time}', style: const TextStyle(fontSize: 12, color: Colors.blueGrey))])),
    const SizedBox(width: 6), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [_StatusWidget(status: ''), SizedBox(height: 7), Text('${booking.totalPrice.toStringAsFixed(0)} €', style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.navy))]),
  ]))));
}

class _StatusWidget extends StatelessWidget { final String status; const _StatusWidget({required this.status}); @override Widget build(BuildContext c) { final s = status; final pending = s == 'pending' || s.isEmpty; return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: pending ? const Color(0xFFFFF6E8) : const Color(0xFFEAF2EC), borderRadius: BorderRadius.circular(20)), child: Text(pending ? 'À traiter' : s, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: pending ? const Color(0xFF9A6A22) : AppTheme.green))); } }

class _Empty extends StatelessWidget { const _Empty(); @override Widget build(BuildContext c) => Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(children: [const Icon(Icons.inbox_rounded, size: 44, color: Colors.blueGrey), const SizedBox(height: 10), const Text('Aucune demande', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 5), const Text('Les nouvelles réservations apparaîtront ici.', textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey))]))); }
class _Error extends StatelessWidget { final Future<void> Function() onRetry; const _Error({required this.onRetry}); @override Widget build(BuildContext c) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off_rounded, size: 50), const SizedBox(height: 12), const Text('Impossible de charger les données.', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 12), FilledButton(onPressed: onRetry, child: const Text('Réessayer'))]))); }

class _Drawer extends StatelessWidget {
  final AdminApi api; const _Drawer({required this.api});
  void go(BuildContext c, Widget page) { Navigator.pop(c); Navigator.push(c, MaterialPageRoute(builder: (_) => page)); }
  @override Widget build(BuildContext c) => Drawer(child: SafeArea(child: ListView(padding: EdgeInsets.zero, children: [
    Container(padding: const EdgeInsets.fromLTRB(20, 24, 20, 20), decoration: const BoxDecoration(color: AppTheme.navy), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 25, backgroundColor: AppTheme.green, child: Text('P&P', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))), SizedBox(height: 14), Text('PURE & POWER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5)), SizedBox(height: 3), Text('Administration mobile', style: TextStyle(color: Colors.white70))])),
    _Nav(icon: Icons.dashboard_rounded, title: 'Dashboard', selected: true, onTap: () => Navigator.pop(c)),
    _Nav(icon: Icons.calendar_month_rounded, title: 'Réservations', onTap: () => go(c, ReservationsScreen(api: api))),
    _Nav(icon: Icons.people_alt_outlined, title: 'Clients', onTap: () => go(c, ClientsScreen(api: api))),
    _Nav(icon: Icons.event_available_rounded, title: 'Calendrier', onTap: () => go(c, CalendarScreen(api: api))),
    _Nav(icon: Icons.description_outlined, title: 'Contrats', onTap: () => go(c, ContractsScreen(api: api))),
    _Nav(icon: Icons.payments_outlined, title: 'Paiements', onTap: () => go(c, PaymentsScreen(api: api))),
    _Nav(icon: Icons.cleaning_services_outlined, title: 'Services & tarifs', onTap: () => go(c, const ServicesScreen())),
    const Divider(indent: 16, endIndent: 16),
    _Nav(icon: Icons.settings_outlined, title: 'Paramètres', onTap: () => go(c, SettingsScreen(api: api))),
  ])));
}
class _Nav extends StatelessWidget { final IconData icon; final String title; final bool selected; final VoidCallback onTap; const _Nav({required this.icon, required this.title, required this.onTap, this.selected = false}); @override Widget build(BuildContext c) => ListTile(leading: Icon(icon, color: selected ? AppTheme.green : Colors.blueGrey), title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? AppTheme.green : null)), selected: selected, selectedTileColor: const Color(0xFFEAF2EC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), contentPadding: const EdgeInsets.symmetric(horizontal: 18), onTap: onTap); }

class ReservationsScreen extends StatefulWidget { final AdminApi api; const ReservationsScreen({super.key, required this.api}); @override State<ReservationsScreen> createState() => _ReservationsScreenState(); }
class _ReservationsScreenState extends State<ReservationsScreen> {
  late Future<List<Booking>> future; String filter = 'Tous'; String query = '';
  @override void initState() { super.initState(); future = widget.api.getBookings(); }
  Future<void> reload() async { setState(() => future = widget.api.getBookings()); await future; }
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Réservations', style: TextStyle(fontWeight: FontWeight.w900)), actions: [IconButton(onPressed: reload, icon: const Icon(Icons.refresh_rounded))]), body: FutureBuilder<List<Booking>>(future: future, builder: (c, s) {
    if (s.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
    if (s.hasError) return _Error(onRetry: reload);
    final all = s.data ?? [];
    final filtered = all.where((b) { final matchesFilter = filter == 'Tous' || (filter == 'À traiter' && b.status == 'pending') || (filter == 'Validées' && (b.status == 'approved' || b.status == 'client_confirmed')) || (filter == 'Refusées' && b.status == 'rejected' || b.status == 'client_refused'); final text = '${b.clientName} ${b.email} ${b.service}'.toLowerCase(); return matchesFilter && text.contains(query.toLowerCase()); }).toList();
    return ListView(padding: const EdgeInsets.all(16), children: [TextField(onChanged: (v) => setState(() => query = v), decoration: InputDecoration(hintText: 'Rechercher client, email, service…', prefixIcon: const Icon(Icons.search_rounded), suffixIcon: query.isEmpty ? null : IconButton(onPressed: () => setState(() => query = ''), icon: const Icon(Icons.clear_rounded)))), const SizedBox(height: 12), SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['Tous', 'À traiter', 'Validées', 'Refusées'].map((x) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(x), selected: filter == x, onSelected: (_) => setState(() => filter = x)))).toList())), const SizedBox(height: 14), if (filtered.isEmpty) const _Empty() else ...filtered.map((b) => _BookingTile(booking: b, onChanged: reload, api: widget.api))]);
  });
}

class BookingDetailScreen extends StatelessWidget { final AdminApi api; final Booking booking; final VoidCallback onChanged; const BookingDetailScreen({super.key, required this.api, required this.booking, required this.onChanged}); Future<void> decide(BuildContext c, String action) async { try { final r = await api.decide(booking.id, action); if (c.mounted) { ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(action == 'approve' ? (r['emailSent'] == true ? 'Demande validée et email envoyé.' : 'Demande validée.') : 'Demande refusée.'))); onChanged(); Navigator.pop(c); } } catch (e) { if (c.mounted) ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(e.toString()))); } }
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Détail de la demande')), body: ListView(padding: const EdgeInsets.all(18), children: [Text(booking.clientName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.navy)), const SizedBox(height: 5), _StatusWidget(status: booking.status), const SizedBox(height: 22), _Info('Prestation', booking.service), _Info('Date & heure', '${booking.date} • ${booking.time}'), _Info('Montant', '${booking.totalPrice.toStringAsFixed(2)} €'), _Info('Téléphone', booking.phone), _Info('Email', booking.email), _Info('Adresse', booking.address), if (booking.needs.isNotEmpty) _Info('Informations', booking.needs), if (booking.status == 'pending') ...[const SizedBox(height: 18), Row(children: [Expanded(child: FilledButton.icon(onPressed: () => decide(c, 'approve'), icon: const Icon(Icons.check_rounded), label: const Text('Approuver'))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: () => decide(c, 'reject'), icon: const Icon(Icons.close_rounded), label: const Text('Refuser')))])]));
}
class _Info extends StatelessWidget { final String t, v; const _Info(this.t, this.v); @override Widget build(BuildContext c) => Card(margin: const EdgeInsets.only(bottom: 10), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.toUpperCase(), style: const TextStyle(fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w800, color: AppTheme.green)), const SizedBox(height: 6), Text(v, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]))); }
