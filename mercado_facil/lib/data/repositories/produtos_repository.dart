import '../datasources/firestore_service.dart';
import '../datasources/cache_service.dart';
import '../models/produto.dart';
import '../../core/utils/logger.dart';

/// Repository para gerenciar operações de produtos
/// Segue o padrão Repository da Clean Architecture
abstract class ProdutosRepository {
  /// Busca todos os produtos disponíveis
  Future<List<Produto>> buscarProdutos();
  
  /// Busca um produto específico por ID
  Future<Produto?> buscarProdutoPorId(String id);
  
  /// Busca produtos por categoria
  Future<List<Produto>> buscarProdutosPorCategoria(String categoria);
  
  /// Busca produtos por nome (busca textual)
  Future<List<Produto>> buscarProdutosPorNome(String nome);
}

class ProdutosRepositoryImpl implements ProdutosRepository {
  final FirestoreService _firestoreService;
  final CacheService _cacheService;
  final AppLogger _logger = AppLogger();

  ProdutosRepositoryImpl({
    required FirestoreService firestoreService,
    required CacheService cacheService,
  })  : _firestoreService = firestoreService,
        _cacheService = cacheService;

  @override
  Future<List<Produto>> buscarProdutos() async {
    try {
      _logger.info('Buscando produtos do repositório');
      
      // Primeiro tenta buscar do cache
      final produtosCache = await _cacheService.get<List<Produto>>('produtos');
      if (produtosCache != null) {
        _logger.info('Produtos encontrados no cache: ${produtosCache.length}');
        return produtosCache;
      }

      // Se não encontrar no cache, busca do Firestore
      final produtos = await _firestoreService.buscarProdutos();
      
      // Salva no cache por 5 minutos
      await _cacheService.set('produtos', produtos, const Duration(minutes: 5));
      
      _logger.info('Produtos carregados do Firestore: ${produtos.length}');
      return produtos;
    } catch (e) {
      _logger.error('Erro ao buscar produtos: $e');
      rethrow;
    }
  }

  @override
  Future<Produto?> buscarProdutoPorId(String id) async {
    try {
      _logger.info('Buscando produto por ID: $id');
      
      // Primeiro tenta buscar do cache
      final produtoCache = await _cacheService.get<Produto>('produto_$id');
      if (produtoCache != null) {
        _logger.info('Produto encontrado no cache');
        return produtoCache;
      }

      // Se não encontrar no cache, busca do Firestore
      final produto = await _firestoreService.buscarProdutoPorId(id);
      
      if (produto != null) {
        // Salva no cache por 10 minutos
        await _cacheService.set('produto_$id', produto, const Duration(minutes: 10));
      }
      
      _logger.info('Produto carregado do Firestore: ${produto?.nome ?? 'não encontrado'}');
      return produto;
    } catch (e) {
      _logger.error('Erro ao buscar produto por ID: $e');
      rethrow;
    }
  }

  @override
  Future<List<Produto>> buscarProdutosPorCategoria(String categoria) async {
    try {
      _logger.info('Buscando produtos por categoria: $categoria');
      
      // Primeiro tenta buscar do cache
      final produtosCache = await _cacheService.get<List<Produto>>('produtos_categoria_$categoria');
      if (produtosCache != null) {
        _logger.info('Produtos da categoria encontrados no cache: ${produtosCache.length}');
        return produtosCache;
      }

      // Se não encontrar no cache, busca do Firestore
      final produtos = await _firestoreService.buscarProdutosPorCategoria(categoria);
      
      // Salva no cache por 5 minutos
      await _cacheService.set('produtos_categoria_$categoria', produtos, const Duration(minutes: 5));
      
      _logger.info('Produtos da categoria carregados do Firestore: ${produtos.length}');
      return produtos;
    } catch (e) {
      _logger.error('Erro ao buscar produtos por categoria: $e');
      rethrow;
    }
  }

  @override
  Future<List<Produto>> buscarProdutosPorNome(String nome) async {
    try {
      _logger.info('Buscando produtos por nome: $nome');
      
      // Busca textual sempre vai para o Firestore
      final produtos = await _firestoreService.buscarProdutosPorNome(nome);
      
      _logger.info('Produtos encontrados por nome: ${produtos.length}');
      return produtos;
    } catch (e) {
      _logger.error('Erro ao buscar produtos por nome: $e');
      rethrow;
    }
  }
} 