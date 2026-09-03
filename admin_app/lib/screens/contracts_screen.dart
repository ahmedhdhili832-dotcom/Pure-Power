import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/admin_api.dart';
import '../theme/app_theme.dart';

class ContractsScreen extends StatelessWidget {
  final AdminApi api;
  const ContractsScreen({super.key, required this.api});
  String label(String s) => {'draft':'Brouillon','sent':'Envoyé','client_confirmed':'Confirmé','client_refused':'Refusé'}[s] ?? s;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Contrats',style: TextStyle(fontWeight: FontWeight.w800))),
    body: FutureBuilder<List<Booking>>(future: api.getBookings(),builder:(context,s){
      if(s.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
      if(s.hasError)return Center(child:Text('Erreur : ${s.error}'));
      final list=(s.data??[]).where((b)=>b.contractStatus.isNotEmpty && b.contractStatus!='draft').toList();
      if(list.isEmpty)return const Center(child:Text('Aucun contrat envoyé'));
      return ListView(padding:const EdgeInsets.all(16),children:list.map((b)=>Card(child:ListTile(
        leading:const Icon(Icons.description_outlined,color:AppTheme.green),
        title:Text(b.clientName,style:const TextStyle(fontWeight:FontWeight.w800)),
        subtitle:Text('${b.service}\n${b.date} • ${label(b.contractStatus)}'),isThreeLine:true,
        trailing:Text('${b.totalPrice.toStringAsFixed(0)} €',style:const TextStyle(fontWeight:FontWeight.w800)),
      ))).toList());
    }),
  );
}
