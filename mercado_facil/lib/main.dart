import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/cadastro01_screen.dart';
import 'presentation/screens/cadastro02_screen.dart';
import 'presentation/screens/splash_produtos_screen.dart';
import 'presentation/screens/produtos_screen.dart';
import 'presentation/screens/carrinho_screen.dart';
import 'presentation/screens/notificacoes_screen.dart';
import 'presentation/screens/enderecos_screen.dart';
import 'presentation/screens/meus_dados_screen.dart';
import 'presentation/screens/firebase_test_screen.dart';
import 'data/services/carrinho_provider.dart';
import 'data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Mercado Fácil',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/cadastro01': (context) => const Cadastro01Screen(),
          '/cadastro02': (context) => const Cadastro02Screen(),
          '/splash_produtos': (context) => const SplashProdutosScreen(),
          '/produtos': (context) => const ProdutosScreen(),
          '/carrinho': (context) => const CarrinhoScreen(),
          '/notificacoes': (context) => const NotificacoesScreen(),
          '/enderecos': (context) => const EnderecosScreen(),
          '/perfil': (context) => const MeusDadosScreen(),
          '/firebase_test': (context) => const FirebaseTestScreen(),
        },
      ),
    );
  }
} 