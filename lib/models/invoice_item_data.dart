/// A single line item on an invoice.
/// This is intentionally a plain, flat model (not a Flutter controller)
/// so the SAME class can be used for the on-screen form, for local
/// storage (Hive/JSON), and for feeding the PDF template.
///
/// Because it's just a list, the invoice can have 1 item or 50 items —
/// nothing about the PDF template or storage is hard-coded to a fixed
/// number of fields.
class InvoiceItemData {
  String name;
  double price;
  int qty;
  double discount;

  InvoiceItemData({
    required this.name,
    required this.price,
    required this.qty,
    required this.discount,
  });

  double get lineTotal => (price * qty) - discount;

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'qty': qty,
        'discount': discount,
      };

  factory InvoiceItemData.fromJson(Map<String, dynamic> json) => InvoiceItemData(
        name: json['name'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        qty: (json['qty'] as num?)?.toInt() ?? 0,
        discount: (json['discount'] as num?)?.toDouble() ?? 0,
      );
}