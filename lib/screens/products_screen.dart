import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final productsList = [
    {
      'nombre': 'Picafresa',
      'categoria': 'Dulces',
      'cantidad': 30,
      'activo': true,
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTw7m1C8gTFWU8BaI13HySxgmwnlQVNFhmmA&s'
    },
    {
      'nombre': 'Cheetos',
      'categoria': 'Botana',
      'cantidad': 16,
      'activo': true,
      'image':
          'https://i5-mx.walmartimages.com/samsmx/images/product-images/img_large/000115684l.jpg?odnHeight=612&odnWidth=612&odnBg=FFFFFF'
    },
    {
      'nombre': 'Tostachos',
      'categoria': 'Botana',
      'cantidad': 1,
      'activo': false,
      'image':
          'https://www.barcel.com.mx/themes/custom/barceldos/images/files/Tostachos_1.png'
    },
    {
      'nombre': 'Bic Boligrafo Azul',
      'categoria': 'Oficina',
      'cantidad': 17,
      'activo': true,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/a/a2/Standard-lock-key.jpg'
    },
    {
      'nombre': 'Lampara',
      'categoria': 'Decoración',
      'cantidad': 0,
      'activo': false,
      'image': ''
    }
  ];

  @override
  Widget build(BuildContext context) {
    final products = procesateProducts(productsList);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos tarjetas por fila
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio:
                2 / 3, // Relación ajustada para más espacio vertical
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildCard(products[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: (product.image.isNotEmpty &&
                      Uri.tryParse(product.image)?.hasAbsolutePath == true)
                  ? Image.network(
                      product.image,
                      fit: BoxFit.cover,
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
                  : Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Text(
                        'Sin imagen',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nombre,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  product.categoria,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Stock: ${product.cantidad}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  product.activo ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    color: product.activo ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Product> procesateProducts(List<Map<String, dynamic>> productsList) {
    return productsList.map((productDB) {
      return Product(
        nombre: productDB['nombre'].toString(),
        categoria: productDB['categoria'].toString(),
        cantidad: productDB['cantidad'] as int,
        activo: productDB['activo'] as bool,
        image: productDB['image'].toString(),
      );
    }).toList();
  }
}

class Product {
  String nombre;
  String categoria;
  int cantidad;
  bool activo;
  String image;

  Product({
    required this.nombre,
    required this.categoria,
    required this.cantidad,
    required this.activo,
    required this.image,
  });
}
