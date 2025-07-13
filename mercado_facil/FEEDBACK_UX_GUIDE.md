# Guia de Feedback Visual - Mercado Fácil

## 📋 Visão Geral

Este guia documenta os componentes de feedback visual implementados na Fase 3.3, incluindo loading padronizados, skeleton screens, mensagens de feedback, animações de transição e pull-to-refresh.

## 🎯 Objetivos

- **Padronizar feedback visual** em todo o app
- **Melhorar UX** durante carregamentos e transições
- **Fornecer feedback consistente** para ações do usuário
- **Implementar animações suaves** e profissionais
- **Adicionar pull-to-refresh** em listas e grids

## 🏗️ Componentes Implementados

### 1. Loading Components (`loading_components.dart`)

Componentes de loading padronizados para diferentes contextos.

#### **Uso Básico**

```dart
import '../widgets/loading_components.dart';

// Loading circular padrão
LoadingComponents.circular()

// Loading com mensagem
LoadingComponents.withMessage('Carregando produtos...')

// Loading de página completa
LoadingComponents.page(message: 'Carregando...')

// Loading de card
LoadingComponents.card(message: 'Carregando produto...')
```

#### **Tipos de Loading**

- **Circular**: Loading circular padrão
- **Linear**: Barra de progresso
- **Button**: Loading para botões
- **Page**: Loading de página completa
- **Card**: Loading para cards
- **List**: Loading para listas
- **Grid**: Loading para grids
- **Overlay**: Loading com overlay
- **Pull-to-refresh**: Loading para pull-to-refresh

#### **Wrappers**

```dart
// Wrapper simples
LoadingWrapper(
  isLoading: _loading,
  child: MyWidget(),
)

// Wrapper com loading customizado
LoadingWrapper(
  isLoading: _loading,
  loadingWidget: CustomLoadingWidget(),
  child: MyWidget(),
)

// Wrapper para operações assíncronas
AsyncLoadingWidget(
  future: _loadData(),
  builder: (data) => MyWidget(data: data),
)
```

### 2. Skeleton Screens (`skeleton_screens.dart`)

Skeleton screens para melhorar a percepção de velocidade.

#### **Uso Básico**

```dart
import '../widgets/skeleton_screens.dart';

// Skeleton de card de produto
SkeletonScreens.productCard()

// Skeleton de lista de produtos
SkeletonScreens.productList(itemCount: 6)

// Skeleton de item de carrinho
SkeletonScreens.cartItem()

// Skeleton de página completa
SkeletonScreens.page(title: 'Produtos')
```

#### **Tipos de Skeleton**

- **ProductCard**: Skeleton para cards de produto
- **ProductList**: Skeleton para listas de produtos
- **CartItem**: Skeleton para itens do carrinho
- **OrderItem**: Skeleton para itens de pedido
- **UserProfile**: Skeleton para perfil do usuário
- **Form**: Skeleton para formulários
- **SearchBar**: Skeleton para barra de busca
- **Categories**: Skeleton para categorias

#### **Wrapper**

```dart
SkeletonWrapper(
  isLoading: _loading,
  child: MyWidget(),
  skeletonWidget: CustomSkeleton(),
)
```

### 3. Feedback Messages (`feedback_messages.dart`)

Sistema padronizado de mensagens de feedback.

#### **Mensagens Pré-definidas**

```dart
import '../widgets/feedback_messages.dart';

// Mensagens de sucesso
FeedbackMessages.Success.productAdded
FeedbackMessages.Success.orderPlaced
FeedbackMessages.Success.profileUpdated

// Mensagens de erro
FeedbackMessages.Error.networkError
FeedbackMessages.Error.validationError
FeedbackMessages.Error.productNotFound

// Mensagens de aviso
FeedbackMessages.Warning.slowConnection
FeedbackMessages.Warning.lowBattery

// Mensagens informativas
FeedbackMessages.Info.loading
FeedbackMessages.Info.saving
```

#### **Exibir Mensagens**

