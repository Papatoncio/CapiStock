import 'dart:io';

import 'package:capistock/infraestructure/network/product_service.dart';
import 'package:capistock/models/product.dart';
import 'package:capistock/util/staticVariables.dart';
import 'package:capistock/util/util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  final TextEditingController _imageUrlController = TextEditingController();
  int? _selectedCategoryId;
  late bool _isActive;
  int? productId;
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.nombre);
    _stockController =
        TextEditingController(text: widget.product.cantidad.toString());
    _priceController =
        TextEditingController(text: widget.product.precio.toString());
    _selectedCategoryId = widget.product.categoria;
    _isActive = widget.product.activo;
    productId = widget.product.id;
    _imagePath = widget.product.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateProduct() {
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

    final Map<String, dynamic> updatedProduct = {
      "nombre": _nameController.text,
      "precio": _priceController.text,
      "stock": _stockController.text,
      "id_estado": (_isActive ? 1 : 2).toString(),
      "id_categoria": (_selectedCategoryId ?? 0).toString(),
    };

    try {
      _productService.updateProduct(
          File(_imagePath!), updatedProduct, productId);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el producto: $e')),
      );
    }

    setState(() {
      widget.product.nombre = _nameController.text;
      widget.product.categoria = _selectedCategoryId ?? 0;
      widget.product.cantidad = int.tryParse(_stockController.text) ?? 0;
      widget.product.activo = _isActive;
      widget.product.image = _imageUrlController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              decoration: const InputDecoration(labelText: 'Cantidad en stock'),
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
            ElevatedButton(
              onPressed: _updateProduct,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
