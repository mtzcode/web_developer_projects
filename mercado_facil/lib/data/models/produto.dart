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