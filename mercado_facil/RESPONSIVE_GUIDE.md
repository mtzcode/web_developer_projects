# Guia do Sistema Responsivo - Mercado Fácil

## Visão Geral

O sistema responsivo do Mercado Fácil foi implementado para garantir que o app funcione perfeitamente em diferentes dispositivos e resoluções, mantendo o visual padrão e apenas ajustando tamanhos e layouts conforme necessário.

## Componentes do Sistema

### 1. ResponsiveBreakpoints

Sistema de breakpoints que detecta automaticamente o tipo e tamanho do dispositivo.

```dart
// Verificar tipo de dispositivo
if (ResponsiveBreakpoints.isMobile(context)) {
  // Lógica para mobile
} else if (ResponsiveBreakpoints.isTablet(context)) {
  // Lógica para tablet
}

// Obter informações completas
final deviceInfo = ResponsiveBreakpoints.getDeviceInfo(context);
print('Dispositivo: ${deviceInfo.deviceType.name}');
print('Tamanho: ${deviceInfo.deviceSize.name}');
```

### 2. TabletLayout

Otimizações específicas para tablets e dispositivos maiores.

```dart
// Padding adaptativo
final padding = TabletLayout.getAdaptivePadding(context);

// Número de colunas para grid
final columns = TabletLayout.getGridColumns(context);

// Tamanho de fonte adaptativo
final fontSize = TabletLayout.getAdaptiveFontSize(context, 16.0);
```

### 3. DynamicFontSizes

Sistema de fontes que se ajustam automaticamente ao dispositivo.

```dart
// Tamanhos pré-definidos
final titleSize = DynamicFontSizes.getHeadlineMedium(context);
final bodySize = DynamicFontSizes.getBodyLarge(context);
final buttonSize = DynamicFontSizes.getButtonText(context);

// Tamanho customizado
final customSize = DynamicFontSizes.getDynamicFontSize(context, 18.0);

// Com limites
final limitedSize = DynamicFontSizes.getDynamicFontSizeWithLimits(
  context, 18.0, 12.0, 24.0
);
```

### 4. AdaptiveLayout

Widgets que se adaptam automaticamente ao dispositivo.

```dart
// Container adaptativo
AdaptiveLayout.adaptiveContainer(
  context: context,
  child: Text('Conteúdo'),
);

// Card adaptativo
AdaptiveLayout.adaptiveCard(
  context: context,
  child: Column(
    children: [
      Text('Título'),
      Text('Descrição'),
    ],
  ),
);

// Botão adaptativo
AdaptiveLayout.adaptiveButton(
  context: context,
  onPressed: () {},
  child: Text('Clique aqui'),
);
```

## Breakpoints Implementados

### Dispositivos Mobile

- **Small Mobile**: < 320dp (iPhone SE)
- **Medium Mobile**: 320dp - 375dp (iPhone 12)
- **Large Mobile**: 375dp - 414dp (iPhone 12 Pro Max)

### Dispositivos Tablet

- **Small Tablet**: 414dp - 768dp (iPad Mini)
- **Large Tablet**: 768dp - 1024dp (iPad Pro)

### Dispositivos Desktop

- **Desktop**: 1024dp - 1200dp
- **Large Desktop**: > 1200dp

## Como Usar

### 1. Em Widgets Existentes

```dart
class MeuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }
}
```

### 2. Com Padding Responsivo

```dart
ResponsivePadding(
  child: Text('Texto com padding adaptativo'),
)
```

### 3. Com Texto Dinâmico

```dart
DynamicText(
  text: 'Texto com tamanho dinâmico',
  baseSize: 16.0,
  useLimits: true,
  minSize: 12.0,
  maxSize: 24.0,
)
```

### 4. Com Layout Adaptativo

```dart
AdaptiveWidget(
  type: AdaptiveLayoutType.card,
  properties: {
    'padding': EdgeInsets.all(16),
    'margin': EdgeInsets.all(8),
  },
  child: Text('Card adaptativo'),
)
```

## Testador Responsivo

O app inclui um testador responsivo que pode ser ativado em modo debug:

1. Execute o app em modo debug
2. Clique no botão flutuante com ícone de dispositivos
3. Use os controles para testar diferentes resoluções
4. Gere relatórios de responsividade

