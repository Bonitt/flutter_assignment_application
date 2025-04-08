import 'package:flutter/material.dart';
import 'package:flutter_assignment_application/models/car.dart';

class CarList extends StatefulWidget{
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();

}

class _CarListState extends State<CarList> {

  List<Car> _cars= [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Car $index'),
            subtitle: Text('Details about Car $index'),
          ),
        );
      },
    );
  }
}