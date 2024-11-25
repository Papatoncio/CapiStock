class Product {
  int id;
  String nombre;
  String categoria;
  int cantidad;
  bool activo;
  String image;

  Product({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.cantidad,
    required this.activo,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['id_categoria'].toString(),
      cantidad: json['stock'],
      activo: json['id_estado'] == 1,
      image: '', // Ajustar según los datos recibidos
    );
  }
}
