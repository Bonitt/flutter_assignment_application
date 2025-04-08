import 'package:flutter/material.dart';
import 'package:flutter_assignment_application/models/car.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(car.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Model: ${car.model}', style: const TextStyle(fontSize: 18)),
            Text('Year: ${car.year}', style: const TextStyle(fontSize: 18)),
            Text('Color: ${car.colour}', style: const TextStyle(fontSize: 18)),
            Text('Price: \$${car.price}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
