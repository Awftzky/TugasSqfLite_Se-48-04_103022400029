class Item {
  const Item({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.location,
  });

  final int? id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final String location;

  factory Item.fromMap(Map<String, Object?> map) {
    return Item(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'] as String,
      location: map['location'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'location': location,
    };
  }

  Item copyWith({
    int? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    String? location,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      location: location ?? this.location,
    );
  }
}
