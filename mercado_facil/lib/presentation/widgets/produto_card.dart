import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/produto.dart';
import '../../core/theme/app_theme.dart';

class ProdutoCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback? onAdicionarAoCarrinho;
  final VoidCallback? onToggleFavorito;

  const ProdutoCard({
    super.key,
    required this.produto,
    this.onAdicionarAoCarrinho,
    this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Função para abrir modal de detalhes do produto
    void _showProductModal() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: produto.imagemUrl,
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      width: 180,
                      color: colorScheme.tertiary.withOpacity(0.1),
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      width: 180,
                      color: colorScheme.tertiary.withOpacity(0.15),
                      child: Icon(Icons.image, color: colorScheme.tertiary, size: 60),
                    ),
                    memCacheWidth: 400,
                    memCacheHeight: 400,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                produto.nome,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (produto.precoPromocional != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R\$ ${produto.preco.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'R\$ ${produto.precoPromocional!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              if (produto.descricao != null && produto.descricao!.isNotEmpty)
                Text(
                  produto.descricao!,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: onAdicionarAoCarrinho,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_shopping_cart, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Adicionar ao carrinho'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // Envolver o conteúdo do card em GestureDetector para abrir o modal
    return GestureDetector(
      onTap: _showProductModal,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(8),
        color: colorScheme.background,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagem
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: produto.imagemUrl.isNotEmpty
                          ? Image.network(
                              produto.imagemUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(Icons.image, color: colorScheme.primary, size: 32),
                              ),
                            )
                          : Center(
                              child: Icon(Icons.image, color: colorScheme.primary, size: 32),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produto.nome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: colorScheme.onBackground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${(produto.precoPromocional ?? produto.preco).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: produto.precoPromocional != null
                          ? Colors.red.shade800
                          : Colors.green.shade700,
                      decoration: produto.precoPromocional != null
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (produto.precoPromocional != null)
                    Text(
                      'R\$ ${produto.precoPromocional!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorScheme.secondary,
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onAdicionarAoCarrinho,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          const Text('Adicionar', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tag de destaque alinhada à borda do card (fora da imagem)
            if (produto.destaque != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: produto.destaque == 'oferta'
                        ? Colors.red.shade800
                        : produto.destaque == 'mais vendido'
                            ? Colors.orange.shade800
                            : Colors.blue.shade800,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    produto.destaque == 'oferta'
                        ? 'OFERTA'
                        : produto.destaque == 'mais vendido'
                            ? 'MAIS VENDIDO'
                            : 'NOVO',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            // Ícone de favoritos alinhado à borda do card (fora da imagem)
            if (onToggleFavorito != null)
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onToggleFavorito,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        produto.favorito == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: produto.favorito == true
                            ? Colors.red.shade800
                            : Colors.grey.shade400,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProdutoCardSkeleton extends StatelessWidget {
  const ProdutoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Skeleton da imagem
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 110,
              color: colorScheme.tertiary.withOpacity(0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Skeleton do nome
                Container(
                  height: 16,
                  width: 80,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                // Skeleton do preço
                Container(
                  height: 16,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                // Skeleton do botão
                Container(
                  height: 36,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 