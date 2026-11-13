import 'package:go_router/go_router.dart';

import '../screens/pantalla_inicio.dart';
import '../screens/pantalla_usuario.dart';
import '../screens/pantalla_login.dart';
import '../screens/pantalla_registro.dart';
import '../screens/pantalla_principal.dart';
import '../screens/pantalla_numeros.dart';
import '../screens/pantalla_perfilmedico.dart';
import '../screens/pantalla_guia.dart';
import '../screens/pantalla_responsable.dart';
import '../screens/pantalla_agregar.dart';
import '../screens/pantalla_guardados.dart';
import '../screens/pantalla_informacion.dart';

final GoRouter router = GoRouter(
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const PantallaUsuario(),
    ),

    GoRoute(
      path: '/inicio',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'];
        return PantallaInicio(role: role);
      },
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const PantallaLogin(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'];
        return PantallaRegistro(role: role);
      },
    ),

    GoRoute(
      path: '/principal',
      builder: (context, state) => const PantallaPrincipal(),
    ),

    GoRoute(
      path: '/numeros',
      builder: (context, state) => const PantallaNumeros(),
    ),

    GoRoute(
      path: '/perfil_medico',
      builder: (context, state) => const PantallaPerfilMedico(),
    ),

    GoRoute(
      path: '/guia',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'];
        return PantallaGuia(role: role);
      },
    ),

    GoRoute(
      path: '/responsable',
      builder: (context, state) => const PantallaResponsable(),
    ),

    GoRoute(
      path: '/agregar',
      builder: (context, state) => const PantallaAgregar(),
    ),

    GoRoute(
      path: '/guardados',
      builder: (context, state) => const PantallaGuardados(),
    ),

    GoRoute(
      path: '/informacion',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        final uid = state.uri.queryParameters['uid'];
        return PantallaInformacion(email: email, uid: uid);
      },
    ),

  ],
);