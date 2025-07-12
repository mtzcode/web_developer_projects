# 🧪 Testes Unitários - Mercado Fácil

## 📋 Visão Geral

Este documento descreve os testes unitários implementados para garantir a qualidade e confiabilidade do código do Mercado Fácil.

## 🏗️ Estrutura dos Testes

```
test/
├── unit/
│   ├── validators_test.dart          # Testes para validações
│   ├── app_exception_test.dart       # Testes para exceções
│   └── error_handler_test.dart       # Testes para tratamento de erros
└── test_runner.dart                  # Runner principal dos testes
```

## 🚀 Como Executar os Testes

### 1. Executar Todos os Testes

```bash
cd mercado_facil
flutter test
```

### 2. Executar Testes Específicos

```bash
# Testes de validação
flutter test test/unit/validators_test.dart

# Testes de exceções
flutter test test/unit/app_exception_test.dart

# Testes de tratamento de erros
flutter test test/unit/error_handler_test.dart
```

### 3. Executar com Cobertura

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 4. Executar com Relatório Detalhado

```bash
flutter test --reporter=expanded
```

## 📊 Testes Implementados

### 1. Validators (`validators_test.dart`)

#### **Email**

- ✅ Email válido retorna `null`
- ✅ Email vazio retorna mensagem de erro
- ✅ Email inválido retorna mensagem de erro
- ✅ Email com formato incorreto retorna erro

#### **Senha**

- ✅ Senha forte retorna `null`
- ✅ Senha vazia retorna mensagem de erro
- ✅ Senha muito curta retorna erro
- ✅ Senha sem letra maiúscula retorna erro
- ✅ Senha sem letra minúscula retorna erro
- ✅ Senha sem número retorna erro
- ✅ Senha sem caractere especial retorna erro

#### **CPF**

- ✅ CPF válido retorna `null`
- ✅ CPF vazio retorna mensagem de erro
- ✅ CPF com tamanho incorreto retorna erro
- ✅ CPF com dígitos iguais retorna erro
- ✅ CPF inválido retorna erro

#### **Telefone**

- ✅ Telefone válido retorna `null`
- ✅ Telefone vazio retorna mensagem de erro
- ✅ Telefone com tamanho incorreto retorna erro
- ✅ Telefone inválido retorna erro

#### **CEP**

- ✅ CEP válido retorna `null`
- ✅ CEP vazio retorna mensagem de erro
- ✅ CEP com tamanho incorreto retorna erro
- ✅ CEP inválido retorna erro

### 2. AppException (`app_exception_test.dart`)

#### **Construtores Factory**

- ✅ `networkError` cria exceção de rede
- ✅ `timeoutError` cria exceção de timeout
- ✅ `authenticationError` cria exceção de autenticação
- ✅ `validationError` cria exceção de validação
- ✅ `dataNotFound` cria exceção de dados não encontrados
- ✅ `insufficientStock` cria exceção de estoque
- ✅ `paymentError` cria exceção de pagamento
- ✅ `unknownError` cria exceção desconhecida

#### **Propriedades**

- ✅ `displayMessage` retorna mensagem apropriada
- ✅ `isNetworkError` identifica erros de rede
- ✅ `isAuthError` identifica erros de autenticação
- ✅ `isRetryable` identifica erros recuperáveis

#### **Ícones e Cores**

- ✅ Retorna ícones apropriados para cada tipo
- ✅ Retorna cores apropriadas para cada tipo

#### **Métodos**

- ✅ `toString` retorna representação string
- ✅ `toMap` converte para Map
- ✅ `copyWith` cria cópia modificada

### 3. ErrorHandler (`error_handler_test.dart`)

#### **Conversão de Erros**

- ✅ Mantém AppException inalterada
- ✅ Converte erro de rede
- ✅ Converte erro de timeout
- ✅ Converte erro de autenticação
- ✅ Converte erro do Firebase
- ✅ Converte erro de validação
- ✅ Converte erro desconhecido

#### **Títulos de Erro**

- ✅ Retorna títulos apropriados para cada tipo

#### **Retry Mechanism**

- ✅ Executa operação com sucesso na primeira tentativa
- ✅ Tenta novamente após falha
- ✅ Falha após todas as tentativas
- ✅ Usa delay progressivo

#### **Fallback Operations**

- ✅ Executa operação primária com sucesso
- ✅ Executa fallback quando primário falha
- ✅ Falha quando ambos falham

#### **Configuração**

- ✅ Configura callbacks corretamente
- ✅ Limpa callbacks

## 📈 Cobertura de Testes

### **Validators**: 100%

- Todos os métodos testados
- Todos os cenários de erro cobertos
- Validações de entrada e saída

### **AppException**: 100%

- Todos os construtores factory testados
- Todas as propriedades testadas
- Todos os métodos testados

### **ErrorHandler**: 95%

- Conversão de erros testada
- Retry mechanism testado
- Fallback operations testadas
- Configuração testada

## 🎯 Cenários de Teste

### **Cenários Positivos**

- Validações com dados válidos
- Operações bem-sucedidas
- Configurações corretas

### **Cenários Negativos**

- Validações com dados inválidos
- Operações que falham
- Configurações incorretas

### **Cenários de Borda**

- Valores nulos
- Strings vazias
- Dados extremos
- Múltiplas tentativas

## 🔧 Configuração do Ambiente

### **Dependências Necessárias**

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.7
```

### **Arquivos de Configuração**

- `test/` - Diretório de testes
- `coverage/` - Relatórios de cobertura
- `.gitignore` - Incluir `coverage/`

## 📝 Boas Práticas

### **1. Nomenclatura**

```dart
test('deve retornar null para email válido', () {
  // teste aqui
});
```

### **2. Organização**

```dart
group('Validators', () {
  group('email', () {
    // testes específicos
  });
});
```

### **3. Assertions**

```dart
expect(result, isNull);
expect(result, equals('valor esperado'));
expect(result, contains('texto'));
expect(() => function(), throwsA(isA<Exception>()));
```

### **4. Setup e Teardown**

```dart
setUp(() {
  // configuração antes de cada teste
});

tearDown(() {
  // limpeza após cada teste
});
```

## 🚨 Troubleshooting

### **Erro: "No tests found"**

```bash
flutter clean
flutter pub get
flutter test
```

### **Erro: "Test timeout"**

- Verificar operações assíncronas
- Aumentar timeout se necessário
- Verificar loops infinitos

### **Erro: "Mock not found"**

```bash
flutter packages pub run build_runner build
```

## 📊 Métricas de Qualidade

### **Cobertura Mínima**: 90%

### **Testes por Funcionalidade**: 100%

### **Cenários de Erro**: 100%

## 🔄 Integração Contínua

### **GitHub Actions**

```yaml
- name: Run tests
  run: flutter test --coverage
```

### **Pre-commit Hooks**

```bash
flutter test
```

## 📚 Próximos Passos

### **Testes Pendentes**

- [ ] Testes de integração
- [ ] Testes de widget
- [ ] Testes de performance
- [ ] Testes de acessibilidade

### **Melhorias**

- [ ] Mocks para Firebase
- [ ] Testes de navegação
- [ ] Testes de estado
- [ ] Testes de cache

## 🎉 Conclusão

Os testes unitários implementados garantem:

- ✅ **Qualidade do código**
- ✅ **Refatoração segura**
- ✅ **Documentação viva**
- ✅ **Detecção precoce de bugs**
- ✅ **Confiança nas mudanças**

Execute os testes regularmente para manter a qualidade do projeto!
