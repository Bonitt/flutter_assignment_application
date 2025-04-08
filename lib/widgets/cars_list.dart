import 'package:flutter/material.dart';
import 'package:flutter_assignment_application/data/dummy_cars.dart';
import 'package:flutter_assignment_application/models/car.dart';

class CarList extends StatefulWidget{
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();

}

class _CarListState extends State<CarList> {

  List<Car> _cars= dummyCars;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Car Collection')),
      body: ListView.builder(
        itemCount: _cars.length,
        itemBuilder: (context, index) {
          final car = _cars[index];
          return Card(
            child: ListTile(
              title: Text('${car.name} (${car.model})'),
              subtitle: Text(
                '${car.year} - ${car.colour} - \$${car.price.toStringAsFixed(2)}',
              ),
            ),
          );
        },
      ),
    );
  }
}