# 🧪 **Guia de Testes - Sistema de Autenticação**

## **📋 Checklist de Testes**

### **🔐 1. TESTE DE CADASTRO (Cadastro01Screen)**

#### **✅ Validações de Campos:**

**Nome:**

- [ ] Campo vazio → "Digite seu nome completo"
- [ ] Apenas nome → "Digite seu nome completo (nome e sobrenome)"
- [ ] Nome muito curto → "Nome muito curto"
- [ ] Nome válido → Passa na validação

**Email:**

- [ ] Campo vazio → "Digite seu e-mail"
- [ ] Email sem @ → "Digite um e-mail válido"
- [ ] Email inválido (ex: "teste") → "Digite um e-mail válido"
- [ ] Email válido → Passa na validação

**WhatsApp:**

- [ ] Campo vazio → "Digite seu WhatsApp"
- [ ] Menos de 10 dígitos → "WhatsApp deve ter pelo menos 10 dígitos"
- [ ] Formatação automática → "(11) 99999-9999"
- [ ] WhatsApp válido → Passa na validação

**Senha:**

- [ ] Campo vazio → "Digite uma senha"
- [ ] Menos de 8 caracteres → "Senha deve ter pelo menos 8 caracteres"
- [ ] Senha fraca (só letras) → "Senha deve conter pelo menos 3 tipos..."
- [ ] Senha forte → Passa na validação

**Confirmar Senha:**

- [ ] Campo vazio → "Confirme sua senha"
- [ ] Senhas diferentes → "As senhas não coincidem"
- [ ] Senhas iguais → Passa na validação

#### **✅ Funcionalidades:**

**Toggle de Visibilidade:**

- [ ] Botão olho na senha → Mostra/oculta senha
- [ ] Botão olho na confirmação → Mostra/oculta confirmação

**Formatação:**

- [ ] WhatsApp formata automaticamente
- [ ] Nome capitaliza palavras

**Navegação:**

- [ ] Botão voltar → Diálogo de confirmação
- [ ] Cancelar cadastro → Volta para login
- [ ] Continuar cadastro → Vai para Cadastro02

### **🔐 2. TESTE DE LOGIN (LoginScreen)**

#### **✅ Validações:**

**Email:**

- [ ] Campo vazio → "Digite seu e-mail"
- [ ] Email inválido → "Digite um e-mail válido"
- [ ] Email válido → Passa na validação

**Senha:**

- [ ] Campo vazio → "Digite sua senha"
- [ ] Senha válida → Passa na validação

#### **✅ Cenários de Login:**

**Usuário Existente:**

- [ ] Email correto + senha correta → Login bem-sucedido
- [ ] Email correto + senha errada → "Senha incorreta"
- [ ] Email inexistente → "Usuário não encontrado"

**Erros de Rede:**

- [ ] Sem internet → "Erro de conexão"
- [ ] Muitas tentativas → "Muitas tentativas"

#### **✅ Funcionalidades:**

**Recuperação de Senha:**

- [ ] Email vazio → "Digite seu e-mail para recuperar"
- [ ] Email inválido → "Digite um e-mail válido"
- [ ] Email válido → Navega para RedefinirSenhaScreen

**Navegação:**

- [ ] "Criar nova conta" → Vai para Cadastro01
- [ ] "Teste Firebase" → Vai para FirebaseTestScreen

### **🔐 3. TESTE DE REDEFINIÇÃO DE SENHA (RedefinirSenhaScreen)**

#### **✅ Validações:**

**Email:**

- [ ] Campo vazio → "Digite seu e-mail"
- [ ] Email inválido → "Digite um e-mail válido"
- [ ] Email válido → Passa na validação

#### **✅ Cenários:**

**Email Existente:**

- [ ] Email válido → Diálogo de sucesso
- [ ] Email inexistente → "E-mail não encontrado"

**Navegação:**

- [ ] "Voltar ao Login" → Volta para LoginScreen
- [ ] Sucesso → Volta para LoginScreen

### **🔐 4. TESTE DE FLUXO COMPLETO**

#### **✅ Cenário 1: Novo Usuário**

1. [ ] Abrir app → Tela de login
2. [ ] Clicar "Criar nova conta" → Cadastro01
3. [ ] Preencher dados válidos
4. [ ] Clicar "Próximo" → Cadastro02
5. [ ] Completar cadastro → Volta para produtos
6. [ ] Fazer logout → Volta para login
7. [ ] Fazer login com dados criados → Sucesso

#### **✅ Cenário 2: Usuário Existente**

1. [ ] Abrir app → Tela de login
2. [ ] Inserir credenciais válidas
3. [ ] Login bem-sucedido → Tela de produtos
4. [ ] Fazer logout → Volta para login

#### **✅ Cenário 3: Recuperação de Senha**

1. [ ] Abrir app → Tela de login
2. [ ] Clicar "Esqueceu a senha?" → RedefinirSenhaScreen
3. [ ] Inserir email válido
4. [ ] Clicar "Enviar Email" → Diálogo de sucesso
5. [ ] Voltar para login

### **🔐 5. TESTE DE ERROS E EDGE CASES**

#### **✅ Validações Extremas:**

**Cadastro:**

- [ ] Nome com caracteres especiais
- [ ] Email com múltiplos pontos
- [ ] WhatsApp com espaços
- [ ] Senha com caracteres especiais
- [ ] Campos muito longos

**Login:**

- [ ] Tentativas múltiplas de login
- [ ] Copiar/colar em campos
- [ ] Navegação rápida entre telas

### **🔐 6. TESTE DE PERFORMANCE**

#### **✅ Responsividade:**

- [ ] Carregamento rápido das telas
- [ ] Validações instantâneas
- [ ] Transições suaves
- [ ] Estados de loading apropriados

### **🔐 7. TESTE DE ACESSIBILIDADE**

#### **✅ Usabilidade:**

- [ ] Campos com labels claros
- [ ] Mensagens de erro compreensíveis
- [ ] Contraste adequado
- [ ] Tamanhos de fonte apropriados

---

## **📝 Como Executar os Testes:**

1. **Execute o app**: `flutter run`
2. **Siga o checklist** item por item
3. **Marque ✅** cada teste que passar
4. **Anote problemas** encontrados
5. **Teste em diferentes dispositivos** se possível

## **🐛 Problemas Comuns a Verificar:**

- [ ] Campos não salvam dados corretamente
- [ ] Validações não funcionam em tempo real
- [ ] Mensagens de erro não aparecem
- [ ] Navegação entre telas falha
- [ ] Firebase não conecta
- [ ] Emails não são enviados

## **✅ Critérios de Sucesso:**

- [ ] Todos os campos validam corretamente
- [ ] Usuários podem se cadastrar sem erros
- [ ] Login funciona para usuários existentes
- [ ] Recuperação de senha envia emails
- [ ] Navegação entre telas é fluida
- [ ] Mensagens de erro são claras
- [ ] App não trava ou fecha inesperadamente
