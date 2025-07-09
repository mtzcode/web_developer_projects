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
} 