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

  CarrinhoProvider({required this.userId}) {
    // Carregar carrinho automaticamente quando o provider é criado
    if (userId.isNotEmpty) {
      carregarCarrinho();
    } else {
      _carregado = true;
    }
  }

  List<CarrinhoItem> get itens => List.unmodifiable(_itens);
  double get total => _itens.fold(0, (soma, item) => soma + item.subtotal);
  int get quantidadeTotal => _itens.fold(0, (soma, item) => soma + item.quantidade);
  bool get carregado => _carregado;

  // Buscar carrinho do Firestore (uma vez)
  Future<void> carregarCarrinho() async {
    if (userId.isEmpty) {
      _itens = [];
      _carregado = true;
      notifyListeners();
      return;
    }
    
    try {
      print('Carregando carrinho para usuário: $userId');
      final doc = await _firestore.collection(_colecao).doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final itensFirestore = data['itens'] as List<dynamic>? ?? [];
        _itens = itensFirestore.map((item) => CarrinhoItem(
          produto: Produto.fromMap(item['produto']),
          quantidade: item['quantidade'] ?? 1,
        )).toList();
        print('Carrinho carregado com ${_itens.length} itens');
      } else {
        _itens = [];
        print('Carrinho não encontrado para usuário: $userId');
      }
    } catch (e) {
      print('Erro ao carregar carrinho: $e');
      _itens = [];
    }
    _carregado = true;
    notifyListeners();
  }

  // Stream do carrinho (tempo real) - DESABILITADO para evitar conflitos
  // Usando apenas estado local para melhor performance
  Stream<List<CarrinhoItem>> carrinhoStream() {
    if (userId.isEmpty) {
      return Stream.value([]);
    }
    
    // Retorna stream do estado local em vez do Firestore
    return Stream.value(_itens);
  }

  Future<void> _salvarCarrinho() async {
    if (userId.isEmpty) {
      print('Tentativa de salvar carrinho sem userId');
      return;
    }
    
    try {
      final itensFirestore = _itens.map((item) => {
        'produto': item.produto.toMap(),
        'quantidade': item.quantidade,
      }).toList();
      await _firestore.collection(_colecao).doc(userId).set({
        'itens': itensFirestore,
      });
      print('Carrinho salvo com sucesso para usuário: $userId (${_itens.length} itens)');
    } catch (e) {
      print('Erro ao salvar carrinho: $e');
    }
  }

  void adicionarProduto(Produto produto) {
    if (userId.isEmpty) {
      print('Tentativa de adicionar produto sem userId');
      return;
    }
    
    print('Adicionando produto: ${produto.nome} para usuário: $userId');
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);
    if (index >= 0) {
      _itens[index].quantidade++;
      print('Produto já existe, aumentando quantidade para: ${_itens[index].quantidade}');
    } else {
      _itens.add(CarrinhoItem(produto: produto));
      print('Novo produto adicionado ao carrinho');
    }
    
    // Atualizar UI imediatamente
    notifyListeners();
    
    // Salvar no Firestore em background (sem aguardar)
    _salvarCarrinho();
  }

  void removerProduto(Produto produto) {
    if (userId.isEmpty) return;
    
    _itens.removeWhere((item) => item.produto.id == produto.id);
    
    // Atualizar UI imediatamente
    notifyListeners();
    
    // Salvar no Firestore em background (sem aguardar)
    _salvarCarrinho();
  }

  void alterarQuantidade(Produto produto, int quantidade) {
    if (userId.isEmpty) return;
    
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);
    if (index >= 0) {
      if (quantidade <= 0) {
        _itens.removeAt(index);
      } else {
        _itens[index].quantidade = quantidade;
      }
      
      // Atualizar UI imediatamente
      notifyListeners();
      
      // Salvar no Firestore em background (sem aguardar)
      _salvarCarrinho();
    }
  }

  void limparCarrinho() {
    if (userId.isEmpty) return;
    
    _itens.clear();
    
    // Atualizar UI imediatamente
    notifyListeners();
    
    // Salvar no Firestore em background (sem aguardar)
    _salvarCarrinho();
  }
} 