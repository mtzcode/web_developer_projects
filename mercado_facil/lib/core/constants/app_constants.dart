/// Constantes centralizadas do aplicativo
class AppConstants {
  // Configurações gerais
  static const String appName = 'Mercado Fácil';
  static const String appVersion = '1.0.0';
  
  // Timeouts e delays
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Limites e validações
  static const int maxRetryAttempts = 3;
  static const int maxSearchResults = 50;
  static const int maxCartItems = 99;
  
  // Formatação
  static const String currencySymbol = 'R\$';
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Mensagens padrão
  static const String loadingMessage = 'Carregando...';
  static const String errorMessage = 'Ocorreu um erro. Tente novamente.';
  static const String successMessage = 'Operação realizada com sucesso!';
  static const String noDataMessage = 'Nenhum dado encontrado.';
  
  // URLs e endpoints
  static const String baseApiUrl = 'https://api.mercadofacil.com';
  static const String cepApiUrl = 'https://viacep.com.br/ws';
  
  // Chaves de cache
  static const String userCacheKey = 'user_data';
  static const String cartCacheKey = 'cart_data';
  static const String productsCacheKey = 'products_data';
  static const String addressCacheKey = 'address_data';
  
  // Configurações de paginação
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Configurações de cache
  static const Duration defaultCacheDuration = Duration(hours: 1);
  static const Duration shortCacheDuration = Duration(minutes: 15);
  static const Duration longCacheDuration = Duration(days: 7);
} 