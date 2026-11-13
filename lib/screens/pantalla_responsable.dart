import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PantallaResponsable extends StatelessWidget {
  const PantallaResponsable({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsable'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size.fromHeight(55)),
              onPressed: () {
                context.push('/agregar');
              },
              child: const Text('Agregar adultos mayores'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size.fromHeight(55)),
              onPressed: () {
                context.push('/guardados');
              },
              child: const Text('Datos del adulto mayor'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], minimumSize: const Size.fromHeight(55)),
              onPressed: () {
                context.go('/guia?role=responsable');
              },
              child: const Text('Guía'),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size.fromHeight(55)),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                context.go('/');
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