### Funcionalidades do Testador

- **Seletor de Dispositivos**: Teste em dispositivos pré-definidos
- **Controles de Orientação**: Teste em retrato e paisagem
- **Dimensões Customizadas**: Ajuste manual de largura e altura
- **Relatórios**: Gere relatórios detalhados de responsividade

## Exemplos de Implementação

### Produto Card Responsivo

```dart
class ResponsiveProductCard extends StatelessWidget {
  final Produto produto;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout.adaptiveCard(
      context: context,
      child: Column(
        children: [
          // Imagem adaptativa
          AdaptiveLayout.adaptiveThumbnail(
            context: context,
            child: CachedNetworkImage(
              imageUrl: produto.imagemUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Título com fonte dinâmica
          DynamicText(
            text: produto.nome,
            baseSize: 16.0,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // Preço com fonte dinâmica
          DynamicText(
            text: 'R\$ ${produto.preco.toStringAsFixed(2)}',
            baseSize: 18.0,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Botão adaptativo
          AdaptiveLayout.adaptiveButton(
            context: context,
            onPressed: () => _adicionarAoCarrinho(),
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
```

### Grid de Produtos Responsivo

```dart
class ResponsiveProductGrid extends StatelessWidget {
  final List<Produto> produtos;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout.adaptiveGrid(
      context: context,
      children: produtos.map((produto) =>
        ResponsiveProductCard(produto: produto)
      ).toList(),
    );
  }
}
```

### Formulário Responsivo

```dart
class ResponsiveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout.adaptiveColumn(
      context: context,
      children: [
        // Input adaptativo
        AdaptiveLayout.adaptiveInput(
          context: context,
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),
        ),

        AdaptiveLayout.adaptiveSpacing(context: context),

        // Input adaptativo
        AdaptiveLayout.adaptiveInput(
          context: context,
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
        ),

        AdaptiveLayout.adaptiveSpacing(context: context),

        // Botão adaptativo
        AdaptiveLayout.adaptiveButton(
          context: context,
          onPressed: () => _enviarFormulario(),
          child: Text('Enviar'),
        ),
      ],
    );
  }
}
```

## Boas Práticas

### 1. Sempre Use Context

```dart
// ✅ Correto
final padding = TabletLayout.getAdaptivePadding(context);

// ❌ Incorreto
final padding = EdgeInsets.all(16);
```

### 2. Teste em Diferentes Dispositivos

```dart
// Use o ResponsiveTester para verificar
// como o app se comporta em diferentes resoluções
```

### 3. Mantenha o Visual Padrão

```dart
// ✅ Mantenha cores, estilos e temas originais
// ✅ Apenas ajuste tamanhos e espaçamentos

// ❌ Não mude cores ou estilos baseados no dispositivo
```

### 4. Use Breakpoints Consistentes

```dart
// ✅ Use os breakpoints pré-definidos
if (ResponsiveBreakpoints.isTablet(context)) {
  // Lógica para tablet
}

// ❌ Não crie breakpoints customizados
if (MediaQuery.of(context).size.width > 500) {
  // Lógica customizada
}
```

## Troubleshooting

### Problema: Layout não se adapta

**Solução**: Verifique se está usando os widgets responsivos corretos e se o context está sendo passado.

### Problema: Fontes muito grandes/pequenas

**Solução**: Use `DynamicFontSizes.getDynamicFontSizeWithLimits()` para definir limites mínimo e máximo.

### Problema: Grid não funciona em tablet

**Solução**: Verifique se está usando `TabletLayout.getGridColumns(context)` para definir o número de colunas.

### Problema: Testador não aparece

**Solução**: Certifique-se de que o app está em modo debug (`kDebugMode`).

## Performance

O sistema responsivo foi otimizado para:

- **Detecção Rápida**: Breakpoints são calculados uma vez por build
- **Cache Inteligente**: Valores são cacheados quando possível
- **Rebuild Mínimo**: Apenas rebuilda quando necessário
- **Memory Efficient**: Não armazena dados desnecessários

## Conclusão

O sistema responsivo do Mercado Fácil garante que o app funcione perfeitamente em qualquer dispositivo, mantendo a experiência do usuário consistente e o visual padrão intacto. Use os componentes responsivos sempre que possível e teste regularmente em diferentes dispositivos.
