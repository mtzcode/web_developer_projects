import 'package:flutter/material.dart';
import '../../data/services/produtos_service.dart';
import '../../data/datasources/memory_cache_service.dart';

class CacheStatusWidget extends StatelessWidget {
  const CacheStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ProdutosService.getCacheInfo(),
      builder: (context, snapshot) {
        Map<String, dynamic> cacheInfo;
        
        if (snapshot.hasData) {
          cacheInfo = snapshot.data!;
        } else {
          // Fallback para cache em memória
          cacheInfo = MemoryCacheService.getCacheInfo();
        }

        if (!cacheInfo['temCache']) {
          return const SizedBox.shrink();
        }

        final isValid = cacheInfo['valido'] as bool;
        final productCount = cacheInfo['quantidadeProdutos'] as int;
        final lastUpdate = cacheInfo['ultimaAtualizacao'] as DateTime?;

        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isValid ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isValid ? Colors.green.shade200 : Colors.orange.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isValid ? Icons.cloud_done : Icons.cloud_off,
                color: isValid ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isValid ? 'Cache Atualizado' : 'Cache Expirado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isValid ? Colors.green.shade700 : Colors.orange.shade700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '$productCount produtos',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                    if (lastUpdate != null)
                      Text(
                        'Atualizado: ${_formatarData(lastUpdate)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 16),
                onPressed: () {
                  _mostrarOpcoesCache(context);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatarData(DateTime data) {
    final now = DateTime.now();
    final difference = now.difference(data);

    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}min atrás';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h atrás';
    } else {
      return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}';
    }
  }

  void _mostrarOpcoesCache(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gerenciar Cache',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Atualizar Produtos'),
              subtitle: const Text('Força atualização da API'),
              onTap: () {
                Navigator.pop(context);
                _atualizarProdutos(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Limpar Cache'),
              subtitle: const Text('Remove todos os dados salvos'),
              onTap: () {
                Navigator.pop(context);
                _limparCache(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _atualizarProdutos(BuildContext context) async {
    try {
      await ProdutosService.carregarProdutosComCache(forcarAtualizacao: true);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produtos atualizados com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _limparCache(BuildContext context) async {
    try {
      await ProdutosService.limparCache();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache limpo com sucesso!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao limpar cache: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 