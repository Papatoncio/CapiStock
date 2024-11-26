class Category {
  int id;
  String nombre;
  String descripcion;

  Category({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}
