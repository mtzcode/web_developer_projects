# Cache Local para Produtos - Mercado Fácil

## Visão Geral

O sistema de cache local foi implementado para melhorar a performance do app, reduzir o uso de dados e permitir funcionamento offline. Os produtos são armazenados localmente usando `shared_preferences` e são atualizados automaticamente conforme necessário.

## Arquitetura

### 1. CacheService (`lib/data/services/cache_service.dart`)

Serviço responsável por gerenciar o cache local:

- **Salvar produtos**: Converte lista de produtos para JSON e salva no `SharedPreferences`
- **Carregar produtos**: Recupera produtos do cache e converte de volta para objetos `Produto`
- **Validação de cache**: Verifica se o cache ainda é válido (24 horas por padrão)
- **Gerenciamento**: Métodos para limpar, forçar atualização e obter informações do cache

### 2. ProdutosService Atualizado (`lib/data/services/produtos_service.dart`)

Serviço principal que integra o cache:

- **Carregamento inteligente**: Primeiro tenta carregar do cache, depois da API
- **Fallback robusto**: Se a API falhar, usa cache expirado ou dados mock
- **Atualização de favoritos**: Sincroniza mudanças de favoritos no cache
- **Simulação de API**: Simula delays e erros de rede para testar o sistema

### 3. Modelo Produto Atualizado (`lib/data/models/produto.dart`)

Adicionado método `copyWith()` para permitir atualizações no cache.

### 4. Interface do Usuário

#### Tela de Produtos (`lib/presentation/screens/produtos_screen.dart`)

- **Pull-to-refresh**: Atualiza produtos forçando nova requisição à API
- **Indicador de cache**: Mostra status do cache no AppBar
- **Carregamento otimizado**: Usa cache para carregamento inicial rápido

#### Widget de Status do Cache (`lib/presentation/widgets/cache_status_widget.dart`)

- **Status visual**: Mostra se o cache está válido ou expirado
- **Informações detalhadas**: Quantidade de produtos e última atualização
- **Gerenciamento**: Opções para atualizar ou limpar cache

## Funcionalidades

### 1. Cache Inteligente

- **Validade**: Cache expira em 24 horas
- **Fallback**: Se API falhar, usa cache mesmo expirado
- **Atualização automática**: Salva novos dados automaticamente

### 2. Performance

- **Carregamento rápido**: Primeira abertura usa cache
- **Redução de dados**: Menos requisições à API
- **Funcionamento offline**: App funciona sem internet

### 3. Experiência do Usuário

- **Indicadores visuais**: Status do cache sempre visível
- **Controle manual**: Usuário pode forçar atualização
- **Feedback**: Mensagens informativas sobre operações

## Como Usar

### Para o Desenvolvedor

```dart
// Carregar produtos com cache
final produtos = await ProdutosService.carregarProdutosComCache();

// Forçar atualização
final produtos = await ProdutosService.carregarProdutosComCache(forcarAtualizacao: true);

// Atualizar favorito no cache
await ProdutosService.atualizarFavorito('produto_id', true);

// Obter informações do cache
final info = await ProdutosService.getCacheInfo();

// Limpar cache
await ProdutosService.limparCache();
```

### Para o Usuário

1. **Pull-to-refresh**: Arraste para baixo na tela de produtos para atualizar
2. **Indicador de cache**: Toque no ícone de nuvem no AppBar para ver detalhes
3. **Gerenciamento**: Use as opções no widget de status para controlar o cache

## Configurações

### Validade do Cache

```dart
// Em CacheService
static const Duration _cacheValidity = Duration(hours: 24);
```

### Simulação de Erros

```dart
// Em ProdutosService._carregarProdutosDaAPI()
if (DateTime.now().millisecond % 10 == 0) {
  throw Exception('Erro de conexão simulado');
}
```

## Benefícios

1. **Performance**: Carregamento inicial muito mais rápido
2. **Economia de dados**: Reduz significativamente o uso de internet
3. **Funcionamento offline**: App funciona sem conexão
4. **Experiência consistente**: Menos loading states e interrupções
5. **Controle do usuário**: Transparência sobre o status dos dados

## Próximos Passos

1. **Cache de imagens**: Implementar cache para imagens dos produtos
2. **Sincronização**: Sincronizar favoritos com servidor
3. **Cache inteligente**: Ajustar validade baseado no tipo de produto
4. **Métricas**: Adicionar analytics sobre uso do cache
5. **Compressão**: Comprimir dados para economizar espaço

## Troubleshooting

### Cache não aparece

- Verifique se `shared_preferences` está instalado
- Confirme se o cache foi salvo corretamente

### Erro ao carregar cache

- Verifique o formato JSON dos dados salvos
- Use `CacheService.limparCache()` para resetar

### Performance ruim

- Ajuste a validade do cache conforme necessário
- Considere implementar cache de imagens
