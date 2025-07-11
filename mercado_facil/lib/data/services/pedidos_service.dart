import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../models/carrinho_item.dart';
import '../models/usuario.dart';

class PedidosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _colecao = 'pedidos';

  // Criar novo pedido
  Future<String> criarPedido({
    required String usuarioId,
    required List<CarrinhoItem> itens,
    required Map<String, dynamic> enderecoEntrega,
    required String metodoPagamento,
    String? observacoes,
    double taxaEntrega = 5.0, // Taxa fixa por enquanto
  }) async {
    try {
      print('=== INICIANDO CRIAÇÃO DE PEDIDO ===');
      print('UsuarioId: $usuarioId');
      print('Quantidade de itens: ${itens.length}');
      print('Endereço: $enderecoEntrega');
      print('Método de pagamento: $metodoPagamento');
      print('Observações: $observacoes');
      
      // Calcular totais
      final subtotal = itens.fold(0.0, (soma, item) => soma + item.subtotal);
      final total = subtotal + taxaEntrega;
      
      print('Subtotal: $subtotal');
      print('Taxa de entrega: $taxaEntrega');
      print('Total: $total');

      // Preparar dados do pedido
      final dadosPedido = {
        'usuarioId': usuarioId,
        'itens': itens.map((item) => {
          'produto': item.produto.toMap(),
          'quantidade': item.quantidade,
        }).toList(),
        'subtotal': subtotal,
        'taxaEntrega': taxaEntrega,
        'total': total,
        'enderecoEntrega': enderecoEntrega,
        'observacoes': observacoes,
        'status': StatusPedido.pendente.name,
        'dataCriacao': DateTime.now().toIso8601String(),
        'metodoPagamento': metodoPagamento,
      };
      
      print('Dados do pedido preparados: $dadosPedido');

      // Criar documento do pedido
      print('Tentando criar documento no Firestore...');
      final docRef = await _firestore.collection(_colecao).add(dadosPedido);
      
      print('✅ Pedido criado com sucesso: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Erro ao criar pedido: $e');
      print('Tipo do erro: ${e.runtimeType}');
      if (e is FirebaseException) {
        print('Código do erro: ${e.code}');
        print('Mensagem do erro: ${e.message}');
      }
      throw Exception('Erro ao criar pedido: $e');
    }
  }

  // Buscar pedidos do usuário
  Future<List<Pedido>> buscarPedidosUsuario(String usuarioId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_colecao)
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('dataCriacao', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Pedido.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Erro ao buscar pedidos: $e');
      return [];
    }
  }

  // Buscar pedido específico
  Future<Pedido?> buscarPedido(String pedidoId) async {
    try {
      final doc = await _firestore.collection(_colecao).doc(pedidoId).get();
      if (doc.exists) {
        return Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar pedido: $e');
      return null;
    }
  }

  // Atualizar status do pedido
  Future<void> atualizarStatusPedido(String pedidoId, StatusPedido novoStatus) async {
    try {
      final updates = <String, dynamic>{
        'status': novoStatus.name,
      };

      // Adicionar timestamps específicos baseados no status
      switch (novoStatus) {
        case StatusPedido.confirmado:
          updates['dataConfirmacao'] = DateTime.now().toIso8601String();
          break;
        case StatusPedido.entregue:
          updates['dataEntrega'] = DateTime.now().toIso8601String();
          break;
        default:
          break;
      }

      await _firestore.collection(_colecao).doc(pedidoId).update(updates);
      print('Status do pedido atualizado: $pedidoId -> ${novoStatus.name}');
    } catch (e) {
      print('Erro ao atualizar status do pedido: $e');
      throw Exception('Erro ao atualizar status do pedido: $e');
    }
  }

  // Cancelar pedido
  Future<void> cancelarPedido(String pedidoId) async {
    try {
      await _firestore.collection(_colecao).doc(pedidoId).update({
        'status': StatusPedido.cancelado.name,
      });
      print('Pedido cancelado: $pedidoId');
    } catch (e) {
      print('Erro ao cancelar pedido: $e');
      throw Exception('Erro ao cancelar pedido: $e');
    }
  }

  // Adicionar código de rastreamento
  Future<void> adicionarCodigoRastreamento(String pedidoId, String codigo) async {
    try {
      await _firestore.collection(_colecao).doc(pedidoId).update({
        'codigoRastreamento': codigo,
      });
      print('Código de rastreamento adicionado: $pedidoId -> $codigo');
    } catch (e) {
      print('Erro ao adicionar código de rastreamento: $e');
      throw Exception('Erro ao adicionar código de rastreamento: $e');
    }
  }

  // Stream de pedidos do usuário (tempo real)
  Stream<List<Pedido>> pedidosUsuarioStream(String usuarioId) {
    return _firestore
        .collection(_colecao)
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Stream de pedido específico (tempo real)
  Stream<Pedido?> pedidoStream(String pedidoId) {
    return _firestore
        .collection(_colecao)
        .doc(pedidoId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Buscar pedidos por status
  Future<List<Pedido>> buscarPedidosPorStatus(String usuarioId, StatusPedido status) async {
    try {
      final querySnapshot = await _firestore
          .collection(_colecao)
          .where('usuarioId', isEqualTo: usuarioId)
          .where('status', isEqualTo: status.name)
          .orderBy('dataCriacao', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Erro ao buscar pedidos por status: $e');
      return [];
    }
  }

  // Buscar pedidos em andamento
  Future<List<Pedido>> buscarPedidosEmAndamento(String usuarioId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_colecao)
          .where('usuarioId', isEqualTo: usuarioId)
          .where('status', whereIn: [
            StatusPedido.confirmado.name,
            StatusPedido.emPreparacao.name,
            StatusPedido.emEntrega.name,
          ])
          .orderBy('dataCriacao', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Erro ao buscar pedidos em andamento: $e');
      return [];
    }
  }

  // Estatísticas do usuário
  Future<Map<String, dynamic>> estatisticasUsuario(String usuarioId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_colecao)
          .where('usuarioId', isEqualTo: usuarioId)
          .get();

      final pedidos = querySnapshot.docs.map((doc) {
        return Pedido.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      int totalPedidos = pedidos.length;
      int pedidosPendentes = pedidos.where((p) => p.status == StatusPedido.pendente).length;
      int pedidosEmAndamento = pedidos.where((p) => p.estaEmAndamento).length;
      int pedidosEntregues = pedidos.where((p) => p.foiEntregue).length;
      int pedidosCancelados = pedidos.where((p) => p.foiCancelado).length;
      double valorTotal = pedidos.where((p) => p.foiEntregue).fold(0.0, (soma, p) => soma + p.total);

      return {
        'totalPedidos': totalPedidos,
        'pedidosPendentes': pedidosPendentes,
        'pedidosEmAndamento': pedidosEmAndamento,
        'pedidosEntregues': pedidosEntregues,
        'pedidosCancelados': pedidosCancelados,
        'valorTotal': valorTotal,
      };
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
} 