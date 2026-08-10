/// Lightweight preview model used to render invoice cards.
/// Replace with the real model backed by local storage / sqflite
/// once the generation flow (Phase 3–4 of the project plan) is wired up.
class InvoicePreview {
  final String number;
  final String customer;
  final double amount;
  final DateTime date;
  final bool paid;

  const InvoicePreview({
    required this.number,
    required this.customer,
    required this.amount,
    required this.date,
    required this.paid,
  });
}
