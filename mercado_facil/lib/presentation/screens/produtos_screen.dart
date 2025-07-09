import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../data/services/produtos_service.dart';
import '../widgets/produto_card.dart';
import '../../core/theme/app_theme.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../data/services/carrinho_provider.dart';
import '../../data/models/produto.dart';
import 'ofertas_screen.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ItemScrollController _categoriaScrollController = ItemScrollController();
  String _searchQuery = '';
  int _categoriaSelecionada = 0;
  List<String> categorias = [];
  List<String> _historicoBuscas = [];
  bool _showSuggestions = false;

  // Filtros avançados
  String? _categoriaFiltro;
  double _precoMin = 0;
  double _precoMax = 100;
  double _precoRangeMin = 0;
  double _precoRangeMax = 100;
  bool _filtrarOferta = false;
  bool _filtrarNovo = false;
  bool _filtrarMaisVendido = false;

  bool _loading = true;
  List<Produto> _produtosExibidos = [];
  int _paginaAtual = 1;
  bool _carregandoMais = false;
  bool _temMaisProdutos = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final produtos = ProdutosService.getProdutos();
    categorias = ['Todos'];
    categorias.addAll(produtos.map((p) => p.categoria ?? '').toSet().where((c) => c.isNotEmpty));
    // Inicializa faixa de preço
    final precos = produtos.map((p) => p.precoPromocional ?? p.preco).toList();
    _precoRangeMin = precos.reduce((a, b) => a < b ? a : b);
    _precoRangeMax = precos.reduce((a, b) => a > b ? a : b);
    _precoMin = _precoRangeMin;
    _precoMax = _precoRangeMax;
    _searchFocusNode.addListener(() {
      setState(() {
        _showSuggestions = _searchFocusNode.hasFocus;
      });
    });
    // Simula carregamento
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _loading = false);
    });
    _carregarMaisProdutos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_carregandoMais && _temMaisProdutos) {
        _carregarMaisProdutos();
      }
    });
  }

  void _selecionarCategoria(int index) {
    setState(() {
      _categoriaSelecionada = index;
    });
    _scrollToCategoria(index);
  }

  void _scrollToCategoria(int index) {
    if (_categoriaScrollController.isAttached) {
      _categoriaScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.35, // Tenta centralizar, mas respeita as extremidades
      );
    }
  }

  Future<void> _carregarMaisProdutos() async {
    setState(() => _carregandoMais = true);
    final novos = await ProdutosService.getProdutosPaginados(page: _paginaAtual, pageSize: 8);
    setState(() {
      if (novos.isEmpty) {
        _temMaisProdutos = false;
      } else {
        _produtosExibidos.addAll(novos);
        _paginaAtual++;
      }
      _carregandoMais = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Filtros e busca continuam funcionando normalmente, mas a lista exibida é _produtosExibidos filtrada
    final produtosFiltrados = _produtosExibidos.where((produto) {
      final matchNome = produto.nome.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategoria = _categoriaFiltro == null || (produto.categoria == _categoriaFiltro);
      final preco = produto.precoPromocional ?? produto.preco;
      final matchPreco = preco >= _precoMin && preco <= _precoMax;
      final matchOferta = !_filtrarOferta || (produto.destaque == 'oferta');
      final matchNovo = !_filtrarNovo || (produto.destaque == 'novo');
      final matchMaisVendido = !_filtrarMaisVendido || (produto.destaque == 'mais vendido');
      return matchNome && matchCategoria && matchPreco && matchOferta && matchNovo && matchMaisVendido;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Consumer<CarrinhoProvider>(
            builder: (context, carrinho, child) {
              int quantidade = carrinho.itens.fold(0, (soma, item) => soma + item.quantidade);
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, '/carrinho');
                    },
                  ),
                  if (quantidade > 0)
                    Positioned(
                      right: 8,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Text(
                          '$quantidade',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // DrawerHeader substituído por cabeçalho de usuário
            Container(
              color: colorScheme.primary,
              padding: const EdgeInsets.only(top: 32, bottom: 20, left: 16, right: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'João da Silva',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'joao@email.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Itens de navegação principais
            ListTile(
              leading: const Icon(Icons.storefront),
              title: const Text('Produtos'),
              onTap: () {
                Navigator.pop(context);
                // Já está na tela de produtos
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Meus Pedidos'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para a tela de pedidos
                // Navigator.pushNamed(context, '/pedidos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Carrinho'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/carrinho');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        List<Produto> favoritos = _produtosExibidos.where((p) => p.favorito).toList();
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('Meus Favoritos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 18),
                              if (favoritos.isEmpty)
                                const Center(child: Text('Nenhum produto favorito.'))
                              else
                                SizedBox(
                                  height: 350,
                                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8,
                                      crossAxisSpacing: 24,
                                      mainAxisSpacing: 24,
                                    ),
                                    itemCount: favoritos.length,
                                    itemBuilder: (context, index) {
                                      final produto = favoritos[index];
                                      return ProdutoCard(
                                        produto: produto,
                                        onAdicionarAoCarrinho: () {
                                          Provider.of<CarrinhoProvider>(context, listen: false).adicionarProduto(produto);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${produto.nome} adicionado ao carrinho!',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: colorScheme.primary,
                                            ),
                                          );
                                        },
                                        onToggleFavorito: () {
                                          setModalState(() {});
                                        },
                                        key: ValueKey(produto.id),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: const Text('Ofertas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OfertasScreen(produtos: _produtosExibidos),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Meus Dados'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para a tela de dados do usuário
                // Navigator.pushNamed(context, '/perfil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Endereços'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para a tela de endereços
                // Navigator.pushNamed(context, '/enderecos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notificacoes');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ajuda/Suporte'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para a tela de ajuda/suporte
                // Navigator.pushNamed(context, '/ajuda');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre o App'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para a tela sobre o app
                // Navigator.pushNamed(context, '/sobre');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de pesquisa + botão de filtros
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 53,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.search, color: Color(0xFF003938)),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                    _showSuggestions = true;
                                  });
                                },
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    setState(() {
                                      _searchQuery = value;
                                      _showSuggestions = false;
                                      // Atualiza histórico
                                      _historicoBuscas.remove(value);
                                      _historicoBuscas.insert(0, value);
                                      if (_historicoBuscas.length > 5) {
                                        _historicoBuscas = _historicoBuscas.sublist(0, 5);
                                      }
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Pesquisa',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_showSuggestions && (_searchQuery.isNotEmpty || _historicoBuscas.isNotEmpty))
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 53,
                          child: Material(
                            elevation: 4,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children: [
                                  if (_searchQuery.isNotEmpty)
                                    ...ProdutosService.getProdutos()
                                        .where((p) => p.nome.toLowerCase().contains(_searchQuery.toLowerCase()))
                                        .map((p) => ListTile(
                                              title: Text(p.nome),
                                              onTap: () {
                                                setState(() {
                                                  _searchController.text = p.nome;
                                                  _searchQuery = p.nome;
                                                  _showSuggestions = false;
                                                  // Atualiza histórico
                                                  _historicoBuscas.remove(p.nome);
                                                  _historicoBuscas.insert(0, p.nome);
                                                  if (_historicoBuscas.length > 5) {
                                                    _historicoBuscas = _historicoBuscas.sublist(0, 5);
                                                  }
                                                });
                                              },
                                            ))
                                        .toList(),
                                  if (_searchQuery.isEmpty && _historicoBuscas.isNotEmpty)
                                    ..._historicoBuscas.map((h) => ListTile(
                                          leading: const Icon(Icons.history, size: 18),
                                          title: Text(h),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.close, size: 18),
                                            onPressed: () {
                                              setState(() {
                                                _historicoBuscas.remove(h);
                                              });
                                            },
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _searchController.text = h;
                                              _searchQuery = h;
                                              _showSuggestions = false;
                                            });
                                          },
                                        )),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 53,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.filter_alt),
                    label: const Text('Filtros'),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                        builder: (context) {
                          return Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 20,
                                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                              ),
                              child: StatefulBuilder(
                                builder: (context, setModalState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Promoção', style: Theme.of(context).textTheme.titleMedium),
                                      const SizedBox(height: 8),
                                      // FilterChips com fundo branco e borda colorida, mantendo layout anterior
                                      Wrap(
                                        spacing: 10,
                                        children: [
                                          FilterChip(
                                            label: const Text('Oferta'),
                                            selected: _filtrarOferta,
                                            backgroundColor: Colors.white,
                                            selectedColor: Colors.grey.shade300,
                                            // Remove side/borda customizada
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            onSelected: (v) => setModalState(() => _filtrarOferta = v),
                                          ),
                                          FilterChip(
                                            label: const Text('Novo'),
                                            selected: _filtrarNovo,
                                            backgroundColor: Colors.white,
                                            selectedColor: Colors.grey.shade300,
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            onSelected: (v) => setModalState(() => _filtrarNovo = v),
                                          ),
                                          FilterChip(
                                            label: const Text('Mais vendido'),
                                            selected: _filtrarMaisVendido,
                                            backgroundColor: Colors.white,
                                            selectedColor: Colors.grey.shade300,
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            onSelected: (v) => setModalState(() => _filtrarMaisVendido = v),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      Text('Faixa de preço', style: Theme.of(context).textTheme.titleMedium),
                                      const SizedBox(height: 8),
                                      Text(
                                        'De R\$${_precoMin.toStringAsFixed(2)} até R\$${_precoMax.toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                      ),
                                      const SizedBox(height: 8),
                                      RangeSlider(
                                        values: RangeValues(_precoMin, _precoMax),
                                        min: _precoRangeMin,
                                        max: _precoRangeMax,
                                        divisions: (_precoRangeMax - _precoRangeMin).round(),
                                        labels: RangeLabels('R\$${_precoMin.toStringAsFixed(2)}', 'R\$${_precoMax.toStringAsFixed(2)}'),
                                        onChanged: (values) {
                                          setModalState(() {
                                            _precoMin = values.start;
                                            _precoMax = values.end;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setModalState(() {
                                                _categoriaFiltro = null;
                                                _precoMin = _precoRangeMin;
                                                _precoMax = _precoRangeMax;
                                                _filtrarOferta = false;
                                                _filtrarNovo = false;
                                                _filtrarMaisVendido = false;
                                              });
                                            },
                                            child: const Text('Limpar'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: colorScheme.primary,
                                              foregroundColor: Colors.white,
                                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Aplicar'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Lista horizontal de categorias
            SizedBox(
              height: 44,
              child: ScrollablePositionedList.builder(
                itemScrollController: _categoriaScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final bool isSelected = index == _categoriaSelecionada;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(
                        categorias[index],
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                      ),
                      selected: isSelected,
                      selectedColor: colorScheme.primary,
                      backgroundColor: Colors.white,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                      onSelected: (bool selected) {
                        _selecionarCategoria(index);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            // Grid de produtos filtrados
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemCount: produtosFiltrados.length + (_carregandoMais ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= produtosFiltrados.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final produto = produtosFiltrados[index];
                  return ProdutoCard(
                    produto: produto,
                    onAdicionarAoCarrinho: () {
                      Provider.of<CarrinhoProvider>(context, listen: false).adicionarProduto(produto);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${produto.nome} adicionado ao carrinho!',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: colorScheme.primary,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 