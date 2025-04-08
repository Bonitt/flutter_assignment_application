// models/car.dart
class Car {
  final String id;
  final String name;
  final String model;
  final int year;
  final double price;
  final String colour;
  final String? imageUrl;

  const Car({
    required this.id,
    required this.name,
    required this.model,
    required this.year,
    required this.price,
    required this.colour,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'year': year,
      'price': price,
      'colour': colour,
      'imageUrl': imageUrl,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      colour: map['colour'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }
}