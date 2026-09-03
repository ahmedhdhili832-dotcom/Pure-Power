import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/admin_api.dart';
import '../theme/app_theme.dart';

class PaymentsScreen extends StatelessWidget {
  final AdminApi api;
  const PaymentsScreen({super.key, required this.api});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Paiements',style:TextStyle(fontWeight:FontWeight.w800))),
    body:FutureBuilder<List<Booking>>(future:api.getBookings(),builder:(context,s){
      if(s.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
      if(s.hasError)return Center(child:Text('Erreur : ${s.error}'));
      final list=s.data??[]; final total=list.fold<double>(0,(a,b)=>a+b.totalPrice);
      return ListView(padding:const EdgeInsets.all(16),children:[
        Card(child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('CA estimé',style:TextStyle(color:Colors.blueGrey)),const SizedBox(height:5),Text('${total.toStringAsFixed(2)} €',style:const TextStyle(fontSize:30,fontWeight:FontWeight.w900,color:AppTheme.navy))]))),
        const SizedBox(height:18),
        ...list.map((b)=>Card(child:ListTile(leading:const Icon(Icons.euro_outlined,color:AppTheme.green),title:Text(b.clientName,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text('${b.service} • ${b.date}'),trailing:Text('${b.totalPrice.toStringAsFixed(2)} €',style:const TextStyle(fontWeight:FontWeight.w800))))
      ]);
    }),
  );
}
