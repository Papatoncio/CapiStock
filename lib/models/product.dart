class Product {
  int id;
  String nombre;
  double precio;
  int categoria;
  int cantidad;
  bool activo;
  String image;

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.cantidad,
    required this.activo,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'],
      precio: double.tryParse(json['precio']) ?? 0.0,
      categoria: json['id_categoria'],
      cantidad: json['stock'],
      activo: json['id_estado'] == 1,
      image: '', // Ajustar según los datos recibidos
    );
  }
}
