import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/admin_api.dart';
import '../theme/app_theme.dart';

class ClientsScreen extends StatelessWidget {
  final AdminApi api;
  const ClientsScreen({super.key, required this.api});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Clients', style: TextStyle(fontWeight: FontWeight.w800))),
    body: FutureBuilder<List<Booking>>(
      future: api.getBookings(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snap.hasError) return Center(child: Text('Erreur : ${snap.error}'));
        final bookings = snap.data ?? [];
        final map = <String, List<Booking>>{};
        for (final b in bookings) { map.putIfAbsent(b.email, () => []).add(b); }
        if (map.isEmpty) return const Center(child: Text('Aucun client'));
        return ListView(padding: const EdgeInsets.all(16), children: map.entries.map((e) {
          final list=e.value, b=list.first;
          final total=list.fold<double>(0,(x,y)=>x+y.totalPrice);
          return Card(margin: const EdgeInsets.only(bottom:10), child: ListTile(
            leading: CircleAvatar(backgroundColor: const Color(0xFFEAF2EC), child: Text(b.clientName.isEmpty?'?':b.clientName[0].toUpperCase(),style:const TextStyle(color:AppTheme.green,fontWeight:FontWeight.w800))),
            title: Text(b.clientName.isEmpty?'Client':b.clientName,style:const TextStyle(fontWeight:FontWeight.w800)),
            subtitle: Text('${b.email}\n${b.phone} • ${list.length} prestation(s) • ${total.toStringAsFixed(0)} €'),
            isThreeLine: true,
          ));
        }).toList());
      },
    ),
  );
}
