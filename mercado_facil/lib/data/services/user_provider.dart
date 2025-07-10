import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import 'firestore_auth_service.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreAuthService _authService = FirestoreAuthService();
  Usuario? _usuarioLogado;
  bool _isLoading = false;

  Usuario? get usuarioLogado => _usuarioLogado;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _usuarioLogado != null;

  // Carregar dados do usuário logado
  Future<void> carregarUsuarioLogado() async {
    setState(() => _isLoading = true);
    
    try {
      _usuarioLogado = await _authService.getUsuarioLogado();
      notifyListeners();
    } catch (e) {
      _usuarioLogado = null;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fazer logout
  Future<void> fazerLogout() async {
    try {
      await _authService.fazerLogout();
      _usuarioLogado = null;
      notifyListeners();
    } catch (e) {
      // Ignorar erro no logout
    }
  }

  // Atualizar dados do usuário
  Future<void> atualizarDadosUsuario(Map<String, dynamic> dados) async {
    if (_usuarioLogado == null) return;
    
    try {
      await _authService.atualizarUsuario(_usuarioLogado!.id, dados);
      
      // Recarregar dados do usuário
      await carregarUsuarioLogado();
    } catch (e) {
      rethrow;
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
} 