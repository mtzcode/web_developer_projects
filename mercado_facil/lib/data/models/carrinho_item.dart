import 'produto.dart';

class CarrinhoItem {
  final Produto produto;
  int quantidade;

  CarrinhoItem({required this.produto, this.quantidade = 1});

  double get subtotal => (produto.precoPromocional ?? produto.preco) * quantidade;
} 