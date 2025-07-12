class Produto {
  final String id;
  final String nome;
  final double preco;
  final String imagemUrl;
  final String? descricao;
  final String? categoria;
  final String? destaque; // 'mais vendido', 'novo' ou null
  final double? precoPromocional;
  bool favorito;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.imagemUrl,
    this.descricao,
    this.categoria,
    this.destaque,
    this.precoPromocional,
    bool? favorito,
  }) : favorito = favorito ?? false;

  // Método para criar uma cópia com campos modificados
  Produto copyWith({
    String? id,
    String? nome,
    double? preco,
    String? imagemUrl,
    String? descricao,
    String? categoria,
    String? destaque,
    double? precoPromocional,
    bool? favorito,
  }) {
    return Produto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      destaque: destaque ?? this.destaque,
      precoPromocional: precoPromocional ?? this.precoPromocional,
      favorito: favorito ?? this.favorito,
    );
  }

  // Converter Produto para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'imagemUrl': imagemUrl,
      'descricao': descricao,
      'categoria': categoria,
      'destaque': destaque,
      'precoPromocional': precoPromocional,
      'favorito': favorito,
    };
  }

  // Criar Produto a partir de Map (para carregar do Firestore)
  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      preco: (map['preco'] ?? 0.0).toDouble(),
      imagemUrl: map['imagemUrl'] ?? '',
      descricao: map['descricao'],
      categoria: map['categoria'],
      destaque: map['destaque'],
      precoPromocional: map['precoPromocional'] != null 
          ? (map['precoPromocional'] as num).toDouble() 
          : null,
      favorito: map['favorito'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Produto(id: $id, nome: $nome, preco: $preco, categoria: $categoria)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Produto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 

// Mock de produtos para testes de filtros, tags e favoritos
final List<Produto> produtosMock = [
  Produto(
    id: '1',
    nome: 'Arroz Integral',
    preco: 6.99,
    precoPromocional: 5.99,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Cereais',
    destaque: 'oferta',
    favorito: false,
  ),
  Produto(
    id: '2',
    nome: 'Feijão Preto',
    preco: 7.49,
    precoPromocional: 6.49,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Cereais',
    destaque: 'mais vendido',
    favorito: true,
  ),
  Produto(
    id: '3',
    nome: 'Leite Integral',
    preco: 4.20,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Laticínios',
    destaque: 'novo',
    favorito: false,
  ),
  Produto(
    id: '4',
    nome: 'Açúcar Refinado',
    preco: 3.10,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Açúcar',
    favorito: false,
  ),
  Produto(
    id: '5',
    nome: 'Óleo de Soja',
    preco: 8.99,
    precoPromocional: 7.99,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Óleos',
    destaque: 'oferta',
    favorito: true,
  ),
  Produto(
    id: '6',
    nome: 'Café Torrado',
    preco: 12.50,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Bebidas',
    destaque: 'mais vendido',
    favorito: false,
  ),
  Produto(
    id: '7',
    nome: 'Biscoito Recheado',
    preco: 2.99,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Snacks',
    destaque: 'novo',
    favorito: true,
  ),
  Produto(
    id: '8',
    nome: 'Sabonete',
    preco: 1.99,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Higiene',
    favorito: false,
  ),
  Produto(
    id: '9',
    nome: 'Detergente',
    preco: 2.50,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Limpeza',
    destaque: 'oferta',
    favorito: false,
  ),
  Produto(
    id: '10',
    nome: 'Queijo Mussarela',
    preco: 15.90,
    precoPromocional: 13.90,
    imagemUrl: 'https://via.placeholder.com/150',
    categoria: 'Laticínios',
    destaque: 'mais vendido',
    favorito: true,
  ),
]; 