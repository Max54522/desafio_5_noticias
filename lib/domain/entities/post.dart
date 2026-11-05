class Post {
  final int    id;
  final String titulo;
  final String cuerpo;
  final int    usuarioId;

  Post({
    required this.id,
    required this.titulo,
    required this.cuerpo,
    required this.usuarioId,
  });

  // fromJson: convierte el mapa JSON en un objeto Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id:        json['id'],
      titulo:    json['title'],
      cuerpo:    json['body'],
      usuarioId: json['userId'],
    );
  }
}