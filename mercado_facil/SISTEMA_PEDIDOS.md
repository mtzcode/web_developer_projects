# Sistema de Pedidos - Mercado Fácil

## Visão Geral

O sistema de pedidos do Mercado Fácil foi implementado com funcionalidades completas para gerenciar todo o ciclo de vida de um pedido, desde a criação até a entrega.

## Funcionalidades Implementadas

### 1. Modelo de Dados

#### Pedido (`lib/data/models/pedido.dart`)

- **Campos principais:**
  - `id`: Identificador único do pedido
  - `usuarioId`: ID do usuário que fez o pedido
  - `itens`: Lista de itens do carrinho
  - `subtotal`: Valor dos itens
  - `taxaEntrega`: Taxa de entrega (fixa em R$ 5,00)
  - `total`: Valor total do pedido
  - `enderecoEntrega`: Endereço de entrega
  - `observacoes`: Observações opcionais
  - `status`: Status atual do pedido
  - `dataCriacao`: Data de criação
  - `dataConfirmacao`: Data de confirmação
  - `dataEntrega`: Data de entrega
  - `metodoPagamento`: Método de pagamento escolhido
  - `codigoRastreamento`: Código de rastreamento

#### Status do Pedido

- `pendente`: Pedido criado, aguardando confirmação
- `confirmado`: Pedido confirmado pelo estabelecimento
- `emPreparacao`: Pedido em preparação
- `emEntrega`: Pedido em trânsito
- `entregue`: Pedido entregue
- `cancelado`: Pedido cancelado

### 2. Serviços

#### PedidosService (`lib/data/services/pedidos_service.dart`)

- **Criar pedido**: Converte carrinho em pedido
- **Buscar pedidos**: Lista pedidos do usuário
- **Buscar pedido específico**: Detalhes de um pedido
- **Atualizar status**: Mudança de status do pedido
- **Cancelar pedido**: Cancelamento de pedidos
- **Adicionar rastreamento**: Código de rastreamento
- **Streams em tempo real**: Atualizações automáticas
- **Estatísticas**: Dados de pedidos do usuário

#### PedidosProvider (`lib/data/services/pedidos_provider.dart`)

- Gerenciamento de estado dos pedidos
- Filtros por status
- Tratamento de erros
- Loading states

### 3. Telas Implementadas

#### PedidosScreen (`lib/presentation/screens/pedidos_screen.dart`)

- **Funcionalidades:**
  - Lista de pedidos com tabs por status
  - Cards informativos com resumo
  - Botão de cancelamento para pedidos elegíveis
  - Pull-to-refresh
  - Estados de loading e erro
  - Navegação para detalhes

#### DetalhesPedidoScreen (`lib/presentation/screens/detalhes_pedido_screen.dart`)

- **Funcionalidades:**
  - Informações completas do pedido
  - Timeline visual do progresso
  - Lista detalhada de itens
  - Endereço de entrega
  - Resumo financeiro
  - Observações
  - Código de rastreamento
  - Botões de ação (cancelar)

#### ConfirmacaoPedidoScreen (`lib/presentation/screens/confirmacao_pedido_screen.dart`)

- **Funcionalidades:**
  - Resumo do carrinho
  - Seleção de endereço de entrega
  - Escolha de método de pagamento
  - Campo de observações
  - Termos e condições
  - Validação de formulário
  - Finalização do pedido

### 4. Widgets

#### PedidoStatusWidget (`lib/presentation/widgets/pedido_status_widget.dart`)

- Exibição visual do status
- Timeline do progresso do pedido
- Indicadores visuais por etapa
- Datas de cada etapa

### 5. Integração

#### Atualizações no Main

- Adicionado `PedidosProvider` ao MultiProvider
- Configurado proxy provider para usuário
- Novas rotas implementadas

#### Atualizações no Carrinho

- Botão "Finalizar Pedido" navega para confirmação
- Integração com sistema de pedidos

