import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class PantallaGuardados extends StatelessWidget {
  const PantallaGuardados({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) {
      return Scaffold(body: Center(child: Text('No hay usuario')));
    }

    final ref = FirebaseFirestore.instance
        .collection('responsables')
        .doc(currentUid)
        .collection('savedAdults');

    return Scaffold(
      appBar: AppBar(title: const Text('Adultos guardados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: ref.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Center(child: Text('Por el momento no hay usuarios guardados'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final d = docs[index].data() as Map<String, dynamic>;
                      final display = (d['name'] as String?) ?? d['email'] ?? 'Usuario';
                      final id = docs[index].id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size.fromHeight(55)),
                          onPressed: () {
                            // Pasar email o uid
                            final email = d['email'] as String?;
                            final uid = d['uid'] as String?;
                            final query = email != null ? '?email=${Uri.encodeComponent(email)}' : '?uid=$uid';
                            context.push('/informacion$query');
                          },
                          child: Text(display),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size.fromHeight(55)),
                  onPressed: () {
                    context.go('/responsable');
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
