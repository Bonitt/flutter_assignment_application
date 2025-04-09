import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_application/services/notifcation_service.dart';
import 'package:image_picker/image_picker.dart';
import '../models/car.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _colourController = TextEditingController();
  File? _selectedImage;
  String? _imageBase64;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final bytes = await imageFile.readAsBytes();
        setState(() {
          _selectedImage = imageFile;
          _imageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image picker error: ${e.toString()}')),
      );
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add an image of the car'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving car...')),
      );

      try {
        final newCar = Car(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          model: _modelController.text,
          year: int.parse(_yearController.text),
          price: double.parse(_priceController.text),
          colour: _colourController.text,
          imageUrl: _imageBase64,
        );

        await NotificationService().showValidationNotification('Car added successfully!');

        Navigator.pop(context, newCar);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving car: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Car')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildImagePreview(),
              const SizedBox(height: 20),
              _buildFormFields(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: _selectedImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(_selectedImage!, fit: BoxFit.cover),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.car_rental, size: 50, color: Colors.grey),
                Text('No image selected'),
              ],
            ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Make'),
          validator: (value) => value!.isEmpty ? 'Enter make' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _modelController,
          decoration: const InputDecoration(labelText: 'Model'),
          validator: (value) => value!.isEmpty ? 'Enter model' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _yearController,
          decoration: const InputDecoration(labelText: 'Year'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter year';
            if (int.tryParse(value) == null) return 'Enter valid year';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter price';
            if (double.tryParse(value) == null) return 'Enter valid price';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _colourController,
          decoration: const InputDecoration(labelText: 'Colour'),
          validator: (value) => value!.isEmpty ? 'Enter colour' : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Add Car',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _colourController.dispose();
    super.dispose();
  }
}