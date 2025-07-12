import 'package:flutter/material.dart';
import '../../data/services/firestore_auth_service.dart';
import '../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';
  bool obscureText = true;
  bool isLoading = false;
  final _authService = FirestoreAuthService();

  // Estados para feedback visual em tempo real
  bool emailValid = false;
  bool emailTouched = false;
  bool senhaValid = false;
  bool senhaTouched = false;

  // Regex para validação de email
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Função para validar email em tempo real
  void _validarEmailTempoReal(String? value) {
    if (value == null || value.trim().isEmpty) {
      setState(() {
        emailValid = false;
        emailTouched = true;
      });
      return;
    }
    
    final isValid = Validators.email(value) == null;
    setState(() {
      emailValid = isValid;
      emailTouched = true;
    });
  }

  // Função para validar senha em tempo real
  void _validarSenhaTempoReal(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        senhaValid = false;
        senhaTouched = true;
      });
      return;
    }
    
    final isValid = Validators.senha(value) == null;
    setState(() {
      senhaValid = isValid;
      senhaTouched = true;
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();
    setState(() => isLoading = true);
    
    try {
      await _authService.fazerLogin(email.trim(), senha);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/splash_produtos');
      }
    } catch (e) {
      if (mounted) {
        String mensagemErro = 'Erro ao fazer login';
        
        // Tratamento específico de erros do Firebase
        if (e.toString().contains('user-not-found')) {
          mensagemErro = 'Usuário não encontrado. Verifique seu e-mail.';
        } else if (e.toString().contains('wrong-password')) {
          mensagemErro = 'Senha incorreta. Tente novamente.';
        } else if (e.toString().contains('invalid-email')) {
          mensagemErro = 'E-mail inválido.';
        } else if (e.toString().contains('user-disabled')) {
          mensagemErro = 'Conta desabilitada. Entre em contato com o suporte.';
        } else if (e.toString().contains('too-many-requests')) {
          mensagemErro = 'Muitas tentativas. Tente novamente em alguns minutos.';
        } else if (e.toString().contains('network')) {
          mensagemErro = 'Erro de conexão. Verifique sua internet.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensagemErro),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _recuperarSenha() async {
    Navigator.pushNamed(context, '/redefinir_senha');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double horizontalPadding = MediaQuery.of(context).size.width > 500 ? 120 : 32;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                const SizedBox(height: 24),
                // Título
                Text(
                  'Bem-vindo de volta!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Faça login para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 32),
                // Campo Email
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'exemplo@email.com',
                    labelStyle: TextStyle(color: colorScheme.tertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: emailTouched
                        ? Icon(
                            emailValid ? Icons.check_circle : Icons.error,
                            color: emailValid ? Colors.green : Colors.red,
                          )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: emailTouched
                            ? (emailValid ? Colors.green : Colors.red)
                            : colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: Validators.email,
                  onChanged: _validarEmailTempoReal,
                  onSaved: (value) => email = value?.trim() ?? '',
                ),
                const SizedBox(height: 16),
                // Campo Senha
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Sua senha',
                    labelStyle: TextStyle(color: colorScheme.tertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (senhaTouched)
                          Icon(
                            senhaValid ? Icons.check_circle : Icons.error,
                            color: senhaValid ? Colors.green : Colors.red,
                          ),
                        IconButton(
                          icon: Icon(
                            obscureText ? Icons.visibility_off : Icons.visibility,
                            color: colorScheme.tertiary,
                            semanticLabel: obscureText ? 'Mostrar senha' : 'Ocultar senha',
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: senhaTouched
                            ? (senhaValid ? Colors.green : Colors.red)
                            : colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  obscureText: obscureText,
                  validator: Validators.senha,
                  onChanged: _validarSenhaTempoReal,
                  onSaved: (value) => senha = value ?? '',
                ),
                const SizedBox(height: 8),
                // Link "Esqueceu a senha?"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : _recuperarSenha,
                    child: Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Botão Entrar
                ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            semanticsLabel: 'Carregando',
                          ),
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 24),
                // Divisor
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.tertiary)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ou',
                        style: TextStyle(color: colorScheme.tertiary),
                      ),
                    ),
                    Expanded(child: Divider(color: colorScheme.tertiary)),
                  ],
                ),
                const SizedBox(height: 24),
                // Botão Cadastrar
                OutlinedButton(
                  onPressed: isLoading ? null : () {
                    Navigator.pushNamed(context, '/cadastro01');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Criar nova conta',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 