```dart
// Mensagem de sucesso
FeedbackMessages.showSuccess(
  context,
  FeedbackMessages.Success.productAdded,
);

// Mensagem de erro
FeedbackMessages.showError(
  context,
  FeedbackMessages.Error.networkError,
);

// Mensagem de aviso
FeedbackMessages.showWarning(
  context,
  FeedbackMessages.Warning.slowConnection,
);

// Mensagem informativa
FeedbackMessages.showInfo(
  context,
  FeedbackMessages.Info.loading,
);
```

#### **Diálogos**

```dart
// Diálogo de confirmação
final confirmed = await FeedbackMessages.showConfirmation(
  context,
  'Confirmar ação',
  'Tem certeza que deseja continuar?',
);

// Diálogo de erro
FeedbackMessages.showErrorDialog(
  context,
  'Erro',
  'Ocorreu um erro inesperado.',
  onRetry: () => _retryOperation(),
);
```

### 4. Transition Animations (`transition_animations.dart`)

Sistema de animações de transição padronizadas.

#### **Animações Básicas**

```dart
import '../widgets/transition_animations.dart';

// Fade in
TransitionAnimations.fadeIn(child: MyWidget())

// Slide in da esquerda
TransitionAnimations.slideInLeft(child: MyWidget())

// Scale in
TransitionAnimations.scaleIn(child: MyWidget())

// Bounce
TransitionAnimations.bounce(child: MyWidget())
```

#### **Animações de Lista**

```dart
// Entrada sequencial
TransitionAnimations.staggeredList(
  children: myWidgets,
)

// Entrada para grid
TransitionAnimations.staggeredGrid(
  children: myWidgets,
  crossAxisCount: 2,
)
```

#### **Transições de Página**

```dart
// Transição de página
Navigator.push(
  context,
  TransitionAnimations.pageTransition(
    page: MyPage(),
  ),
);

// Transição de modal
Navigator.push(
  context,
  TransitionAnimations.modalTransition(
    page: MyModal(),
  ),
);
```

#### **Wrapper Animado**

```dart
AnimatedWrapper(
  animate: _shouldAnimate,
  animationBuilder: (child) => TransitionAnimations.fadeIn(child: child),
  child: MyWidget(),
)
```

### 5. Pull-to-Refresh (`pull_to_refresh_widget.dart`)

Sistema de pull-to-refresh padronizado.

#### **Uso Básico**

```dart
import '../widgets/pull_to_refresh_widget.dart';

// Pull-to-refresh simples
PullToRefreshWidget.create(
  onRefresh: () => _refreshData(),
  child: MyList(),
)

// Pull-to-refresh com feedback
PullToRefreshWidget.createWithFeedback(
  onRefresh: () => _refreshData(),
  child: MyList(),
  context: context,
  successMessage: 'Dados atualizados!',
  errorMessage: 'Erro ao atualizar',
)
```

#### **Pull-to-refresh Específicos**

```dart
// Para produtos
PullToRefreshWidget.forProducts(
  onRefresh: () => _refreshProducts(),
  child: ProductList(),
  context: context,
)

// Para pedidos
PullToRefreshWidget.forOrders(
  onRefresh: () => _refreshOrders(),
  child: OrderList(),
  context: context,
)

// Para perfil
PullToRefreshWidget.forProfile(
  onRefresh: () => _refreshProfile(),
  child: ProfileWidget(),
  context: context,
)
```

#### **Wrappers**

```dart
// Wrapper simples
PullToRefreshWrapper(
  onRefresh: () => _refreshData(),
  child: MyList(),
)

// Wrapper com feedback
PullToRefreshWrapper(
  onRefresh: () => _refreshData(),
  child: MyList(),
  successMessage: 'Sucesso!',
  errorMessage: 'Erro!',
  showFeedback: true,
)
```

