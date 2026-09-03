import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';

class AdminApi {
  static const baseUrl = 'https://pure-powe.netlify.app/.netlify/functions';
  final String adminKey;
  const AdminApi(this.adminKey);

  Future<List<Booking>> getBookings() async {
    final r = await http.get(Uri.parse('$baseUrl/admin-bookings'), headers: _headers());
    final body = _decode(r);
    if (r.statusCode != 200) throw ApiException(body['error']?.toString() ?? 'Erreur de chargement');
    return ((body['bookings'] as List?) ?? []).map((e) => Booking.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<Map<String, dynamic>> decide(String id, String action) async {
    final r = await http.post(Uri.parse('$baseUrl/admin-booking'), headers: {..._headers(), 'content-type': 'application/json'}, body: jsonEncode({'id': id, 'action': action}));
    final body = _decode(r);
    if (r.statusCode < 200 || r.statusCode >= 300) throw ApiException(body['error']?.toString() ?? 'Action impossible');
    return body;
  }

  Map<String, String> _headers() => {'Authorization': 'Bearer $adminKey', 'Accept': 'application/json'};
  Map<String, dynamic> _decode(http.Response r) { try { final v = jsonDecode(r.body); return Map<String, dynamic>.from(v); } catch (_) { return {'error': 'Réponse serveur invalide'}; } }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override String toString() => message;
}
