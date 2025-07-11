import 'package:flutter/material.dart';
import '../../data/models/produto.dart';
import '../../core/theme/app_theme.dart';

class ProdutoCard extends StatefulWidget {
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
  State<ProdutoCard> createState() => _ProdutoCardState();
}

class _ProdutoCardState extends State<ProdutoCard> {
  double _scale = 1.0;
  double _elevation = 18;
  bool _hovering = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.97;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onHover(bool hovering) {
    setState(() {
      _hovering = hovering;
      _elevation = hovering ? 28 : 18;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOferta = widget.produto.destaque == 'oferta';
    final isMaisVendido = widget.produto.destaque == 'mais vendido';
    final isNovo = widget.produto.destaque == 'novo';
    return Semantics(
      label: 'Produto: ${widget.produto.nome}. Preço: R\$${(widget.produto.precoPromocional ?? widget.produto.preco).toStringAsFixed(2)}.'
        '${isOferta ? ' Em oferta.' : ''}'
        '${isMaisVendido ? ' Mais vendido.' : ''}'
        '${isNovo ? ' Novo.' : ''}',
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (context) {
                return Padding(
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
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            widget.produto.imagemUrl,
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 180,
                              width: 180,
                              color: colorScheme.tertiary.withOpacity(0.15),
                              child: Icon(Icons.image, color: colorScheme.tertiary, size: 60),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.produto.nome,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (widget.produto.precoPromocional != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'R\$ ${widget.produto.preco.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'R\$ ${widget.produto.precoPromocional!.toStringAsFixed(2)}',
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
                          'R\$ ${widget.produto.preco.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16),
                      if (widget.produto.descricao != null && widget.produto.descricao!.isNotEmpty)
                        Text(
                          widget.produto.descricao!,
                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: widget.onAdicionarAoCarrinho,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.produtoButtonColor,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Adicionar ao carrinho'),
                        ),
          ),
        ],
      ),
                );
              },
            );
          },
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: _elevation,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Imagem maior, ocupando o topo
                      Semantics(
                        label: 'Imagem do produto ${widget.produto.nome}',
              child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                child: Image.network(
                            widget.produto.imagemUrl,
                            height: 110,
                            width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 110,
                                color: colorScheme.tertiary.withOpacity(0.15),
                                child: Center(
                      child: Icon(
                        Icons.image,
                        color: colorScheme.tertiary,
                        size: 40,
                                  ),
                      ),
                    );
                  },
                ),
              ),
            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
            // Nome do produto
                            Semantics(
                              header: true,
                              child: Text(
                                widget.produto.nome,
              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
                              ),
            ),
                            const SizedBox(height: 4),
            // Preço
                            if (widget.produto.precoPromocional != null)
                              Row(
                                children: [
                                  Semantics(
                                    label: 'Preço original R\$${widget.produto.preco.toStringAsFixed(2)}',
                                    child: Text(
                                      'R\$ ${widget.produto.preco.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Semantics(
                                    label: 'Preço promocional R\$${widget.produto.precoPromocional!.toStringAsFixed(2)}',
                                    child: Text(
                                      'R\$ ${widget.produto.precoPromocional!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade800, // Contraste melhor
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Semantics(
                                label: 'Preço R\$${widget.produto.preco.toStringAsFixed(2)}',
                                child: Text(
                                  'R\$ ${widget.produto.preco.toStringAsFixed(2)}',
              style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
                              ),
                            const SizedBox(height: 8),
                            // Botão de adicionar ao carrinho
                            Semantics(
                              button: true,
                              label: 'Adicionar ${widget.produto.nome} ao carrinho',
                              child: SizedBox(
              width: double.infinity,
              height: 36,
                                child: ElevatedButton(
                                  onPressed: widget.onAdicionarAoCarrinho,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.produtoButtonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  child: const Text('Adicionar'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.produto.destaque != null)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Semantics(
                        label: widget.produto.destaque == 'oferta'
                            ? 'Produto em oferta'
                            : widget.produto.destaque == 'mais vendido'
                                ? 'Produto mais vendido'
                                : 'Produto novo',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.produto.destaque == 'oferta'
                                ? Colors.red.shade800 // Contraste melhor
                                : widget.produto.destaque == 'mais vendido'
                                    ? Colors.orange.shade800
                                    : Colors.blue.shade800,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.produto.destaque == 'oferta'
                                ? 'OFERTA'
                                : widget.produto.destaque == 'mais vendido'
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
                    ),
                  // Botão de favorito/coração
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.produto.favorito = !widget.produto.favorito;
                        });
                        if (widget.onToggleFavorito != null) {
                          widget.onToggleFavorito!();
                        }
                      },
                      child: Semantics(
                        label: widget.produto.favorito ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                        button: true,
                        child: Icon(
                          widget.produto.favorito ? Icons.favorite : Icons.favorite_border,
                          color: widget.produto.favorito ? Colors.red : Colors.grey.shade400,
                          size: 28,
                        ),
                ),
              ),
            ),
          ],
        ),
            ),
          ),
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