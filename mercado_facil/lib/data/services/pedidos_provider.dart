import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../models/carrinho_item.dart';
import 'pedidos_service.dart';

class PedidosProvider extends ChangeNotifier {
  final PedidosService _pedidosService = PedidosService();
  final String userId;

  List<Pedido> _pedidos = [];
  Pedido? _pedidoAtual;
  bool _carregando = false;
  String? _erro;

  PedidosProvider({required this.userId});

  // Getters
  List<Pedido> get pedidos => List.unmodifiable(_pedidos);
  Pedido? get pedidoAtual => _pedidoAtual;
  bool get carregando => _carregando;
  String? get erro => _erro;

  // Pedidos por status
  List<Pedido> get pedidosPendentes => _pedidos.where((p) => p.status == StatusPedido.pendente).toList();
  List<Pedido> get pedidosEmAndamento => _pedidos.where((p) => p.estaEmAndamento).toList();
  List<Pedido> get pedidosEntregues => _pedidos.where((p) => p.foiEntregue).toList();
  List<Pedido> get pedidosCancelados => _pedidos.where((p) => p.foiCancelado).toList();

  // Carregar pedidos do usuário
  Future<void> carregarPedidos() async {
    if (userId.isEmpty) return;

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _pedidos = await _pedidosService.buscarPedidosUsuario(userId);
      print('Pedidos carregados: ${_pedidos.length}');
    } catch (e) {
      _erro = 'Erro ao carregar pedidos: $e';
      print('Erro ao carregar pedidos: $e');
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Criar novo pedido
  Future<String?> criarPedido({
    required List<CarrinhoItem> itens,
    required Map<String, dynamic> enderecoEntrega,
    required String metodoPagamento,
    String? observacoes,
  }) async {
    print('=== PEDIDOS PROVIDER - CRIAR PEDIDO ===');
    print('UserId: $userId');
    print('Itens: ${itens.length}');
    print('Endereço: $enderecoEntrega');
    print('Método: $metodoPagamento');
    
    if (userId.isEmpty) {
      print('❌ Usuário não identificado');
      _erro = 'Usuário não identificado';
      notifyListeners();
      return null;
    }

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      print('Chamando PedidosService.criarPedido...');
      final pedidoId = await _pedidosService.criarPedido(
        usuarioId: userId,
        itens: itens,
        enderecoEntrega: enderecoEntrega,
        metodoPagamento: metodoPagamento,
        observacoes: observacoes,
      );

      print('✅ Pedido criado com ID: $pedidoId');
      
      // Recarregar pedidos para incluir o novo
      print('Recarregando lista de pedidos...');
      await carregarPedidos();

      print('✅ Pedido criado com sucesso: $pedidoId');
      return pedidoId;
    } catch (e) {
      print('❌ Erro no PedidosProvider: $e');
      _erro = 'Erro ao criar pedido: $e';
      print('Erro ao criar pedido: $e');
      return null;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Carregar pedido específico
  Future<void> carregarPedido(String pedidoId) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _pedidoAtual = await _pedidosService.buscarPedido(pedidoId);
      if (_pedidoAtual == null) {
        _erro = 'Pedido não encontrado';
      }
    } catch (e) {
      _erro = 'Erro ao carregar pedido: $e';
      print('Erro ao carregar pedido: $e');
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Cancelar pedido
  Future<bool> cancelarPedido(String pedidoId) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      await _pedidosService.cancelarPedido(pedidoId);
      
      // Atualizar pedido na lista
      final index = _pedidos.indexWhere((p) => p.id == pedidoId);
      if (index >= 0) {
        _pedidos[index] = _pedidos[index].copyWith(status: StatusPedido.cancelado);
      }

      // Atualizar pedido atual se for o mesmo
      if (_pedidoAtual?.id == pedidoId) {
        _pedidoAtual = _pedidoAtual!.copyWith(status: StatusPedido.cancelado);
      }

      print('Pedido cancelado com sucesso: $pedidoId');
      return true;
    } catch (e) {
      _erro = 'Erro ao cancelar pedido: $e';
      print('Erro ao cancelar pedido: $e');
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Atualizar status do pedido
  Future<bool> atualizarStatusPedido(String pedidoId, StatusPedido novoStatus) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      await _pedidosService.atualizarStatusPedido(pedidoId, novoStatus);
      
      // Atualizar pedido na lista
      final index = _pedidos.indexWhere((p) => p.id == pedidoId);
      if (index >= 0) {
        _pedidos[index] = _pedidos[index].copyWith(status: novoStatus);
      }

      // Atualizar pedido atual se for o mesmo
      if (_pedidoAtual?.id == pedidoId) {
        _pedidoAtual = _pedidoAtual!.copyWith(status: novoStatus);
      }

      print('Status do pedido atualizado: $pedidoId -> ${novoStatus.name}');
      return true;
    } catch (e) {
      _erro = 'Erro ao atualizar status do pedido: $e';
      print('Erro ao atualizar status do pedido: $e');
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Adicionar código de rastreamento
  Future<bool> adicionarCodigoRastreamento(String pedidoId, String codigo) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      await _pedidosService.adicionarCodigoRastreamento(pedidoId, codigo);
      
      // Atualizar pedido na lista
      final index = _pedidos.indexWhere((p) => p.id == pedidoId);
      if (index >= 0) {
        _pedidos[index] = _pedidos[index].copyWith(codigoRastreamento: codigo);
      }

      // Atualizar pedido atual se for o mesmo
      if (_pedidoAtual?.id == pedidoId) {
        _pedidoAtual = _pedidoAtual!.copyWith(codigoRastreamento: codigo);
      }

      print('Código de rastreamento adicionado: $pedidoId -> $codigo');
      return true;
    } catch (e) {
      _erro = 'Erro ao adicionar código de rastreamento: $e';
      print('Erro ao adicionar código de rastreamento: $e');
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Buscar pedidos por status
  Future<List<Pedido>> buscarPedidosPorStatus(StatusPedido status) async {
    try {
      return await _pedidosService.buscarPedidosPorStatus(userId, status);
    } catch (e) {
      print('Erro ao buscar pedidos por status: $e');
      return [];
    }
  }

  // Buscar estatísticas
  Future<Map<String, dynamic>> buscarEstatisticas() async {
    try {
      return await _pedidosService.estatisticasUsuario(userId);
    } catch (e) {
      print('Erro ao buscar estatísticas: $e');
      return {
        'totalPedidos': 0,
        'pedidosPendentes': 0,
        'pedidosEmAndamento': 0,
        'pedidosEntregues': 0,
        'pedidosCancelados': 0,
        'valorTotal': 0.0,
      };
    }
  }

  // Limpar erro
  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  // Limpar pedido atual
  void limparPedidoAtual() {
    _pedidoAtual = null;
    notifyListeners();
  }
} 