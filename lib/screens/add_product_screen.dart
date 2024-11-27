import 'dart:io';

import 'package:capistock/infraestructure/network/product_service.dart';
import 'package:capistock/util/staticVariables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  int? _selectedCategoryId;
  bool _isActive = true;
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _imageUrlController.text = _imagePath!;
      });
    }
  }

  void _saveProduct() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    final newProduct = {
      "nombre": _nameController.text,
      "precio": _priceController.text,
      "stock": _stockController.text,
      "id_estado": (_isActive ? 1 : 2).toString(),
      "id_categoria": (_selectedCategoryId ?? 0).toString(),
    };

    print({"imagen": _imageUrlController.text});

    // Aquí podrías llamar a tu servicio para guardar el producto
    print(newProduct);

    _productService.saveProduct(newProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto agregado correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Cantidad en stock'),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: StaticVariables.categoriesList.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Activo'),
                  const SizedBox(width: 8.0),
                  Checkbox(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _imageUrlController,
                decoration:
                    const InputDecoration(labelText: 'URL de la imagen'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Seleccionar Imagen'),
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 16.0),
                Image.file(
                  File(_imagePath!),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ],
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  child: const Text('Guardar Producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
