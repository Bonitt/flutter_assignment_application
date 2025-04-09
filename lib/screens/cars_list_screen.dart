import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/car.dart';
import 'add_car_screen.dart';
import 'car_details_screen.dart';
import 'package:http/http.dart' as http;

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  List<Car> _cars = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    try {
      final url = Uri.https(
        'futterassingmentdb-default-rtdb.europe-west1.firebasedatabase.app', 
        'cars.json'
      );
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception('Failed to load cars');
      }

      final List<Car> loadedCars = [];
      
      if (response.body != 'null') {
        final Map<String, dynamic> data = json.decode(response.body);
        data.forEach((carId, carData) {
          loadedCars.add(Car(
            id: carId,
            name: carData['name'] ?? '',
            model: carData['model'] ?? '',
            year: carData['year'] ?? 0,
            price: carData['price']?.toDouble() ?? 0.0,
            colour: carData['colour'] ?? '',
            imageUrl: carData['imageUrl'],
          ));
        });
      }

      setState(() {
        _cars = loadedCars;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _addCar(Car car) async {
    try {
      final url = Uri.https(
        'futterassingmentdb-default-rtdb.europe-west1.firebasedatabase.app',
        'cars.json',
      );

      final response = await http.post(
        url,
        body: json.encode({
          'name': car.name,
          'model': car.model,
          'year': car.year,
          'price': car.price,
          'colour': car.colour,
          'imageUrl': car.imageUrl,
        }),
      );

      if (response.statusCode >= 400) {
        throw Exception('Failed to add car');
      }

      final newCar = Car(
        id: json.decode(response.body)['name'],
        name: car.name,
        model: car.model,
        year: car.year,
        price: car.price,
        colour: car.colour,
        imageUrl: car.imageUrl,
      );

      setState(() {
        _cars.add(newCar);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add car: $e')),
      );
    }
  }

  Future<void> _deleteCar(String carId) async {
    try {
      final url = Uri.https(
        'futterassingmentdb-default-rtdb.europe-west1.firebasedatabase.app',
        'cars/$carId.json',
      );

      await http.delete(url);

      setState(() {
        _cars.removeWhere((car) => car.id == carId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete car: $e')),
      );
      _loadCars();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cars'),
        
      ),
      body: _buildContent(),
      floatingActionButton: _isLoading || _hasError
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final newCar = await Navigator.push<Car>(
                  context,
                  MaterialPageRoute(builder: (ctx) => const AddCarScreen()),
                );
                if (newCar != null) await _addCar(newCar);
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      return _buildErrorView();
    } else if (_cars.isEmpty) {
      return _buildEmptyView();
    } else {
      return _buildCarList();
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to load cars', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCars,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'No cars found!',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCarList() {
    return RefreshIndicator(
      onRefresh: _loadCars,
      child: ListView.builder(
        itemCount: _cars.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_cars[index].id),
          background: Container(color: Colors.red),
          onDismissed: (direction) => _deleteCar(_cars[index].id!),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('${_cars[index].name} ${_cars[index].model}'),
              subtitle: Text(
                '${_cars[index].year} • ${_cars[index].colour} • \$${_cars[index].price.toStringAsFixed(2)}',
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(car: _cars[index]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}