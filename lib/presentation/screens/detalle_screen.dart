import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';

class DetalleScreen extends StatelessWidget {
  final Post post;

  // El dato se pasa en el constructor con 'required' (sección 4.3)
  const DetalleScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post ${post.id}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.titulo,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(post.cuerpo, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}