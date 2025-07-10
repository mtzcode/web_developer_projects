import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'core/theme/app_theme.dart';
import 'presentation/widgets/auth_wrapper.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/cadastro01_screen.dart';
import 'presentation/screens/cadastro02_screen.dart';
import 'presentation/screens/splash_produtos_screen.dart';
import 'presentation/screens/produtos_screen.dart';
import 'presentation/screens/carrinho_screen.dart';
import 'presentation/screens/notificacoes_screen.dart';
import 'presentation/screens/enderecos_screen.dart';
import 'presentation/screens/meus_dados_screen.dart';
import 'presentation/screens/redefinir_senha_screen.dart';
import 'data/services/carrinho_provider.dart';
import 'data/services/firestore_auth_service.dart';
import 'data/services/user_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configurar AppCheck (desabilitado temporariamente para debug)
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.debug,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider<FirestoreAuthService>(create: (_) => FirestoreAuthService()),
        ProxyProvider<UserProvider, CarrinhoProvider>(
          update: (context, userProvider, previous) {
            final userId = userProvider.usuarioLogado?.id;
            if (userId != null) {
              return CarrinhoProvider(userId: userId);
            } else {
              // Retorna um provider "vazio" se não estiver logado
              return CarrinhoProvider(userId: '');
            }
          },
        ),
      ],
      child: MaterialApp(
        title: 'Mercado Fácil',
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/cadastro01': (context) => const Cadastro01Screen(),
          '/cadastro02': (context) => const Cadastro02Screen(),
          '/home': (context) => const SplashProdutosScreen(),
          '/splash_produtos': (context) => const SplashProdutosScreen(),
          '/produtos': (context) => const ProdutosScreen(),
          '/carrinho': (context) => const CarrinhoScreen(),
          '/notificacoes': (context) => const NotificacoesScreen(),
          '/enderecos': (context) => const EnderecosScreen(),
          '/perfil': (context) => const MeusDadosScreen(),
          '/redefinir_senha': (context) => const RedefinirSenhaScreen(),
        },
      ),
    );
  }
} 