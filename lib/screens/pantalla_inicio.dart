import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PantallaInicio extends StatelessWidget {
  final String? role;
  const PantallaInicio({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        title: const Text("Proyecto"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, size: 80, color: Colors.black45),
            ),

            const SizedBox(height: 30),

            const Text(
              "Inicie sesión o regístrese",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(0, 80),
                    ),
                    onPressed: () {
                      final q = role != null ? '?role=$role' : '';
                      context.go('/login$q');
                    },
                    child: const Text(
                      "Iniciar\nSesión",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(0, 80),
                    ),
                    onPressed: () {
                      final q = role != null ? '?role=$role' : '';
                      context.go('/register$q');
                    },
                    child: const Text(
                      "Registrarse",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}