#### Atualizações na Navegação

- Menu "Meus Pedidos" funcional
- Rotas configuradas

### 6. Segurança

#### Regras do Firestore (`firestore.rules`)

- **Pedidos:**
  - Leitura apenas do próprio pedido
  - Criação apenas do próprio usuário
  - Atualização apenas do próprio pedido
  - Exclusão apenas do próprio pedido

## Fluxo de Pedido

### 1. Criação do Pedido

1. Usuário adiciona produtos ao carrinho
2. Navega para "Finalizar Pedido"
3. Preenche dados de confirmação
4. Aceita termos e condições
5. Confirma pedido
6. Sistema cria pedido no Firestore
7. Carrinho é limpo automaticamente

### 2. Acompanhamento

1. Usuário acessa "Meus Pedidos"
2. Visualiza lista por status
3. Clica em pedido para ver detalhes
4. Acompanha progresso via timeline
5. Pode cancelar pedidos elegíveis

### 3. Atualizações de Status

- **Pendente → Confirmado**: Estabelecimento confirma
- **Confirmado → Em Preparação**: Inicia preparação
- **Em Preparação → Em Entrega**: Sai para entrega
- **Em Entrega → Entregue**: Entrega realizada
- **Qualquer → Cancelado**: Cancelamento

## Recursos Técnicos

### Performance

- Streams em tempo real para atualizações
- Cache local para melhor experiência
- Paginação para listas grandes
- Loading states para feedback

### UX/UI

- Design moderno e intuitivo
- Feedback visual de status
- Estados de loading e erro
- Pull-to-refresh
- Navegação fluida

### Segurança

- Validação de dados
- Regras de Firestore
- Autenticação obrigatória
- Isolamento por usuário

## Próximos Passos

### Funcionalidades Futuras

1. **Notificações push** para atualizações de status
2. **Pagamento integrado** (PIX, cartões)
3. **Avaliação de pedidos** após entrega
4. **Histórico detalhado** com filtros avançados
5. **Reordenação** de pedidos anteriores
6. **Chat de suporte** para pedidos
7. **Rastreamento em tempo real** via GPS

### Melhorias Técnicas

1. **Testes unitários** para serviços
2. **Testes de integração** para fluxos
3. **Monitoramento** de performance
4. **Analytics** de comportamento
5. **Backup automático** de dados

## Como Usar

### Para Desenvolvedores

1. Importe os providers necessários
2. Use `PedidosProvider` para gerenciar estado
3. Navegue para `/pedidos` para lista
4. Use `/confirmacao-pedido` para finalizar
5. Implemente regras de Firestore adequadas

### Para Usuários

1. Adicione produtos ao carrinho
2. Clique em "Finalizar Pedido"
3. Preencha dados de entrega
4. Escolha método de pagamento
5. Confirme o pedido
6. Acompanhe pelo menu "Meus Pedidos"

## Arquivos Principais

```
lib/
├── data/
│   ├── models/
│   │   └── pedido.dart
│   └── services/
│       ├── pedidos_service.dart
│       └── pedidos_provider.dart
├── presentation/
│   ├── screens/
│   │   ├── pedidos_screen.dart
│   │   ├── detalhes_pedido_screen.dart
│   │   └── confirmacao_pedido_screen.dart
│   └── widgets/
│       └── pedido_status_widget.dart
└── main.dart (atualizado)
```

## Conclusão

O sistema de pedidos está completo e funcional, oferecendo uma experiência completa de e-commerce com:

- ✅ Criação de pedidos
- ✅ Acompanhamento de status
- ✅ Timeline visual
- ✅ Cancelamento de pedidos
- ✅ Integração com carrinho
- ✅ Segurança implementada
- ✅ UX/UI moderna
- ✅ Performance otimizada

O sistema está pronto para uso em produção e pode ser facilmente expandido com novas funcionalidades conforme necessário.
