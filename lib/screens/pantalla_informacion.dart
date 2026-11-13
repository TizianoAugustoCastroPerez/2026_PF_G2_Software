import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class PantallaInformacion extends StatelessWidget {
  final String? email;
  final String? uid;
  const PantallaInformacion({super.key, this.email, this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>?>(
          future: email != null
              ? FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get()
              : (uid != null
                  ? FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).limit(1).get()
                  : Future.value(null)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No se encontró información del usuario'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      context.go('/agregar');
                    },
                    child: const Text('Volver'),
                  ),
                ],
              );
            }

            final data = docs.first.data() as Map<String, dynamic>;
            final name = data['name'] as String? ?? 'Sin nombre';
            final address = (data['address'] as String?)?.isNotEmpty == true ? data['address'] as String : 'El usuario decidió no compartirla';
            final perfilMedico = (data['perfil_medico'] as String?) ?? 'Aún no se ingresó';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre completo: $name', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 12),
                Text('Domicilio: $address', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                Text('Perfil médico: $perfilMedico', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                const Text('Ubicación actual:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                const Text('(Por ahora vacío)'),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    context.go('/agregar');
                  },
                  child: const Text('Volver'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
