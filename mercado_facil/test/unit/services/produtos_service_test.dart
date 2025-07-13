import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mercado_facil/data/services/produtos_service.dart';
import 'package:mercado_facil/data/services/firestore_service.dart';
import 'package:mercado_facil/data/services/cache_service.dart';
import 'package:mercado_facil/data/services/memory_cache_service.dart';
import 'package:mercado_facil/data/models/produto.dart';

// Gerar mocks
@GenerateMocks([FirestoreService, CacheService, MemoryCacheService])
import 'produtos_service_test.mocks.dart';

void main() {
  group('ProdutosService Tests', () {
    late MockFirestoreService mockFirestoreService;
    late MockCacheService mockCacheService;
    late MockMemoryCacheService mockMemoryCacheService;
    late List<Produto> produtosMock;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
      mockCacheService = MockCacheService();
      mockMemoryCacheService = MockMemoryCacheService();
      
      produtosMock = [
        Produto(
          id: '1',
          nome: 'Arroz Integral',
          preco: 8.50,
          imagemUrl: 'https://picsum.photos/150/150?random=1',
          categoria: 'Grãos',
          destaque: 'oferta',
          precoPromocional: 6.99,
        ),
        Produto(
          id: '2',
          nome: 'Feijão Preto',
          preco: 6.90,
          imagemUrl: 'https://picsum.photos/150/150?random=2',
          categoria: 'Grãos',
          destaque: 'oferta',
          precoPromocional: 5.49,
        ),
      ];
    });

    group('getProdutosMock', () {
      test('deve retornar lista de produtos mock válida', () {
        final produtos = ProdutosService.getProdutosMock();

        expect(produtos, isNotEmpty);
        expect(produtos.length, equals(8));
        expect(produtos.first, isA<Produto>());
        expect(produtos.first.id, equals('1'));
        expect(produtos.first.nome, equals('Arroz Integral'));
      });

      test('deve ter produtos com diferentes destaques', () {
        final produtos = ProdutosService.getProdutosMock();
        final destaques = produtos
            .map((p) => p.destaque)
            .where((d) => d != null)
            .toSet();

        expect(destaques, contains('oferta'));
        expect(destaques, contains('novo'));
        expect(destaques, contains('mais vendido'));
      });

      test('deve ter produtos com e sem preço promocional', () {
        final produtos = ProdutosService.getProdutosMock();
        final comPromocao = produtos.where((p) => p.precoPromocional != null);
        final semPromocao = produtos.where((p) => p.precoPromocional == null);

        expect(comPromocao, isNotEmpty);
        expect(semPromocao, isNotEmpty);
      });
    });

    group('carregarProdutosComCache', () {
      test('deve carregar do cache local quando válido', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => true);
        when(mockCacheService.isCacheValido()).thenAnswer((_) async => true);
        when(mockCacheService.carregarProdutos()).thenAnswer((_) async => produtosMock);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, equals(produtosMock));
        verify(mockCacheService.temCache()).called(1);
        verify(mockCacheService.isCacheValido()).called(1);
        verify(mockCacheService.carregarProdutos()).called(1);
      });

      test('deve carregar do cache em memória quando cache local falha', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => false);
        when(mockMemoryCacheService.temCache()).thenReturn(true);
        when(mockMemoryCacheService.isCacheValido()).thenReturn(true);
        when(mockMemoryCacheService.carregarProdutos()).thenReturn(produtosMock);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, equals(produtosMock));
        verify(mockMemoryCacheService.temCache()).called(1);
        verify(mockMemoryCacheService.isCacheValido()).called(1);
        verify(mockMemoryCacheService.carregarProdutos()).called(1);
      });

      test('deve carregar do Firestore quando cache não é válido', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => false);
        when(mockMemoryCacheService.temCache()).thenReturn(false);
        when(mockFirestoreService.getProdutos()).thenAnswer((_) async => produtosMock);
        when(mockCacheService.salvarProdutos(any)).thenAnswer((_) async {});
        when(mockMemoryCacheService.salvarProdutos(any)).thenReturn(null);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutos()).called(1);
        verify(mockCacheService.salvarProdutos(produtosMock)).called(1);
        verify(mockMemoryCacheService.salvarProdutos(produtosMock)).called(1);
      });

      test('deve forçar atualização quando solicitado', () async {
        when(mockFirestoreService.getProdutos()).thenAnswer((_) async => produtosMock);
        when(mockCacheService.salvarProdutos(any)).thenAnswer((_) async {});
        when(mockMemoryCacheService.salvarProdutos(any)).thenReturn(null);

        final produtos = await ProdutosService.carregarProdutosComCache(forcarAtualizacao: true);

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutos()).called(1);
        verify(mockCacheService.salvarProdutos(produtosMock)).called(1);
        verify(mockMemoryCacheService.salvarProdutos(produtosMock)).called(1);
      });

      test('deve usar fallback para cache local quando Firestore falha', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => false);
        when(mockMemoryCacheService.temCache()).thenReturn(false);
        when(mockFirestoreService.getProdutos()).thenThrow(Exception('Erro de rede'));
        when(mockCacheService.carregarProdutos()).thenAnswer((_) async => produtosMock);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutos()).called(1);
        verify(mockCacheService.carregarProdutos()).called(1);
      });

      test('deve usar fallback para cache em memória quando Firestore e cache local falham', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => false);
        when(mockMemoryCacheService.temCache()).thenReturn(true);
        when(mockFirestoreService.getProdutos()).thenThrow(Exception('Erro de rede'));
        when(mockCacheService.carregarProdutos()).thenThrow(Exception('Erro de cache'));
        when(mockMemoryCacheService.carregarProdutos()).thenReturn(produtosMock);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutos()).called(1);
        verify(mockCacheService.carregarProdutos()).called(1);
        verify(mockMemoryCacheService.carregarProdutos()).called(1);
      });

      test('deve usar dados mock como último fallback', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => false);
        when(mockMemoryCacheService.temCache()).thenReturn(false);
        when(mockFirestoreService.getProdutos()).thenThrow(Exception('Erro de rede'));
        when(mockCacheService.carregarProdutos()).thenThrow(Exception('Erro de cache'));

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, isNotEmpty);
        expect(produtos.length, equals(8));
        expect(produtos.first.id, equals('1'));
        expect(produtos.first.nome, equals('Arroz Integral'));
      });
    });

    group('getProdutosPaginados', () {
      test('deve retornar produtos paginados do cache quando válido', () async {
        when(mockCacheService.isCacheValido()).thenAnswer((_) async => true);
        when(mockCacheService.carregarProdutos()).thenAnswer((_) async => produtosMock);

        final produtos = await ProdutosService.getProdutosPaginados(page: 1, pageSize: 1);

        expect(produtos.length, equals(1));
        expect(produtos.first.id, equals('1'));
      });

      test('deve retornar produtos paginados do Firestore quando cache não é válido', () async {
        when(mockCacheService.isCacheValido()).thenAnswer((_) async => false);
        when(mockFirestoreService.getProdutosPaginados(page: 1, pageSize: 8))
            .thenAnswer((_) async => produtosMock);

        final produtos = await ProdutosService.getProdutosPaginados(page: 1, pageSize: 8);

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutosPaginados(page: 1, pageSize: 8)).called(1);
      });

      test('deve forçar atualização quando solicitado', () async {
        when(mockFirestoreService.getProdutosPaginados(page: 1, pageSize: 8))
            .thenAnswer((_) async => produtosMock);

        final produtos = await ProdutosService.getProdutosPaginados(
          page: 1, 
          pageSize: 8, 
          forcarAtualizacao: true
        );

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutosPaginados(page: 1, pageSize: 8)).called(1);
      });

      test('deve retornar lista vazia para página inexistente', () async {
        when(mockCacheService.isCacheValido()).thenAnswer((_) async => true);
        when(mockCacheService.carregarProdutos()).thenAnswer((_) async => produtosMock);

        final produtos = await ProdutosService.getProdutosPaginados(page: 10, pageSize: 8);

        expect(produtos, isEmpty);
      });

      test('deve usar fallback para dados mock quando há erro', () async {
        when(mockCacheService.isCacheValido()).thenAnswer((_) async => false);
        when(mockFirestoreService.getProdutosPaginados(page: 1, pageSize: 8))
            .thenThrow(Exception('Erro de rede'));

        final produtos = await ProdutosService.getProdutosPaginados(page: 1, pageSize: 8);

        expect(produtos, isNotEmpty);
        expect(produtos.length, equals(8));
        expect(produtos.first.id, equals('1'));
      });

      test('deve calcular paginação corretamente', () async {
        final todosProdutos = List.generate(20, (index) => Produto(
          id: '${index + 1}',
          nome: 'Produto ${index + 1}',
          preco: 10.0,
          imagemUrl: 'https://example.com/produto${index + 1}.jpg',
        ));

        when(mockCacheService.isCacheValido()).thenAnswer((_) async => true);
        when(mockCacheService.carregarProdutos()).thenAnswer((_) async => todosProdutos);

        // Página 1
        final pagina1 = await ProdutosService.getProdutosPaginados(page: 1, pageSize: 5);
        expect(pagina1.length, equals(5));
        expect(pagina1.first.id, equals('1'));
        expect(pagina1.last.id, equals('5'));

        // Página 2
        final pagina2 = await ProdutosService.getProdutosPaginados(page: 2, pageSize: 5);
        expect(pagina2.length, equals(5));
        expect(pagina2.first.id, equals('6'));
        expect(pagina2.last.id, equals('10'));

        // Página 4 (última página parcial)
        final pagina4 = await ProdutosService.getProdutosPaginados(page: 4, pageSize: 5);
        expect(pagina4.length, equals(5));
        expect(pagina4.first.id, equals('16'));
        expect(pagina4.last.id, equals('20'));

        // Página 5 (inexistente)
        final pagina5 = await ProdutosService.getProdutosPaginados(page: 5, pageSize: 5);
        expect(pagina5, isEmpty);
      });
    });

    group('Tratamento de Erros', () {
      test('deve lidar com erro de cache local silenciosamente', () async {
        when(mockCacheService.temCache()).thenThrow(Exception('Erro de cache'));
        when(mockMemoryCacheService.temCache()).thenReturn(false);
        when(mockFirestoreService.getProdutos()).thenAnswer((_) async => produtosMock);
        when(mockCacheService.salvarProdutos(any)).thenAnswer((_) async {});
        when(mockMemoryCacheService.salvarProdutos(any)).thenReturn(null);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutos()).called(1);
      });

      test('deve lidar com erro ao salvar no cache silenciosamente', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => false);
        when(mockMemoryCacheService.temCache()).thenReturn(false);
        when(mockFirestoreService.getProdutos()).thenAnswer((_) async => produtosMock);
        when(mockCacheService.salvarProdutos(any)).thenThrow(Exception('Erro ao salvar'));
        when(mockMemoryCacheService.salvarProdutos(any)).thenReturn(null);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, equals(produtosMock));
        verify(mockFirestoreService.getProdutos()).called(1);
        verify(mockCacheService.salvarProdutos(produtosMock)).called(1);
        verify(mockMemoryCacheService.salvarProdutos(produtosMock)).called(1);
      });

      test('deve lidar com Firestore retornando lista vazia', () async {
        when(mockCacheService.temCache()).thenAnswer((_) async => false);
        when(mockMemoryCacheService.temCache()).thenReturn(false);
        when(mockFirestoreService.getProdutos()).thenAnswer((_) async => []);

        final produtos = await ProdutosService.carregarProdutosComCache();

        expect(produtos, isNotEmpty);
        expect(produtos.length, equals(8));
        expect(produtos.first.id, equals('1'));
      });
    });
  });
} 