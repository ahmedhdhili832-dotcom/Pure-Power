import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/admin_api.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatelessWidget {
  final AdminApi api;
  const CalendarScreen({super.key, required this.api});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar: AppBar(title: const Text('Calendrier',style:TextStyle(fontWeight:FontWeight.w800))),
    body: FutureBuilder<List<Booking>>(future:api.getBookings(),builder:(context,s){
      if(s.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
      if(s.hasError)return Center(child:Text('Erreur : ${s.error}'));
      final list=[...(s.data??[])];
      list.sort((a,b)=>'${a.date}${a.time}'.compareTo('${b.date}${b.time}'));
      if(list.isEmpty)return const Center(child:Text('Aucune prestation planifiée'));
      return ListView.builder(padding:const EdgeInsets.all(16),itemCount:list.length,itemBuilder:(c,i){final b=list[i];return Card(child:ListTile(leading:Container(width:50,height:50,alignment:Alignment.center,decoration:BoxDecoration(color:const Color(0xFFEAF2EC),borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.event,color:AppTheme.green)),title:Text(b.date,style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text('${b.time} • ${b.clientName}\n${b.service}'),isThreeLine:true,trailing:Text('${b.totalPrice.toStringAsFixed(0)} €',style:const TextStyle(fontWeight:FontWeight.w800))));});
    }),
  );
}
