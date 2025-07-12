# Guia de Acessibilidade - Mercado Fácil

## 📋 Visão Geral

Este guia documenta as funcionalidades de acessibilidade implementadas no Mercado Fácil, garantindo que o app seja utilizável por pessoas com diferentes necessidades e capacidades.

## 🎯 Objetivos de Acessibilidade

- **WCAG 2.1 AA Compliance**: Seguir as diretrizes de acessibilidade web
- **Navegação Universal**: Suporte para teclado, mouse e toque
- **Leitores de Tela**: Compatibilidade total com tecnologias assistivas
- **Alto Contraste**: Temas otimizados para baixa visão
- **Feedback Tátil**: Vibração para confirmação de ações

## 🏗️ Arquitetura de Acessibilidade

```
lib/presentation/widgets/
├── accessibility_widgets.dart      # Widgets acessíveis reutilizáveis
├── keyboard_navigation.dart        # Sistema de navegação por teclado
├── screen_reader_labels.dart       # Labels para leitores de tela
└── accessibility_tester.dart       # Ferramentas de teste

lib/core/theme/
└── accessibility_theme.dart        # Temas com alto contraste
```

## 🚀 Como Usar

### 1. Widgets Acessíveis

```dart
// Botão acessível com feedback tátil
AccessibilityWidgets.accessibleButton(
  label: 'Adicionar ao carrinho',
  onPressed: () => addToCart(),
  child: ElevatedButton(
    onPressed: null, // Será sobrescrito pelo AccessibilityWidgets
    child: Text('Adicionar'),
  ),
);

// Campo de texto acessível
AccessibilityWidgets.accessibleTextField(
  label: 'E-mail',
  controller: emailController,
  hint: 'Digite seu e-mail',
  keyboardType: TextInputType.emailAddress,
  validator: Validators.email,
);

// Imagem acessível
AccessibilityWidgets.accessibleImage(
  imageUrl: produto.imagemUrl,
  description: 'Imagem do produto ${produto.nome}',
  width: 150,
  height: 150,
);
```

### 2. Navegação por Teclado

```dart
// Widget focável por teclado
KeyboardFocusable(
  id: 'login-button',
  onActivate: () => performLogin(),
  child: ElevatedButton(
    onPressed: null, // Será sobrescrito pelo KeyboardFocusable
    child: Text('Entrar'),
  ),
);

// Configurar navegação em uma tela
class LoginScreen extends StatefulWidget with KeyboardNavigationMixin {
  @override
  List<String> get focusableIds => [
    'email-field',
    'password-field',
    'login-button',
    'forgot-password-link',
  ];

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardNavigation(
      Scaffold(
        // ... conteúdo da tela
      ),
    );
  }
}
```

### 3. Labels para Leitores de Tela

```dart
// Usar labels pré-definidos
Semantics(
  label: ScreenReaderLabels.addToCart('Arroz Integral'),
  child: ElevatedButton(
    onPressed: () => addToCart(),
    child: Text('Adicionar'),
  ),
);

// Labels dinâmicos
Semantics(
  label: ScreenReaderLabels.productCard(
    produto.nome,
    produto.preco,
    discount: produto.precoPromocional != null ? 'Em oferta' : null,
  ),
  child: ProdutoCard(produto: produto),
);
```

### 4. Temas de Alto Contraste

```dart
// Aplicar tema de alto contraste
MaterialApp(
  theme: AccessibilityTheme.highContrastLightTheme,
  darkTheme: AccessibilityTheme.highContrastDarkTheme,
  // ...
);

// Verificar contraste de cores
if (AccessibilityTheme.hasAdequateContrast(textColor, backgroundColor)) {
  // Cores adequadas
} else {
  // Ajustar cores
}
```

## 🧪 Testando Acessibilidade

### 1. Testador Automático

```dart
// Ativar testador de acessibilidade (apenas em debug)
AccessibilityTester(
  enabled: kDebugMode,
  child: MyApp(),
);

// Verificar problemas automaticamente
final tester = AccessibilityTester(enabled: true);
tester.startAccessibilityTest();
```

### 2. Simulador de Leitor de Tela

```dart
// Ativar simulador de leitor de tela
ScreenReaderSimulator(
  enabled: kDebugMode,
  child: MyApp(),
);

// Adicionar anúncios programaticamente
final simulator = ScreenReaderSimulator(enabled: true);
simulator.addAnnouncement('Produto adicionado ao carrinho');
```

### 3. Testes Manuais

#### Navegação por Teclado

1. Conecte um teclado ao dispositivo
2. Use Tab para navegar entre elementos
3. Use Enter/Space para ativar elementos
4. Use setas para navegar em listas
5. Use Escape para voltar/fechar

#### Leitor de Tela

1. Ative o TalkBack (Android) ou VoiceOver (iOS)
2. Navegue pelo app usando gestos
3. Verifique se todos os elementos são anunciados
4. Teste funcionalidades principais

#### Alto Contraste

