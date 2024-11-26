import 'package:capistock/infraestructure/network/category_service.dart';
import 'package:capistock/models/product.dart';
import 'package:capistock/util/staticVariables.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CategoryService _categoryService = CategoryService();
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.nombre);
    _stockController =
        TextEditingController(text: widget.product.cantidad.toString());
    _selectedCategoryId =
        widget.product.categoria; // Initialize selected category
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Save logic
    setState(() {
      widget.product.nombre = _nameController.text;
      widget.product.categoria = _selectedCategoryId ?? 0;
      widget.product.cantidad = int.tryParse(_stockController.text) ?? 0;
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios guardados.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
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
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad en stock'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
