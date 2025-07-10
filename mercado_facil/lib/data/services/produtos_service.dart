import '../models/produto.dart';
import 'cache_service.dart';
import 'memory_cache_service.dart';
import 'firestore_service.dart';

class ProdutosService {
  static final FirestoreService _firestoreService = FirestoreService();

  // Dados mock para fallback
  static List<Produto> getProdutosMock() {
    return [
      Produto(
        id: '1',
        nome: 'Arroz Integral',
        preco: 8.50,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Arroz',
        categoria: 'Grãos',
        destaque: 'oferta',
        precoPromocional: 6.99,
        favorito: false,
      ),
      Produto(
        id: '2',
        nome: 'Feijão Preto',
        preco: 6.90,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Feijão',
        categoria: 'Grãos',
        destaque: 'oferta',
        precoPromocional: 5.49,
        favorito: false,
      ),
      Produto(
        id: '3',
        nome: 'Leite Integral',
        preco: 4.20,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Leite',
        categoria: 'Laticínios',
        destaque: 'novo',
        favorito: false,
      ),
      Produto(
        id: '4',
        nome: 'Pão de Forma',
        preco: 5.80,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Pão',
        categoria: 'Pães',
        favorito: false,
      ),
      Produto(
        id: '5',
        nome: 'Banana Prata',
        preco: 3.50,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Banana',
        categoria: 'Frutas',
        destaque: 'mais vendido',
        favorito: false,
      ),
      Produto(
        id: '6',
        nome: 'Tomate',
        preco: 2.80,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Tomate',
        categoria: 'Verduras',
        favorito: false,
      ),
      Produto(
        id: '7',
        nome: 'Coca-Cola 2L',
        preco: 7.90,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Refrigerante',
        categoria: 'Bebidas',
        destaque: 'novo',
        favorito: false,
      ),
      Produto(
        id: '8',
        nome: 'Sabão em Pó',
        preco: 12.50,
        imagemUrl: 'https://via.placeholder.com/150x150/64ba01/ffffff?text=Sabão',
        categoria: 'Limpeza',
        favorito: false,
      ),
    ];
  }

  // Carrega produtos com cache inteligente e Firestore
  static Future<List<Produto>> carregarProdutosComCache({bool forcarAtualizacao = false}) async {
    try {
      // Se não forçar atualização, tenta carregar do cache primeiro
      if (!forcarAtualizacao) {
        // Tenta cache local (shared_preferences)
        try {
          final temCache = await CacheService.temCache();
          final cacheValido = await CacheService.isCacheValido();
          
          if (temCache && cacheValido) {
            final produtosCache = await CacheService.carregarProdutos();
            if (produtosCache.isNotEmpty) {
              print('Produtos carregados do cache local');
              return produtosCache;
            }
          }
        } catch (cacheError) {
          print('Erro ao acessar cache local: $cacheError');
        }

        // Tenta cache em memória como fallback
        if (MemoryCacheService.temCache() && MemoryCacheService.isCacheValido()) {
          final produtosCache = MemoryCacheService.carregarProdutos();
          if (produtosCache.isNotEmpty) {
            print('Produtos carregados do cache em memória');
            return produtosCache;
          }
        }
      }

      // Se não tem cache válido ou forçou atualização, carrega do Firestore
      print('Carregando produtos do Firestore...');
      final produtos = await _carregarProdutosDoFirestore();
      
      // Salva no cache local (tenta, mas não falha se der erro)
      if (produtos.isNotEmpty) {
        try {
          await CacheService.salvarProdutos(produtos);
          print('Produtos salvos no cache local');
        } catch (cacheError) {
          print('Erro ao salvar no cache local: $cacheError');
        }

        // Sempre salva no cache em memória como backup
        MemoryCacheService.salvarProdutos(produtos);
      }
      
      return produtos;
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      
      // Fallback para cache local mesmo que expirado
      try {
        final produtosCache = await CacheService.carregarProdutos();
        if (produtosCache.isNotEmpty) {
          print('Usando cache local expirado como fallback');
          return produtosCache;
        }
      } catch (cacheError) {
        print('Erro ao carregar cache local como fallback: $cacheError');
      }

      // Fallback para cache em memória
      if (MemoryCacheService.temCache()) {
        final produtosCache = MemoryCacheService.carregarProdutos();
        if (produtosCache.isNotEmpty) {
          print('Usando cache em memória como fallback');
          return produtosCache;
        }
      }
      
      // Último fallback: dados mock
      print('Usando dados mock como fallback');
      return getProdutosMock();
    }
  }