1. Ative o modo de alto contraste no sistema
2. Verifique se o app responde adequadamente
3. Teste todos os temas disponíveis

## 📊 Checklist de Acessibilidade

### ✅ Semantics e Labels

- [ ] Todos os botões têm labels descritivos
- [ ] Imagens têm descrições alternativas
- [ ] Campos de formulário têm labels
- [ ] Estados são anunciados (loading, error, success)
- [ ] Navegação é clara e lógica

### ✅ Navegação por Teclado

- [ ] Todos os elementos são focáveis
- [ ] Ordem de tab é lógica
- [ ] Atalhos de teclado funcionam
- [ ] Escape fecha modais/drawers
- [ ] Setas navegam em listas

### ✅ Contraste e Cores

- [ ] Contraste mínimo 4.5:1 (WCAG AA)
- [ ] Cores não são a única forma de informação
- [ ] Modo escuro disponível
- [ ] Alto contraste suportado
- [ ] Texto legível em todos os fundos

### ✅ Tamanhos e Toque

- [ ] Alvos de toque mínimos 48x48dp
- [ ] Texto mínimo 16sp
- [ ] Espaçamento adequado entre elementos
- [ ] Botões não muito próximos
- [ ] Áreas de toque bem definidas

### ✅ Feedback e Estados

- [ ] Feedback tátil para ações
- [ ] Estados visuais claros
- [ ] Mensagens de erro descritivas
- [ ] Confirmações para ações destrutivas
- [ ] Indicadores de progresso

## 🔧 Configurações de Acessibilidade

### Android

```xml
<!-- AndroidManifest.xml -->
<application
    android:label="Mercado Fácil"
    android:description="@string/app_description">

    <activity
        android:name=".MainActivity"
        android:exported="true"
        android:label="Mercado Fácil"
        android:description="Tela principal do aplicativo">
        <!-- ... -->
    </activity>
</application>
```

### iOS

```xml
<!-- Info.plist -->
<key>CFBundleDisplayName</key>
<string>Mercado Fácil</string>
<key>CFBundleDescription</key>
<string>Aplicativo de supermercado online</string>
```

## 📱 Recursos de Acessibilidade

### 1. Gestos de Acessibilidade

- **Toque duplo**: Ampliar imagens
- **Toque longo**: Opções contextuais
- **Pinça**: Zoom in/out
- **Deslize**: Navegação em listas

### 2. Feedback Tátil

- **Leve**: Seleção de itens
- **Médio**: Confirmação de ações
- **Forte**: Erros importantes
- **Seleção**: Mudança de foco

### 3. Anúncios Automáticos

- Mudanças de tela
- Estados de carregamento
- Mensagens de erro
- Confirmações de ações
- Navegação entre seções

## 🐛 Solução de Problemas

### Problema: Elemento não focável

**Solução:**

```dart
// Adicionar Focus widget
Focus(
  child: GestureDetector(
    onTap: () => action(),
    child: MyWidget(),
  ),
);
```

### Problema: Label não anunciado

**Solução:**

```dart
// Adicionar Semantics
Semantics(
  label: 'Descrição clara do elemento',
  child: MyWidget(),
);
```

### Problema: Contraste insuficiente

**Solução:**

```dart
// Usar tema de alto contraste
theme: AccessibilityTheme.highContrastLightTheme,
```

### Problema: Navegação confusa

**Solução:**

```dart
// Definir ordem de foco
List<String> get focusableIds => [
  'header',
  'search-field',
  'product-list',
  'cart-button',
];
```

## 📈 Métricas de Acessibilidade

### Indicadores de Sucesso

- **Taxa de uso de leitores de tela**: >5%
- **Tempo de navegação por teclado**: <2x tempo de toque
- **Taxa de erro de usuários com deficiência**: <2%
- **Satisfação de acessibilidade**: >4.5/5

### Ferramentas de Medição

- **Flutter Inspector**: Verificar Semantics
- **Accessibility Scanner**: Análise automática
- **Screen Reader Testing**: Testes manuais
- **Color Contrast Analyzer**: Verificar contraste

## 🔄 Atualizações e Manutenção

### Revisões Regulares

- **Mensal**: Verificar novos widgets
- **Trimestral**: Teste completo de acessibilidade
- **Semestral**: Atualizar para novas diretrizes
- **Anual**: Auditoria completa

### Processo de Desenvolvimento

1. **Design**: Considerar acessibilidade desde o início
2. **Desenvolvimento**: Usar widgets acessíveis
3. **Teste**: Verificar com ferramentas automáticas
4. **Validação**: Teste manual com usuários
5. **Deploy**: Monitorar métricas de uso

## 📞 Suporte e Contato

Para dúvidas sobre acessibilidade:

- **Email**: acessibilidade@mercadofacil.com
- **Documentação**: [Link para docs]
- **Testes**: [Link para testes automatizados]
- **Feedback**: [Formulário de feedback]

---

**Última atualização**: ${DateTime.now().toString().substring(0, 10)}
**Versão**: 1.0.0
**Status**: Implementado e testado
