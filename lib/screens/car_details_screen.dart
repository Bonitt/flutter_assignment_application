import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/car.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${car.name} ${car.model}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarImage(),
            const SizedBox(height: 24),
            _buildVehicleInfoSection(theme), 
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: car.imageUrl != null && car.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                base64Decode(car.imageUrl!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  _buildImagePlaceholder(),
              ),
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildVehicleInfoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Information',
          style: theme.textTheme.headlineMedium, 
        ),
        const Divider(height: 20),
        _buildDetailRow('Make', car.name),
        _buildDetailRow('Model', car.model),
        _buildDetailRow('Year', car.year.toString()),
        _buildDetailRow('Colour', car.colour),
        _buildDetailRow(
          'Price', 
          '€${car.price.toStringAsFixed(2)}',
          isImportant: true,
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.car_rental, size: 50, color: Colors.grey[600]),
        const SizedBox(height: 10),
        Text(
          car.imageUrl == null ? 'No image available' : 'Invalid image',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
                color: isImportant ? Colors.blue[800] : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}