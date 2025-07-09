import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/carrinho_provider.dart';

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final carrinhoProvider = Provider.of<CarrinhoProvider>(context);
    final carrinho = carrinhoProvider.itens;
    final total = carrinhoProvider.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: carrinho.isEmpty
            ? Center(
                child: Text(
                  'Seu carrinho está vazio! 🛒',
                  style: TextStyle(fontSize: 18, color: colorScheme.secondary),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: carrinho.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = carrinho[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.produto.imagemUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: colorScheme.tertiary.withOpacity(0.15),
                                    child: Icon(
                                      Icons.image,
                                      color: colorScheme.tertiary,
                                      size: 32,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.produto.nome,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'R\$ ${item.produto.preco.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Botões de quantidade
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: colorScheme.primary,
                                  onPressed: () {
                                    carrinhoProvider.alterarQuantidade(item.produto, item.quantidade - 1);
                                  },
                                ),
                                Text(
                                  '${item.quantidade}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: colorScheme.primary,
                                  onPressed: () {
                                    carrinhoProvider.alterarQuantidade(item.produto, item.quantidade + 1);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'R\$ ${(item.subtotal).toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Ícone de lixeira
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () {
                                carrinhoProvider.removerProduto(item.produto);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${item.produto.nome} removido do carrinho!',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Resumo do pedido
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ResumoLinha(
                          titulo: 'Subtotal',
                          valor: carrinhoProvider.total,
                        ),
                        _ResumoLinha(
                          titulo: 'Frete',
                          valor: 7.90,
                        ),
                        _ResumoLinha(
                          titulo: 'Desconto',
                          valor: -5.00,
                          valorCor: Colors.green,
                        ),
                        const Divider(height: 24),
                        _ResumoLinha(
                          titulo: 'Total',
                          valor: carrinhoProvider.total + 7.90 - 5.00,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.secondary),
                      ),
                      Text(
                        'R\$ ${total.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: carrinho.isEmpty ? null : () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      child: const Text('Finalizar compra'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ResumoLinha extends StatelessWidget {
  final String titulo;
  final double valor;
  final bool isTotal;
  final Color? valorCor;

  const _ResumoLinha({
    required this.titulo,
    required this.valor,
    this.isTotal = false,
    this.valorCor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 15,
              color: isTotal ? colorScheme.primary : colorScheme.secondary,
            ),
          ),
          Text(
            (valor < 0 ? '- ' : '') + 'R\$ ' + valor.abs().toStringAsFixed(2),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 15,
              color: valorCor ?? (isTotal ? colorScheme.primary : colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
} 