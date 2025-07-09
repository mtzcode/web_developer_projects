import 'package:flutter_test/flutter_test.dart';
import 'package:mercado_facil/data/services/produtos_service.dart';
import 'package:mercado_facil/data/models/produto.dart';

void main() {
  group('ProdutosService', () {
    test('deve retornar lista de produtos', () {
      final produtos = ProdutosService.getProdutos();
      
      expect(produtos, isA<List<Produto>>());
      expect(produtos.isNotEmpty, true);
    });

    test('deve retornar produtos paginados', () async {
      final produtos = await ProdutosService.getProdutosPaginados(page: 1, pageSize: 5);
      
      expect(produtos, isA<List<Produto>>());
      expect(produtos.length, lessThanOrEqualTo(5));
    });

    test('deve filtrar produtos por categoria', () {
      final todosProdutos = ProdutosService.getProdutos();
      final produtosFrutas = todosProdutos.where((p) => p.categoria == 'Frutas').toList();
      
      expect(produtosFrutas.every((p) => p.categoria == 'Frutas'), true);
    });

    test('deve filtrar produtos por destaque', () {
      final todosProdutos = ProdutosService.getProdutos();
      final produtosOferta = todosProdutos.where((p) => p.destaque == 'oferta').toList();
      
      expect(produtosOferta.every((p) => p.destaque == 'oferta'), true);
    });

    test('deve buscar produtos por nome', () {
      final todosProdutos = ProdutosService.getProdutos();
      final produtosComBanana = todosProdutos.where((p) => 
        p.nome.toLowerCase().contains('banana')).toList();
      
      expect(produtosComBanana.isNotEmpty, true);
    });

    test('deve retornar produtos com preço promocional', () {
      final todosProdutos = ProdutosService.getProdutos();
      final produtosComPromocao = todosProdutos.where((p) => 
        p.precoPromocional != null && p.precoPromocional! < p.preco).toList();
      
      expect(produtosComPromocao.isNotEmpty, true);
    });
  });
} 