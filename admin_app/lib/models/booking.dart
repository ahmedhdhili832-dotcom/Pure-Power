class Booking {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String service;
  final num quantity;
  final num unitPrice;
  final num totalPrice;
  final String date;
  final String time;
  final String address;
  final String needs;
  final String status;
  final String contractStatus;
  final String paymentStatus;
  final String? contractToken;
  final String? createdAt;

  const Booking({required this.id, required this.firstName, required this.lastName, required this.email, required this.phone, required this.service, required this.quantity, required this.unitPrice, required this.totalPrice, required this.date, required this.time, required this.address, required this.needs, required this.status, required this.contractStatus, required this.paymentStatus, this.contractToken, this.createdAt});

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
    id: '${j['id'] ?? ''}', firstName: '${j['client_first_name'] ?? ''}', lastName: '${j['client_last_name'] ?? ''}', email: '${j['email'] ?? ''}', phone: '${j['phone'] ?? ''}', service: '${j['service'] ?? ''}', quantity: j['quantity'] ?? 0, unitPrice: j['unit_price'] ?? 0, totalPrice: j['total_price'] ?? 0, date: '${j['booking_date'] ?? ''}', time: '${j['booking_time'] ?? ''}', address: '${j['address'] ?? ''}', needs: '${j['needs'] ?? ''}', status: '${j['status'] ?? ''}', contractStatus: '${j['contract_status'] ?? ''}', paymentStatus: '${j['payment_status'] ?? ''}', contractToken: j['contract_token']?.toString(), createdAt: j['created_at']?.toString());

  String get clientName => '$firstName $lastName'.trim();
}
