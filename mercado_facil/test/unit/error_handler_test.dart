import 'package:flutter_test/flutter_test.dart';
import 'package:mercado_facil/core/error/error_handler.dart';
import 'package:mercado_facil/core/exceptions/app_exception.dart';

void main() {
  group('ErrorHandler', () {
    setUp(() {
      // Limpar callbacks antes de cada teste
      ErrorHandler.clearCallbacks();
    });

    group('Conversão de Erros', () {
      test('deve manter AppException inalterada', () {
        final originalException = AppException.networkError(
          message: 'Erro de rede',
          userMessage: 'Verifique sua conexão',
        );

        final converted = ErrorHandler._convertToAppException(
          originalException,
          null,
          'teste',
        );

        expect(converted, equals(originalException));
      });

      test('deve converter erro de rede', () {
        final error = 'Network error: connection failed';
        final converted = ErrorHandler._convertToAppException(
          error,
          null,
          'teste',
        );

        expect(converted.type, equals(ExceptionType.networkError));
        expect(converted.message, contains('teste'));
        expect(converted.message, contains(error));
      });

      test('deve converter erro de timeout', () {
        final error = 'Timeout: operation timed out';
        final converted = ErrorHandler._convertToAppException(
          error,
          null,
          'teste',
        );

        expect(converted.type, equals(ExceptionType.timeoutError));
        expect(converted.message, contains('teste'));
        expect(converted.message, contains(error));
      });

      test('deve converter erro de autenticação', () {
        final error = 'Auth error: invalid credentials';
        final converted = ErrorHandler._convertToAppException(
          error,
          null,
          'teste',
        );

        expect(converted.type, equals(ExceptionType.authenticationError));
        expect(converted.message, contains('teste'));
        expect(converted.message, contains(error));
      });

      test('deve converter erro do Firebase', () {
        final error = 'Firebase error: permission denied';
        final converted = ErrorHandler._convertToAppException(
          error,
          null,
          'teste',
        );

        expect(converted.type, equals(ExceptionType.firebaseError));
        expect(converted.message, contains('teste'));
        expect(converted.message, contains(error));
      });

      test('deve converter erro de validação', () {
        final error = 'Validation error: required field missing';
        final converted = ErrorHandler._convertToAppException(
          error,
          null,
          'teste',
        );

        expect(converted.type, equals(ExceptionType.validationError));
        expect(converted.message, contains('teste'));
        expect(converted.message, contains(error));
      });

      test('deve converter erro desconhecido', () {
        final error = 'Unknown error occurred';
        final converted = ErrorHandler._convertToAppException(
          error,
          null,
          'teste',
        );

        expect(converted.type, equals(ExceptionType.unknownError));
        expect(converted.message, contains('teste'));
        expect(converted.message, contains(error));
      });
    });

    group('Títulos de Erro', () {
      test('deve retornar títulos apropriados', () {
        expect(ErrorHandler._getErrorTitle(ExceptionType.networkError), equals('Erro de Conexão'));
        expect(ErrorHandler._getErrorTitle(ExceptionType.authenticationError), equals('Erro de Autenticação'));
        expect(ErrorHandler._getErrorTitle(ExceptionType.dataNotFound), equals('Item Não Encontrado'));
        expect(ErrorHandler._getErrorTitle(ExceptionType.validationError), equals('Dados Inválidos'));
        expect(ErrorHandler._getErrorTitle(ExceptionType.insufficientStock), equals('Estoque Insuficiente'));
        expect(ErrorHandler._getErrorTitle(ExceptionType.paymentError), equals('Erro no Pagamento'));
        expect(ErrorHandler._getErrorTitle(ExceptionType.firebaseError), equals('Erro do Sistema'));
        expect(ErrorHandler._getErrorTitle(ExceptionType.unknownError), equals('Erro'));
      });
    });

    group('Retry Mechanism', () {
      test('deve executar operação com sucesso na primeira tentativa', () async {
        int attempts = 0;
        final result = await ErrorHandler.executeWithRetry(
          operation: () async {
            attempts++;
            return 'sucesso';
          },
          operationName: 'teste',
          maxRetries: 3,
          showLoading: false,
        );

        expect(result, equals('sucesso'));
        expect(attempts, equals(1));
      });

      test('deve tentar novamente após falha', () async {
        int attempts = 0;
        final result = await ErrorHandler.executeWithRetry(
          operation: () async {
            attempts++;
            if (attempts < 3) {
              throw Exception('Erro temporário');
            }
            return 'sucesso';
          },
          operationName: 'teste',
          maxRetries: 3,
          showLoading: false,
        );

        expect(result, equals('sucesso'));
        expect(attempts, equals(3));
      });

      test('deve falhar após todas as tentativas', () async {
        int attempts = 0;
        
        expect(
          () => ErrorHandler.executeWithRetry(
            operation: () async {
              attempts++;
              throw Exception('Erro persistente');
            },
            operationName: 'teste',
            maxRetries: 2,
            showLoading: false,
          ),
          throwsA(isA<AppException>()),
        );

        expect(attempts, equals(2));
      });

      test('deve usar delay progressivo', () async {
        int attempts = 0;
        final stopwatch = Stopwatch()..start();
        
        await ErrorHandler.executeWithRetry(
          operation: () async {
            attempts++;
            if (attempts < 3) {
              throw Exception('Erro temporário');
            }
            return 'sucesso';
          },
          operationName: 'teste',
          maxRetries: 3,
          delay: Duration(milliseconds: 100),
          showLoading: false,
        );

        stopwatch.stop();
        
        // Deve ter pelo menos 300ms de delay (100 + 200)
        expect(stopwatch.elapsedMilliseconds, greaterThan(300));
        expect(attempts, equals(3));
      });
    });

    group('Fallback Operations', () {
      test('deve executar operação primária com sucesso', () async {
        int primaryAttempts = 0;
        int fallbackAttempts = 0;
        
        final result = await ErrorHandler.executeWithFallback(
          primaryOperation: () async {
            primaryAttempts++;
            return 'primário';
          },
          fallbackOperation: () async {
            fallbackAttempts++;
            return 'fallback';
          },
          operationName: 'teste',
        );

        expect(result, equals('primário'));
        expect(primaryAttempts, equals(1));
        expect(fallbackAttempts, equals(0));
      });

      test('deve executar fallback quando primário falha', () async {
        int primaryAttempts = 0;
        int fallbackAttempts = 0;
        
        final result = await ErrorHandler.executeWithFallback(
          primaryOperation: () async {
            primaryAttempts++;
            throw Exception('Erro primário');
          },
          fallbackOperation: () async {
            fallbackAttempts++;
            return 'fallback';
          },
          operationName: 'teste',
        );

        expect(result, equals('fallback'));
        expect(primaryAttempts, equals(1));
        expect(fallbackAttempts, equals(1));
      });

      test('deve falhar quando ambos falham', () async {
        int primaryAttempts = 0;
        int fallbackAttempts = 0;
        
        expect(
          () => ErrorHandler.executeWithFallback(
            primaryOperation: () async {
              primaryAttempts++;
              throw Exception('Erro primário');
            },
            fallbackOperation: () async {
              fallbackAttempts++;
              throw Exception('Erro fallback');
            },
            operationName: 'teste',
          ),
          throwsA(isA<Exception>()),
        );

        expect(primaryAttempts, equals(1));
        expect(fallbackAttempts, equals(1));
      });
    });

    group('Configuração', () {
      test('deve configurar callbacks corretamente', () {
        bool showErrorCalled = false;
        bool showLoadingCalled = false;
        bool navigateCalled = false;

        ErrorHandler.configure(
          showError: (message, {title, icon, color}) {
            showErrorCalled = true;
          },
          showLoading: (show) {
            showLoadingCalled = true;
          },
          navigate: (route, {arguments}) {
            navigateCalled = true;
          },
        );

        // Simular chamadas
        ErrorHandler._showErrorCallback?.call('teste');
        ErrorHandler._showLoadingCallback?.call(true);
        ErrorHandler._navigateCallback?.call('/teste');

        expect(showErrorCalled, isTrue);
        expect(showLoadingCalled, isTrue);
        expect(navigateCalled, isTrue);
      });

      test('deve limpar callbacks', () {
        ErrorHandler.configure(
          showError: (message, {title, icon, color}) {},
          showLoading: (show) {},
          navigate: (route, {arguments}) {},
        );

        ErrorHandler.clearCallbacks();

        expect(ErrorHandler._showErrorCallback, isNull);
        expect(ErrorHandler._showLoadingCallback, isNull);
        expect(ErrorHandler._navigateCallback, isNull);
      });
    });
  });
} 