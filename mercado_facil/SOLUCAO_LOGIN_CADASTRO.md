# Solução para Problemas de Login e Cadastro

## Problema Identificado

O erro `PERMISSION_DENIED` indica que as regras de segurança do Firestore estão bloqueando consultas na coleção `usuarios`. Isso impede tanto o login quanto o cadastro de novos usuários.

## Solução Imediata (Desenvolvimento)

### 1. Aplicar Regras de Desenvolvimento

Copie o conteúdo do arquivo `firestore_dev.rules` e aplique no Firebase Console:

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Selecione seu projeto `mercadofacilweb`
3. Vá para **Firestore Database** → **Rules**
4. Substitua as regras atuais pelo conteúdo de `firestore_dev.rules`
5. Clique em **Publish**

### 2. Testar Login e Cadastro

Após aplicar as regras, teste:

- Login com usuário existente
- Cadastro de novo usuário
- Verificação se o app funciona normalmente

## Solução de Produção (Quando estiver pronto)

### 1. Regras de Produção Seguras

Use o arquivo `firestore.rules` que contém regras mais seguras:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Regras para coleção de usuários
    match /usuarios/{userId} {
      // Permitir leitura de todos os documentos para consultas de login
      allow read: if request.auth != null;

      // Permitir escrita apenas do próprio documento
      allow write: if request.auth != null && request.auth.uid == userId;

      // Permitir criação de novos documentos (cadastro)
      allow create: if request.auth != null;
    }

    // Regras para coleção de produtos (leitura pública)
    match /produtos/{produtoId} {
      allow read: if true; // Leitura pública
      allow write: if request.auth != null; // Escrita apenas para usuários autenticados
    }

    // Regras para coleção de endereços
    match /enderecos/{enderecoId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // Regras para coleção de carrinhos (por usuário)
    match /carrinhos/{carrinhoId} {
      allow read, write: if request.auth != null && request.auth.uid == carrinhoId;
    }

    // Regras para outras coleções (pedidos, etc.)
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 2. Configurar Autenticação Firebase

Para usar as regras de produção, você precisará:

1. **Habilitar Firebase Auth** no console
2. **Configurar métodos de autenticação** (Email/Senha)
3. **Modificar o código** para usar Firebase Auth em vez de autenticação customizada

## Passos para Resolver Agora

### Opção 1: Usar Regras de Desenvolvimento (Recomendado para testes)

1. Aplique as regras de `firestore_dev.rules`
2. Teste login e cadastro
3. Continue desenvolvendo normalmente

### Opção 2: Migrar para Firebase Auth (Para produção)

1. Habilitar Firebase Auth no console
2. Modificar o código para usar Firebase Auth
3. Aplicar regras de produção

## Verificação

Após aplicar as regras de desenvolvimento, você deve conseguir:

- ✅ Fazer login com usuários existentes
- ✅ Cadastrar novos usuários
- ✅ Acessar todas as funcionalidades do app
- ✅ Usar o carrinho normalmente

## Próximos Passos

1. **Agora**: Aplique as regras de desenvolvimento
2. **Teste**: Verifique se login e cadastro funcionam
3. **Desenvolvimento**: Continue trabalhando no app
4. **Produção**: Quando estiver pronto, migre para Firebase Auth + regras seguras

## Comandos Úteis

```bash
# Para aplicar regras via CLI (se tiver Firebase CLI instalado)
firebase deploy --only firestore:rules

# Para verificar status do Firebase
firebase projects:list
```

## Suporte

Se ainda houver problemas após aplicar as regras:

1. Verifique se as regras foram publicadas corretamente
2. Aguarde alguns minutos para propagação
3. Limpe o cache do app
4. Teste novamente