  // Carrega produtos do Firestore
  static Future<List<Produto>> _carregarProdutosDoFirestore() async {
    try {
      final produtosData = await _firestoreService.getProdutos();
      
      if (produtosData.isEmpty) {
        print('Nenhum produto encontrado no Firestore, usando dados mock');
        return getProdutosMock();
      }

      return produtosData;
    } catch (e) {
      print('Erro ao carregar produtos do Firestore: $e');
      throw e;
    }
  }

  static Future<List<Produto>> getProdutosPaginados({required int page, int pageSize = 8, bool forcarAtualizacao = false}) async {
    final todos = await carregarProdutosComCache(forcarAtualizacao: forcarAtualizacao);
    final start = (page - 1) * pageSize;
    if (start >= todos.length) return [];
    final end = (start + pageSize) > todos.length ? todos.length : (start + pageSize);
    return todos.sublist(start, end);
  }

  // Buscar produtos por categoria
  static Future<List<Produto>> getProdutosPorCategoria(String categoria, {bool forcarAtualizacao = false}) async {
    try {
      final produtos = await carregarProdutosComCache(forcarAtualizacao: forcarAtualizacao);
      return produtos.where((produto) => produto.categoria == categoria).toList();
    } catch (e) {
      print('Erro ao buscar produtos por categoria: $e');
      return [];
    }
  }

  // Buscar produtos por nome
  static Future<List<Produto>> buscarProdutos(String query, {bool forcarAtualizacao = false}) async {
    try {
      final produtos = await carregarProdutosComCache(forcarAtualizacao: forcarAtualizacao);
      final queryLower = query.toLowerCase();
      
      return produtos.where((produto) => 
        produto.nome.toLowerCase().contains(queryLower) ||
        (produto.categoria?.toLowerCase()?.contains(queryLower) ?? false)
      ).toList();
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      return [];
    }
  }

  // Buscar produtos em destaque
  static Future<List<Produto>> getProdutosDestaque({bool forcarAtualizacao = false}) async {
    try {
      final produtos = await carregarProdutosComCache(forcarAtualizacao: forcarAtualizacao);
      return produtos.where((produto) => produto.destaque != null).toList();
    } catch (e) {
      print('Erro ao buscar produtos em destaque: $e');
      return [];
    }
  }

  // Método para atualizar favoritos no cache
  static Future<void> atualizarFavorito(String produtoId, bool favorito) async {
    // Atualiza no cache local
    try {
      final produtos = await CacheService.carregarProdutos();
      final index = produtos.indexWhere((p) => p.id == produtoId);
      
      if (index != -1) {
        produtos[index] = produtos[index].copyWith(favorito: favorito);
        await CacheService.salvarProdutos(produtos);
      }
    } catch (e) {
      print('Erro ao atualizar favorito no cache local: $e');
    }

    // Atualiza no cache em memória
    MemoryCacheService.atualizarFavorito(produtoId, favorito);
  }

  // Método para limpar cache
  static Future<void> limparCache() async {
    try {
      await CacheService.limparCache();
    } catch (e) {
      print('Erro ao limpar cache local: $e');
    }
    MemoryCacheService.limparCache();
  }

  // Método para obter informações do cache
  static Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      return await CacheService.getCacheInfo();
    } catch (e) {
      print('Erro ao obter info do cache local: $e');
      return MemoryCacheService.getCacheInfo();
    }
  }

  // Migrar dados mock para Firestore
  static Future<void> migrarDadosMock() async {
    try {
      print('Iniciando migração de dados mock para Firestore...');
      final produtosMock = getProdutosMock();
      
      for (final produto in produtosMock) {
        await _firestoreService.adicionarProduto(produto.toMap());
      }
      
      print('Migração concluída com sucesso!');
    } catch (e) {
      print('Erro na migração: $e');
      throw e;
    }
  }

  // Limpar todos os produtos do Firestore
  static Future<void> limparProdutosFirestore() async {
    try {
      await _firestoreService.limparProdutos();
      print('Produtos removidos do Firestore');
    } catch (e) {
      print('Erro ao limpar produtos: $e');
      throw e;
    }
  }
} 