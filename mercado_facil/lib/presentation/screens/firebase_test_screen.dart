import 'package:flutter/material.dart';
import '../../data/services/migration_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/produtos_service.dart';
import '../../core/theme/app_theme.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  final MigrationService _migrationService = MigrationService();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _statusMessage = '';
  Map<String, dynamic> _estatisticas = {};
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
  }

  Future<void> _carregarEstatisticas() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _migrationService.getEstatisticas();
      setState(() {
        _estatisticas = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao carregar estatísticas: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testarConexao() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testando conexão...';
      _logs.add('🔍 Testando conexão com Firestore...');
    });

    try {
      final sucesso = await _migrationService.testarConexao();
      setState(() {
        _statusMessage = sucesso ? '✅ Conexão OK!' : '❌ Falha na conexão';
        _logs.add(sucesso ? '✅ Conexão com Firestore funcionando!' : '❌ Falha na conexão');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro: $e';
        _logs.add('❌ Erro na conexão: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _migrarProdutos() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Migrando produtos...';
      _logs.add('🚀 Iniciando migração de produtos...');
    });

    try {
      await _migrationService.migrarProdutos();
      await _carregarEstatisticas();
      setState(() {
        _statusMessage = '✅ Produtos migrados com sucesso!';
        _logs.add('✅ Produtos migrados com sucesso!');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro na migração: $e';
        _logs.add('❌ Erro na migração: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _testarFirestore() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testando Firestore...';
      _logs.add('🔍 Testando leitura de produtos...');
    });

    try {
      final produtos = await _firestoreService.getProdutos();
      setState(() {
        _statusMessage = '✅ ${produtos.length} produtos carregados!';
        _logs.add('✅ ${produtos.length} produtos carregados do Firestore');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro no Firestore: $e';
        _logs.add('❌ Erro ao carregar produtos: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _limparProdutos() async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Confirmação'),
        content: const Text('Tem certeza que deseja remover TODOS os produtos? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmacao != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Removendo produtos...';
      _logs.add('⚠️ Removendo todos os produtos...');
    });

    try {
      await _migrationService.limparProdutos();
      await _carregarEstatisticas();
      setState(() {
        _statusMessage = '✅ Produtos removidos!';
        _logs.add('✅ Produtos removidos com sucesso!');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro ao remover: $e';
        _logs.add('❌ Erro ao remover produtos: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _testarAutenticacao() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testando autenticação...';
      _logs.add('🔍 Testando autenticação anônima...');
    });

    try {
      // Teste simples de autenticação
      final user = _authService.currentUser;
      setState(() {
        _statusMessage = user != null ? '✅ Usuário logado: ${user.email}' : 'ℹ️ Nenhum usuário logado';
        _logs.add(user != null ? '✅ Usuário autenticado: ${user.email}' : 'ℹ️ Nenhum usuário autenticado');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro na autenticação: $e';
        _logs.add('❌ Erro na autenticação: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _testarProdutosService() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testando ProdutosService...';
      _logs.add('🔍 Testando carregamento de produtos via ProdutosService...');
    });

    try {
      final produtos = await ProdutosService.carregarProdutosComCache(forcarAtualizacao: true);
      setState(() {
        _statusMessage = '✅ ${produtos.length} produtos carregados via ProdutosService!';
        _logs.add('✅ ${produtos.length} produtos carregados via ProdutosService');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro no ProdutosService: $e';
        _logs.add('❌ Erro no ProdutosService: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _migrarDadosMock() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Migrando dados mock...';
      _logs.add('🚀 Migrando dados mock para Firestore...');
    });

    try {
      await ProdutosService.migrarDadosMock();
      await _carregarEstatisticas();
      setState(() {
        _statusMessage = '✅ Dados mock migrados com sucesso!';
        _logs.add('✅ Dados mock migrados com sucesso!');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro na migração: $e';
        _logs.add('❌ Erro na migração: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _limparProdutosFirestore() async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Confirmação'),
        content: const Text('Tem certeza que deseja remover TODOS os produtos do Firestore?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmacao != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Removendo produtos do Firestore...';
      _logs.add('⚠️ Removendo produtos do Firestore...');
    });

    try {
      await ProdutosService.limparProdutosFirestore();
      await _carregarEstatisticas();
      setState(() {
        _statusMessage = '✅ Produtos removidos do Firestore!';
        _logs.add('✅ Produtos removidos do Firestore!');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erro ao remover: $e';
        _logs.add('❌ Erro ao remover produtos: $e');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste Firebase'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarEstatisticas,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status atual
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Estatísticas do Banco',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _EstatisticaCard(
                            titulo: 'Produtos',
                            valor: _estatisticas['produtos']?.toString() ?? '0',
                            icone: Icons.shopping_bag,
                            cor: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _EstatisticaCard(
                            titulo: 'Usuários',
                            valor: _estatisticas['usuarios']?.toString() ?? '0',
                            icone: Icons.people,
                            cor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _EstatisticaCard(
                            titulo: 'Pedidos',
                            valor: _estatisticas['pedidos']?.toString() ?? '0',
                            icone: Icons.receipt,
                            cor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status message
            if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _statusMessage.contains('✅') 
                    ? Colors.green.shade50 
                    : _statusMessage.contains('❌') 
                      ? Colors.red.shade50 
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _statusMessage.contains('✅') 
                      ? Colors.green.shade200 
                      : _statusMessage.contains('❌') 
                        ? Colors.red.shade200 
                        : Colors.blue.shade200,
                  ),
                ),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.contains('✅') 
                      ? Colors.green.shade700 
                      : _statusMessage.contains('❌') 
                        ? Colors.red.shade700 
                        : Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Botões de teste
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TestButton(
                  titulo: 'Testar Conexão',
                  icone: Icons.wifi,
                  onPressed: _testarConexao,
                  cor: Colors.blue,
                ),
                _TestButton(
                  titulo: 'Testar Firestore',
                  icone: Icons.storage,
                  onPressed: _testarFirestore,
                  cor: Colors.green,
                ),
                _TestButton(
                  titulo: 'Testar Auth',
                  icone: Icons.security,
                  onPressed: _testarAutenticacao,
                  cor: Colors.orange,
                ),
                _TestButton(
                  titulo: 'Testar ProdutosService',
                  icone: Icons.shopping_bag,
                  onPressed: _testarProdutosService,
                  cor: Colors.indigo,
                ),
                _TestButton(
                  titulo: 'Migrar Dados Mock',
                  icone: Icons.upload,
                  onPressed: _migrarDadosMock,
                  cor: Colors.purple,
                ),
                _TestButton(
                  titulo: 'Migrar Produtos',
                  icone: Icons.upload_file,
                  onPressed: _migrarProdutos,
                  cor: Colors.teal,
                ),
                _TestButton(
                  titulo: 'Limpar Firestore',
                  icone: Icons.delete_forever,
                  onPressed: _limparProdutosFirestore,
                  cor: Colors.red,
                ),
                _TestButton(
                  titulo: 'Limpar Produtos',
                  icone: Icons.delete,
                  onPressed: _limparProdutos,
                  cor: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Logs
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.list_alt),
                          const SizedBox(width: 8),
                          Text(
                            'Logs de Teste',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => setState(() => _logs.clear()),
                            child: const Text('Limpar'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              log,
                              style: TextStyle(
                                fontSize: 12,
                                color: log.contains('✅') 
                                  ? Colors.green.shade700 
                                  : log.contains('❌') 
                                    ? Colors.red.shade700 
                                    : log.contains('⚠️') 
                                      ? Colors.orange.shade700 
                                      : Colors.grey.shade700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstatisticaCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color cor;

  const _EstatisticaCard({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 24),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: cor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestButton extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onPressed;
  final Color cor;

  const _TestButton({
    required this.titulo,
    required this.icone,
    required this.onPressed,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icone, size: 18),
      label: Text(titulo),
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
} 