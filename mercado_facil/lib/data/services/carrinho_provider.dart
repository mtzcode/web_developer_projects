import 'package:flutter/material.dart';
import '../models/carrinho_item.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final List<CarrinhoItem> _itens = [];

  List<CarrinhoItem> get itens => List.unmodifiable(_itens);

  double get total => _itens.fold(0, (soma, item) => soma + item.subtotal);

  void adicionarProduto(Produto produto) {
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);
    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(CarrinhoItem(produto: produto));
    }
    notifyListeners();
  }

  void removerProduto(Produto produto) {
    _itens.removeWhere((item) => item.produto.id == produto.id);
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
      notifyListeners();
    }
  }

  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
} 