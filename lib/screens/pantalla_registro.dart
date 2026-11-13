import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class PantallaRegistro extends StatefulWidget {
  final String? role;
  const PantallaRegistro({super.key, this.role});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedRole;
  bool loading = false;

  Future<void> registrarse() async {
    setState(() => loading = true);
    try {
      final UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = cred.user;
      if (user != null) {
        final uid = user.uid;
        final roleToSave = selectedRole ?? widget.role ?? 'no_especificado';

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': roleToSave,
          'address': addressController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro exitoso')));
        // small delay so the snackbar is visible
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) context.go('/principal');
        return;
      }
    } on FirebaseAuthException catch (e, st) {
      // log
      debugPrint('FirebaseAuthException: ${e.code} ${e.message}');
      debugPrint(st.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Ocurrió un error al registrarse."),
        ),
      );
    } catch (e, st) {
      debugPrint('Error registrarse: ${e.toString()}');
      debugPrint(st.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el perfil: ${e.toString()}'),
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedRole ??= widget.role;

    Color roleColor = Colors.grey;
    String roleLabel = 'Seleccione tipo';
    if (selectedRole == 'responsable') {
      roleColor = Colors.blue;
      roleLabel = 'Responsable';
    } else if (selectedRole == 'adulto_mayor') {
      roleColor = Colors.green;
      roleLabel = 'Adulto mayor';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Línea de rol con selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: roleColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      roleLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    onSelected: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'responsable', child: Text('Responsable')),
                      const PopupMenuItem(value: 'adulto_mayor', child: Text('Adulto mayor')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Nombre completo
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // Contraseña
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // Dirección opcional
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Dirección (opcional)',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : registrarse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                final q = selectedRole != null ? '?role=$selectedRole' : '';
                context.go('/login$q');
              },
              child: const Text(
                "¿Ya tiene una cuenta? Inicie sesión",
              ),
            ),
          ],
        ),
      ),
    );
  }
}