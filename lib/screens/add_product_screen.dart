import 'dart:io';

import 'package:capistock/infraestructure/network/product_service.dart';
import 'package:capistock/util/staticVariables.dart';
import 'package:capistock/util/util.dart';
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
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Seleccionar imagen'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Tomar Foto'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Seleccionar de Galería'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
          _imageUrlController.text = _imagePath!;
        });
      }
    }
  }

  void _saveProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, seleccione una imagen')),
      );
      return;
    }

    final Map<String, dynamic> newProduct = {
      "nombre": _nameController.text,
      "precio": _priceController.text,
      "stock": _stockController.text,
      "id_estado": (_isActive ? 1 : 2).toString(),
      "id_categoria": (_selectedCategoryId ?? 0).toString(),
    };

    try {
      _productService.saveProduct(File(_imagePath!), newProduct);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el producto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar Foto'),
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 16.0),
                (Uri.tryParse(_imagePath.toString())?.hasAbsolutePath == true)
                    ? (Util.isValidImageUrl(_imagePath.toString()))
                        ? Image.network(
                            height: 200,
                            _imagePath.toString(),
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Text(
                                  'Error al cargar',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          )
                        : Image.file(
                            File(_imagePath!),
                            height: 200,
                            fit: BoxFit.cover,
                          )
                    : Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Text(
                          'Sin imagen',
                          style: TextStyle(color: Colors.grey),
                        ),
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
