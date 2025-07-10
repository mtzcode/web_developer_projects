# 🧪 Teste de Integração Firebase

## 🚀 Como Testar

### 1. Acessar Tela de Teste

1. Execute o app: `flutter run`
2. Na tela de login, adicione temporariamente um botão ou navegue diretamente para:
   ```
   /firebase_test
   ```

### 2. Testes Disponíveis

#### ✅ **Testar Conexão**

- Verifica se o Firebase está conectado
- Testa escrita e leitura no Firestore
- Deve mostrar "✅ Conexão OK!"

#### 🔍 **Testar Firestore**

- Tenta carregar produtos do Firestore
- Mostra quantos produtos foram carregados
- Deve mostrar "✅ X produtos carregados!"

#### 🔐 **Testar Auth**

- Verifica o estado da autenticação
- Mostra se há usuário logado
- Deve mostrar "ℹ️ Nenhum usuário logado" (normal)

#### 📤 **Migrar Produtos**

- Carrega produtos mock para o Firestore
- Cria 12 produtos de exemplo
- Deve mostrar "✅ Produtos migrados com sucesso!"

#### 🗑️ **Limpar Produtos**

- Remove todos os produtos do Firestore
- ⚠️ **CUIDADO**: Esta ação não pode ser desfeita!

## 📊 Estatísticas

A tela mostra estatísticas em tempo real:

- **Produtos**: Quantidade de produtos no banco
- **Usuários**: Quantidade de usuários registrados
- **Pedidos**: Quantidade de pedidos realizados

## 🔍 Logs de Teste

Todos os testes geram logs que mostram:

- ✅ **Sucesso**: Operações bem-sucedidas
- ❌ **Erro**: Falhas e problemas
- ⚠️ **Aviso**: Ações que requerem atenção
- 🔍 **Info**: Informações gerais

## 🚨 Troubleshooting

### Erro: "No Firebase App '[DEFAULT]' has been created"

**Solução:**

1. Verifique se `google-services.json` está em `android/app/`
2. Execute `flutter clean && flutter pub get`
3. Reinicie o app

### Erro: "Permission denied"

**Solução:**

1. Verifique as regras de segurança no Firebase Console
2. Configure as regras para permitir leitura/escrita
3. Verifique se o projeto está ativo

### Erro: "Network error"

**Solução:**

1. Verifique a conexão com a internet
2. Verifique se o projeto Firebase está ativo
3. Teste em dispositivo físico

## 📱 Próximos Passos

Após os testes bem-sucedidos:

1. **Migrar dados mock** para Firestore
2. **Atualizar ProdutosService** para usar Firestore
3. **Implementar autenticação** nas telas
4. **Configurar regras de segurança**
5. **Implementar sincronização em tempo real**

## 🔗 Links Úteis

- [Firebase Console](https://console.firebase.google.com)
- [Firestore Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Flutter Docs](https://firebase.flutter.dev/)

## 📝 Exemplo de Uso

```dart
// Navegar para a tela de teste
Navigator.pushNamed(context, '/firebase_test');

// Ou adicionar botão temporário na tela de login
ElevatedButton(
  onPressed: () => Navigator.pushNamed(context, '/firebase_test'),
  child: Text('Teste Firebase'),
)
```
