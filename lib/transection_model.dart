class Item {
  late int? id;
  final String name;
  final int amount;
  final String date;
  final int color;

  Item({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.color,
  });

  // Convert an item object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'color': color,
    };
  }

  // Convert a map to an item object
  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      date: map['date'],
      color: map['color'],
    );
  }
}
