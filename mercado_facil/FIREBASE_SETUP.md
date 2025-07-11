# Configuração Firebase - Mercado Fácil

## 🔥 Visão Geral

Este guia explica como configurar o Firebase no projeto Mercado Fácil para autenticação, banco de dados e storage.

## 📋 Pré-requisitos

- Conta Google
- Projeto Flutter configurado
- Android Studio / VS Code

## 🚀 Passo a Passo

### 1. Criar Projeto Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Clique em "Criar projeto"
3. Nome: `mercado-facil`
4. Desative Google Analytics (opcional)
5. Clique em "Criar projeto"

### 2. Configurar App Android

1. No console do Firebase, clique em "Android"
2. Package name: `com.mtzcode.mercado_facil`
3. Clique em "Registrar app"
4. Baixe o arquivo `google-services.json`
5. Coloque o arquivo em `android/app/google-services.json`

### 3. Configurar App iOS (Opcional)

1. No console do Firebase, clique em "iOS"
2. Bundle ID: `com.mtzcode.mercadoFacil`
3. Clique em "Registrar app"
4. Baixe o arquivo `GoogleService-Info.plist`
5. Adicione ao projeto iOS via Xcode

### 4. Configurar App Web (Opcional)

1. No console do Firebase, clique em "Web"
2. Nickname: `mercado-facil-web`
3. Clique em "Registrar app"
4. Copie a configuração para usar depois

## 📁 Estrutura do Projeto

```
mercado_facil/
├── lib/
│   ├── data/
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   ├── firestore_service.dart
│   │   │   └── storage_service.dart
│   │   └── models/
│   └── presentation/
├── android/
│   └── app/
│       └── google-services.json
└── ios/
    └── Runner/
        └── GoogleService-Info.plist
```

## 🔧 Configurações

### Android (build.gradle.kts)

```kotlin
// android/app/build.gradle.kts
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Adicionar esta linha
}
```

```kotlin
// android/build.gradle.kts
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

### iOS (Podfile)

```ruby
# ios/Podfile
platform :ios, '12.0'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

## 📊 Estrutura do Firestore

### Coleções

#### produtos

```json
{
  "id": "produto_id",
  "nome": "Arroz Integral",
  "preco": 8.5,
  "imagemUrl": "https://...",
  "descricao": "Arroz integral orgânico",
  "categoria": "Grãos",
  "destaque": "oferta",
  "precoPromocional": 6.99,
  "ativo": true,
  "dataCriacao": "2024-01-01T00:00:00Z"
}
```

#### usuarios

```json
{
  "id": "user_id",
  "nome": "João Silva",
  "email": "joao@email.com",
  "telefone": "+5511999999999",
  "whatsapp": "+5511999999999",
  "enderecos": [],
  "dataCriacao": "2024-01-01T00:00:00Z"
}
```

#### favoritos

```json
{
  "id": "user_id_produto_id",
  "userId": "user_id",
  "produtoId": "produto_id",
  "dataAdicao": "2024-01-01T00:00:00Z"
}
```

#### pedidos

```json
{
  "id": "pedido_id",
  "userId": "user_id",
  "status": "pendente",
  "itens": [],
  "endereco": {},
  "total": 25.5,
  "dataCriacao": "2024-01-01T00:00:00Z"
}
```

## 🔐 Regras de Segurança Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários podem ler/escrever seus próprios dados
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Produtos são públicos para leitura
    match /produtos/{produtoId} {
      allow read: if true;
      allow write: if false; // Apenas admin
    }

    // Favoritos do usuário
    match /favoritos/{favoritoId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }

    // Pedidos do usuário
    match /pedidos/{pedidoId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## 🔐 Regras de Segurança Storage

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Imagens de produtos
    match /produtos/{allPaths=**} {
      allow read: if true;
      allow write: if false; // Apenas admin
    }

    // Fotos de perfil
    match /perfil/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null &&
        request.auth.uid == userId;
    }
  }
}
```

## 🧪 Testando a Configuração

### 1. Verificar Inicialização

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### 2. Testar Autenticação

```dart
final authService = AuthService();
try {
  await authService.createUserWithEmailAndPassword('teste@email.com', '123456');
  print('Usuário criado com sucesso!');
} catch (e) {
  print('Erro: $e');
}
```

### 3. Testar Firestore

```dart
final firestoreService = FirestoreService();
try {
  final produtos = await firestoreService.getProdutos();
  print('Produtos carregados: ${produtos.length}');
} catch (e) {
  print('Erro: $e');
}
```

## 🚨 Troubleshooting

### Erro: "No Firebase App '[DEFAULT]' has been created"

**Solução:**

1. Verifique se `google-services.json` está em `android/app/`
2. Verifique se o plugin está no `build.gradle.kts`
3. Execute `flutter clean && flutter pub get`

### Erro: "Permission denied"

**Solução:**

1. Verifique as regras de segurança do Firestore
2. Verifique se o usuário está autenticado
3. Verifique se o usuário tem permissão para a operação

### Erro: "Network error"

**Solução:**

1. Verifique a conexão com a internet
2. Verifique se o projeto Firebase está ativo
3. Verifique se as regras de segurança permitem a operação

## 📱 Próximos Passos

1. **Implementar autenticação** nas telas de login/registro
2. **Migrar dados mock** para Firestore
3. **Implementar upload de imagens** para Storage
4. **Configurar notificações push**
5. **Implementar sincronização em tempo real**

## 🔗 Links Úteis

- [Firebase Console](https://console.firebase.google.com)
- [Firebase Flutter Docs](https://firebase.flutter.dev/)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