#### **Mixin**

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with PullToRefreshMixin {
  @override
  Future<void> onRefresh() async {
    // Implementar lógica de refresh
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return buildRefreshIndicator(
      MyList(),
    );
  }
}
```

## 🚀 Exemplos de Implementação

### **Tela de Produtos com Todos os Componentes**

```dart
class ProdutosScreen extends StatefulWidget {
  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen>
    with PullToRefreshMixin {

  bool _loading = true;
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    setState(() => _loading = true);
    try {
      final produtos = await ProdutosService.getProdutos();
      setState(() {
        _produtos = produtos;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      FeedbackMessages.showError(
        context,
        FeedbackMessages.Error.networkError,
      );
    }
  }

  @override
  Future<void> onRefresh() async {
    await _loadProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos')),
      body: SkeletonWrapper(
        isLoading: _loading,
        skeletonWidget: SkeletonScreens.productList(),
        child: buildRefreshIndicatorWithFeedback(
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: _produtos.length,
            itemBuilder: (context, index) {
              return TransitionAnimations.fadeIn(
                child: ProdutoCard(
                  produto: _produtos[index],
                  onAdicionarAoCarrinho: () {
                    _adicionarAoCarrinho(_produtos[index]);
                  },
                ),
              );
            },
          ),
          FeedbackMessages.Success.productsUpdated,
          FeedbackMessages.Error.networkError,
        ),
      ),
    );
  }

  void _adicionarAoCarrinho(Produto produto) {
    // Lógica de adicionar ao carrinho
    FeedbackMessages.showSuccess(
      context,
      FeedbackMessages.Success.productAdded,
    );
  }
}
```

### **Tela de Carrinho com Loading States**

```dart
class CarrinhoScreen extends StatefulWidget {
  @override
  _CarrinhoScreenState createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {

  bool _loading = false;

  Future<void> _atualizarQuantidade(CarrinhoItem item, int novaQuantidade) async {
    setState(() => _loading = true);

    try {
      await CarrinhoProvider().alterarQuantidade(item.produto, novaQuantidade);
      FeedbackMessages.showSuccess(
        context,
        'Quantidade atualizada!',
      );
    } catch (e) {
      FeedbackMessages.showError(
        context,
        FeedbackMessages.Error.unknownError,
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrinho')),
      body: LoadingWrapper(
        isLoading: _loading,
        loadingWidget: SkeletonScreens.cartList(),
        child: Consumer<CarrinhoProvider>(
          builder: (context, carrinho, child) {
            if (carrinho.itens.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64),
                    SizedBox(height: 16),
                    Text('Carrinho vazio'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: carrinho.itens.length,
              itemBuilder: (context, index) {
                final item = carrinho.itens[index];
                return TransitionAnimations.slideInLeft(
                  child: CarrinhoItemWidget(
                    item: item,
                    onQuantidadeChanged: (novaQuantidade) {
                      _atualizarQuantidade(item, novaQuantidade);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
```

## 📊 Benefícios Implementados

### **✅ Loading Padronizados**

- Componentes reutilizáveis para diferentes contextos
- Loading states consistentes em todo o app
- Melhor percepção de performance

### **✅ Skeleton Screens**

- Feedback visual imediato durante carregamento
- Redução da percepção de tempo de espera
- Layout consistente durante loading

### **✅ Mensagens Padronizadas**

- Feedback consistente para ações do usuário
- Mensagens pré-definidas para casos comuns
- Sistema de diálogos e toasts padronizado

### **✅ Animações de Transição**

- Transições suaves entre telas
- Animações de entrada para listas e grids
- Feedback visual para interações

### **✅ Pull-to-Refresh**

- Funcionalidade de atualização intuitiva
- Feedback visual durante refresh
- Mensagens de sucesso/erro padronizadas

## 🎯 Próximos Passos

1. **Implementar** os componentes nas telas existentes
2. **Testar** a performance das animações
3. **Ajustar** timing e curvas conforme necessário
4. **Documentar** casos de uso específicos
5. **Coletar feedback** dos usuários

## 📝 Notas Técnicas

- Todos os componentes são **const** quando possível
- Animações usam **TweenAnimationBuilder** para performance
- Skeleton screens são **otimizados** para diferentes resoluções
- Pull-to-refresh **integra** com o sistema de feedback existente
- Mensagens **respeitam** o tema e cores do app
