import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/user_provider.dart';
import '../screens/login_screen.dart';
import '../screens/splash_produtos_screen.dart';
import '../screens/cadastro02_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Usar addPostFrameCallback para evitar chamadas durante o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.carregarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Mostrar loading enquanto não foi inicializado
        if (!userProvider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (userProvider.isLoggedIn) {
          final usuario = userProvider.usuarioLogado;
          if (usuario != null && usuario.cadastroCompleto == true) {
            return const SplashProdutosScreen();
          } else {
            return const Cadastro02Screen();
          }
        } else {
          return const LoginScreen();
        }
      },
    );
  }
} 