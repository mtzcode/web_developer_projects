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
} 