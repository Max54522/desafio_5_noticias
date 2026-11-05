import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;

  // Controlador del buscador (igual que el TextField de la sección 2.6)
  final TextEditingController _busquedaCtrl = TextEditingController();
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _postsFuture = _apiService.getPosts();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // El buscador está en el título del AppBar
        title: TextField(
          controller: _busquedaCtrl,
          decoration: InputDecoration(
            hintText: 'Buscar por título...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (texto) {
            setState(() => _busqueda = texto);
          },
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {

          // ── ESTADO 1: Todavía cargando ─────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando posts...'),
                ],
              ),
            );
          }

          // ── ESTADO 2: Hubo un error ────────────────────────
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text('Error al cargar los datos'),
                  SizedBox(height: 8),
                  Text('${snapshot.error}',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _postsFuture = _apiService.getPosts();
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // ── ESTADO 3: Datos llegaron ───────────────────────
          final List<Post> todos = snapshot.data!;

          // Filtrar por título con .where (sección 1.5)
          final List<Post> posts = todos
              .where((p) =>
              p.titulo.toLowerCase().contains(_busqueda.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${post.id}'),
                ),
                title: Text(post.titulo),
                subtitle: Text(
                  post.cuerpo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleScreen(post: post),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}