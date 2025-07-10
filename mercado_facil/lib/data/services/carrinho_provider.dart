import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/carrinho_item.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _colecao = 'carrinhos';

  List<CarrinhoItem> _itens = [];
  bool _carregado = false;

  CarrinhoProvider({required this.userId});

  List<CarrinhoItem> get itens => List.unmodifiable(_itens);
  double get total => _itens.fold(0, (soma, item) => soma + item.subtotal);
  bool get carregado => _carregado;

  // Buscar carrinho do Firestore (uma vez)
  Future<void> carregarCarrinho() async {
    final doc = await _firestore.collection(_colecao).doc(userId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final itensFirestore = data['itens'] as List<dynamic>? ?? [];
      _itens = itensFirestore.map((item) => CarrinhoItem(
        produto: Produto.fromMap(item['produto']),
        quantidade: item['quantidade'] ?? 1,
      )).toList();
    } else {
      _itens = [];
    }
    _carregado = true;
    notifyListeners();
  }

  // Stream do carrinho (tempo real)
  Stream<List<CarrinhoItem>> carrinhoStream() {
    return _firestore.collection(_colecao).doc(userId).snapshots().map((doc) {
      if (!doc.exists) return [];
      final data = doc.data() as Map<String, dynamic>;
      final itensFirestore = data['itens'] as List<dynamic>? ?? [];
      return itensFirestore.map((item) => CarrinhoItem(
        produto: Produto.fromMap(item['produto']),
        quantidade: item['quantidade'] ?? 1,
      )).toList();
    });
  }

  Future<void> _salvarCarrinho() async {
    final itensFirestore = _itens.map((item) => {
      'produto': item.produto.toMap(),
      'quantidade': item.quantidade,
    }).toList();
    await _firestore.collection(_colecao).doc(userId).set({
      'itens': itensFirestore,
    });
  }

  void adicionarProduto(Produto produto) {
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);
    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(CarrinhoItem(produto: produto));
    }
    _salvarCarrinho();
    notifyListeners();
  }

  void removerProduto(Produto produto) {
    _itens.removeWhere((item) => item.produto.id == produto.id);
    _salvarCarrinho();
    notifyListeners();
  }

  void alterarQuantidade(Produto produto, int quantidade) {
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);
    if (index >= 0) {
      if (quantidade <= 0) {
        _itens.removeAt(index);
      } else {
        _itens[index].quantidade = quantidade;
      }
      _salvarCarrinho();
      notifyListeners();
    }
  }

  void limparCarrinho() {
    _itens.clear();
    _salvarCarrinho();
    notifyListeners();
  }
} 