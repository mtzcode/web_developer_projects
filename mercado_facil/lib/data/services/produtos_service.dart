import '../models/produto.dart';

class ProdutosService {
  static List<Produto> getProdutos() {
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

  static Future<List<Produto>> getProdutosPaginados({required int page, int pageSize = 8}) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 700));
    final todos = getProdutos();
    final start = (page - 1) * pageSize;
    if (start >= todos.length) return [];
    final end = (start + pageSize) > todos.length ? todos.length : (start + pageSize);
    return todos.sublist(start, end);
  }
} 