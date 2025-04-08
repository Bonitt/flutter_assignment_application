import 'package:flutter/material.dart';

class CarList extends StatefulWidget{
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();

}

class _CarListState extends State<CarList> {
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