import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class PantallaAgregar extends StatefulWidget {
  const PantallaAgregar({super.key});

  @override
  State<PantallaAgregar> createState() => _PantallaAgregarState();
}

class _PantallaAgregarState extends State<PantallaAgregar> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> guardar() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;
    setState(() => loading = true);
    try {
      // Comprobar existencia consultando la colección 'users'
      final q = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (q.docs.isNotEmpty) {
        final doc = q.docs.first;

        final currentUid = FirebaseAuth.instance.currentUser?.uid;
        String docId = doc['uid'] ?? email.replaceAll('.', '_');
        Map<String, dynamic> dataToSave = {
          'email': email,
          'uid': doc['uid'],
          'name': doc['name'],
          'savedAt': FieldValue.serverTimestamp(),
        };

        if (currentUid != null) {
          await FirebaseFirestore.instance
              .collection('responsables')
              .doc(currentUid)
              .collection('savedAdults')
              .doc(docId)
              .set(dataToSave);
        }

        // Volver a pantalla responsable y mostrar snackbar
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El usuario ha sido guardado con éxito')));
        setState(() => loading = false);
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se ha encontrado el usuario')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar adulto mayor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email del adulto mayor', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading ? null : guardar,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(0, 50)),
                    child: const Text('Guardar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(0, 50)),
                    child: const Text('Cancelar'),
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
