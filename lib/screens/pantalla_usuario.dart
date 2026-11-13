import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PantallaUsuario extends StatefulWidget {
  final String? photoUrl;
  const PantallaUsuario({super.key, this.photoUrl});

  @override
  State<PantallaUsuario> createState() => _PantallaUsuarioState();
}

class _PantallaUsuarioState extends State<PantallaUsuario> {
  int _attempt = 0;

  String? get _resolvedPhotoUrl {
    // Priority: constructor > query param
    String? original;
    if (widget.photoUrl != null && widget.photoUrl!.isNotEmpty) {
      original = widget.photoUrl;
    } else {
      final qp = Uri.base.queryParameters['photo'];
      if (qp != null && qp.isNotEmpty) original = qp;
    }
    if (original == null) return null;
    return _toRawGithubUrl(original);
  }

  String _toRawGithubUrl(String url) {
    // If already raw, return as-is
    if (url.contains('raw.githubusercontent.com')) return url;

    // Transform common GitHub blob URL to raw URL
    // Example: https://github.com/user/repo/blob/main/path -> https://raw.githubusercontent.com/user/repo/main/path
    try {
      final uri = Uri.parse(url);
      if (uri.host == 'github.com') {
        final parts = uri.pathSegments;
        // Expect at least: [user, repo, 'blob', branch, ...path]
        if (parts.length >= 5 && parts[2] == 'blob') {
          final user = parts[0];
          final repo = parts[1];
          final branch = parts[3];
          final path = parts.sublist(4).join('/');
          return 'https://raw.githubusercontent.com/$user/$repo/$branch/$path';
        }
      }
    } catch (_) {
      // ignore parse errors
    }
    return url;
  }

  void _retry() {
    setState(() {
      _attempt++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final photo = _resolvedPhotoUrl;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Espacio para imagen cuadrada (carga desde URL si existe)
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: photo != null
                    ? Column(
                        children: [
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                photo,
                                key: ValueKey('photo_\$_attempt'),
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 180,
                                    height: 180,
                                    color: Colors.grey[200],
                                    child: const Center(child: CircularProgressIndicator()),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint('Error cargando imagen desde URL: $error');
                                  return Container(
                                    width: 180,
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.broken_image, size: 56, color: Colors.black45),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: _retry,
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                          child: const Text('Reintentar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(photo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                        ],
                      )
                    : Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.black45,
                        ),
                      ),
              ),

              const SizedBox(height: 30),

              // Texto central
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'Hola, esta es la app oficial de cuidANDO, para brindarle seguridad a los adultos mayores frente caídas e informarlo en el menor tiempo posible. Desea crear cuenta cómo adulto mayor o como responsable?',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botones abajo
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(0, 60),
                      ),
                      onPressed: () {
                        context.go('/inicio?role=responsable');
                      },
                      child: const Text('Responsable'),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(0, 60),
                      ),
                      onPressed: () {
                        context.go('/inicio?role=adulto_mayor');
                      },
                      child: const Text('Adulto mayor'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
