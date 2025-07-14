import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

/// Script para criar um usuário de teste no Firestore
/// 
/// Este script adiciona um usuário de teste diretamente no Firestore
/// para facilitar o desenvolvimento e testes.
/// 
/// Uso: dart run lib/scripts/create_test_user.dart

// Criptografar senha
String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<void> main() async {
  try {
    print('🚀 Inicializando Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado');

    final firestore = FirebaseFirestore.instance;
    final collection = 'usuarios';

    // Dados do usuário de teste
    const testUser = {
      'nome': 'Usuário Teste',
      'email': 'teste@teste.com',
      'whatsapp': '11999999999',
      'senhaHash': '', // Será calculada
      'dataCadastro': '', // Será definida
      'ativo': true,
      'cadastroCompleto': true,
    };

    // Calcular hash da senha
    const senha = '123456';
    final senhaHash = _hashPassword(senha);
    
    // Verificar se usuário já existe
    print('🔍 Verificando se usuário já existe...');
    final existingQuery = await firestore
        .collection(collection)
        .where('email', isEqualTo: testUser['email'])
        .get();
    
    if (existingQuery.docs.isNotEmpty) {
      print('⚠️  Usuário já existe!');
      print('📧 Email: ${testUser['email']}');
      print('🔑 Senha: $senha');
      print('🆔 ID: ${existingQuery.docs.first.id}');
      return;
    }

    // Criar documento com ID único
    final docRef = firestore.collection(collection).doc();
    
    // Criar dados do usuário
    final userData = {
      ...testUser,
      'senhaHash': senhaHash,
      'dataCadastro': DateTime.now().toIso8601String(),
    };

    // Salvar no Firestore
    print('💾 Salvando usuário de teste...');
    await docRef.set(userData);
    
    print('✅ Usuário de teste criado com sucesso!');
    print('📧 Email: ${testUser['email']}');
    print('🔑 Senha: $senha');
    print('🆔 ID: ${docRef.id}');
    print('');
    print('🎯 Agora você pode fazer login com essas credenciais!');
    
  } catch (e) {
    print('❌ Erro ao criar usuário de teste: $e');
    exit(1);
  }
} 