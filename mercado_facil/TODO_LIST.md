# 📋 Lista de To-Dos - Mercado Fácil

## 🚨 **PRIORIDADE ALTA (Segurança)**

### 1. Migrar para Firebase Auth

- [ ] Habilitar Firebase Auth no console
- [ ] Substituir `FirestoreAuthService` por Firebase Auth
- [ ] Atualizar regras de segurança para produção
- [ ] Testar login/logout com Firebase Auth
- [ ] Migrar dados existentes se necessário

### 2. Regras de Segurança de Produção

- [ ] Aplicar regras de `firestore.rules` (não as de desenvolvimento)
- [ ] Testar permissões de leitura/escrita
- [ ] Configurar validações server-side

## 🔧 **PRIORIDADE MÉDIA (Funcionalidades Core)**

### 3. Sistema de Pedidos

- [ ] Criar modelo `Pedido` (`lib/data/models/pedido.dart`)
- [ ] Criar `PedidoService` (`lib/data/services/pedido_service.dart`)
- [ ] Implementar tela de checkout (`lib/presentation/screens/checkout_screen.dart`)
- [ ] Implementar tela de histórico de pedidos (`lib/presentation/screens/pedidos_screen.dart`)
- [ ] Integrar com carrinho existente

### 4. Sistema de Pagamento

- [ ] Pesquisar e escolher gateway de pagamento (Mercado Pago, PagSeguro, etc.)
- [ ] Implementar integração com gateway escolhido
- [ ] Criar tela de pagamento (`lib/presentation/screens/pagamento_screen.dart`)
- [ ] Implementar validação de pagamento
- [ ] Testar fluxo completo

### 5. Notificações Push Funcionais

- [ ] Configurar Firebase Cloud Messaging
- [ ] Implementar serviço de notificações (`lib/data/services/notification_service.dart`)
- [ ] Criar tela de configurações de notificações 
- [ ] Testar envio de notificações push

## ⚡ **PRIORIDADE MÉDIA (Performance)**

### 6. Otimização de Cache

- [ ] Adicionar `cached_network_image` para imagens
- [ ] Implementar lazy loading para listas grandes
- [ ] Otimizar carregamento de produtos
- [ ] Implementar compressão de imagens

### 7. Busca e Filtros Avançados

- [ ] Implementar busca por nome de produto
- [ ] Adicionar filtros por categoria, preço, destaque
- [ ] Implementar ordenação (preço, nome, popularidade)
- [ ] Criar tela de busca avançada

## 🎨 **PRIORIDADE BAIXA (UX/UI)**

### 8. Melhorias Visuais

- [ ] Adicionar animações suaves (transições entre telas)
- [ ] Implementar skeleton loading
- [ ] Melhorar feedback visual (loading states)
- [ ] Adicionar micro-interações

### 9. Acessibilidade

- [ ] Melhorar semântica dos widgets
- [ ] Adicionar suporte a screen readers
- [ ] Implementar navegação por teclado
- [ ] Testar com diferentes tamanhos de fonte

## 🧪 **QUALIDADE E TESTES**

### 10. Testes Unitários

- [ ] Criar testes para `CarrinhoProvider`
- [ ] Criar testes para `UserProvider`
- [ ] Criar testes para `ProdutosService`
- [ ] Criar testes para `FirestoreAuthService`

### 11. Testes de Integração

- [ ] Testar fluxo completo de cadastro
- [ ] Testar fluxo completo de compra
- [ ] Testar carrinho com múltiplos usuários
- [ ] Testar cache e sincronização

### 12. Logging e Monitoramento

- [ ] Implementar logging estruturado
- [ ] Adicionar analytics (Firebase Analytics)
- [ ] Implementar crash reporting
- [ ] Monitorar performance

## 📱 **FUNCIONALIDADES ADICIONAIS**

### 13. Favoritos

- [ ] Implementar sistema de favoritos
- [ ] Criar tela de favoritos
- [ ] Sincronizar favoritos com Firestore
- [ ] Adicionar botão de favoritar nos produtos

### 14. Avaliações e Comentários

- [ ] Criar modelo de avaliação
- [ ] Implementar sistema de avaliações
- [ ] Criar tela de avaliações
- [ ] Mostrar avaliações nos produtos

### 15. Cupons e Descontos

- [ ] Implementar sistema de cupons
- [ ] Criar tela de cupons
- [ ] Aplicar descontos no carrinho
- [ ] Validar cupons

## 🚀 **PRODUÇÃO E DEPLOY**

### 16. Preparação para Produção

- [ ] Configurar variáveis de ambiente
- [ ] Otimizar bundle size
- [ ] Configurar CI/CD
- [ ] Preparar assets para produção

### 17. Documentação

- [ ] Criar README detalhado
- [ ] Documentar APIs
- [ ] Criar guia de deploy
- [ ] Documentar arquitetura

## 📊 **ANALYTICS E OTIMIZAÇÃO**

### 18. Analytics

- [ ] Implementar Firebase Analytics
- [ ] Rastrear eventos importantes
- [ ] Criar dashboard de métricas
- [ ] A/B testing

### 19. Machine Learning (Futuro)

- [ ] Implementar recomendações personalizadas
- [ ] Análise de comportamento do usuário
- [ ] Otimização de preços dinâmicos

## 🎯 **ROADMAP SUGERIDO**

### **Fase 1 (2-3 semanas): Segurança**

1. Migrar para Firebase Auth
2. Implementar regras de segurança
3. Testes de segurança

### **Fase 2 (3-4 semanas): Funcionalidades Core**

1. Sistema de pedidos
2. Integração de pagamento
3. Notificações push

### **Fase 3 (2-3 semanas): Performance**

1. Otimização de cache
2. Busca e filtros
3. Lazy loading

### **Fase 4 (1-2 semanas): UX/UI**

1. Animações
2. Melhorias visuais
3. Acessibilidade

### **Fase 5 (1-2 semanas): Qualidade**

1. Testes unitários
2. Testes de integração
3. Logging e monitoramento

## 📝 **NOTAS IMPORTANTES**

- **Prioridade**: Segurança > Funcionalidades Core > Performance > UX/UI
- **Estimativa**: 8-12 semanas para MVP completo
- **Recursos**: Firebase Auth, Gateway de Pagamento, Analytics
- **Testes**: Sempre testar cada funcionalidade antes de prosseguir

## 🎉 **CRITÉRIOS DE SUCESSO**

- [ ] App seguro para produção
- [ ] Fluxo completo de compra funcionando
- [ ] Performance otimizada
- [ ] UX/UI polida
- [ ] Testes cobrindo funcionalidades críticas
