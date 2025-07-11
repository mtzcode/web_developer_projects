import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/services/firestore_auth_service.dart';

class Cadastro01Screen extends StatefulWidget {
  const Cadastro01Screen({super.key});

  @override
  State<Cadastro01Screen> createState() => _Cadastro01ScreenState();
}

class _Cadastro01ScreenState extends State<Cadastro01Screen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = FirestoreAuthService();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  String nome = '';
  String email = '';
  String whatsapp = '';
  String senha = '';
  String confirmarSenha = '';
  bool obscureSenha = true;
  bool obscureConfirmarSenha = true;
  bool isLoading = false;

  // Regex para validações
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  
  static final RegExp _whatsappRegex = RegExp(
    r'^\(?[1-9]{2}\)? ?(?:[2-8]|9[1-9])[0-9]{3}\-?[0-9]{4}$',
  );

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    whatsappController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final colorScheme = Theme.of(context).colorScheme;
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Cancelar cadastro'),
        content: const Text('Deseja realmente cancelar o cadastro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.secondary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
            ),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: colorScheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Sim'),
          ),
        ],
      ),
    ) ?? false;
  }

  // Validar força da senha
  String? _validarForcaSenha(String? senha) {
    if (senha == null || senha.isEmpty) {
      return 'Digite uma senha';
    }
    
    if (senha.length < 8) {
      return 'Senha deve ter pelo menos 8 caracteres';
    }
    
    bool temMaiuscula = senha.contains(RegExp(r'[A-Z]'));
    bool temMinuscula = senha.contains(RegExp(r'[a-z]'));
    bool temNumero = senha.contains(RegExp(r'[0-9]'));
    bool temCaractereEspecial = senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    int forca = 0;
    if (temMaiuscula) forca++;
    if (temMinuscula) forca++;
    if (temNumero) forca++;
    if (temCaractereEspecial) forca++;
    
    if (forca < 3) {
      return 'Senha deve conter pelo menos 3 tipos de caracteres (maiúscula, minúscula, número, especial)';
    }
    
    return null;
  }

  // Formatar WhatsApp
  String _formatarWhatsApp(String value) {
    // Remove tudo que não é número
    String numeros = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numeros.length <= 2) {
      return numeros;
    } else if (numeros.length <= 6) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2)}';
    } else if (numeros.length <= 10) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 6)}-${numeros.substring(6)}';
    } else {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7, 11)}';
    }
  }

  Future<void> _proximoPasso() async {
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();
    setState(() => isLoading = true);

    try {
      // Criar usuário no Firestore
      final usuario = await _authService.registrarUsuario(
        nome: nome,
        email: email.trim(),
        whatsapp: whatsapp,
        senha: senha,
      );
      
      if (mounted) {
        // Navegar para a próxima tela, passando os dados
        Navigator.pushNamed(context, '/cadastro02', arguments: {
          'userId': usuario.id,
          'nome': nome,
          'email': email,
          'whatsapp': whatsapp,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double horizontalPadding = MediaQuery.of(context).size.width > 500 ? 120 : 32;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro'),
          centerTitle: true,
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Cadastro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Passo 01 de 02',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.tertiary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Campo Nome
                  TextFormField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome completo',
                      hintText: 'Digite seu nome completo',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite seu nome completo';
                      }
                      if (value.trim().split(' ').length < 2) {
                        return 'Digite seu nome completo (nome e sobrenome)';
                      }
                      if (value.trim().length < 3) {
                        return 'Nome muito curto';
                      }
                      return null;
                    },
                    onSaved: (value) => nome = value?.trim() ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Campo Email
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'exemplo@email.com',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite seu e-mail';
                      }
                      if (!_emailRegex.hasMatch(value.trim())) {
                        return 'Digite um e-mail válido';
                      }
                      return null;
                    },
                    onSaved: (value) => email = value?.trim() ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Campo WhatsApp
                  TextFormField(
                    controller: whatsappController,
                    decoration: InputDecoration(
                      labelText: 'WhatsApp',
                      hintText: '(11) 99999-9999',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite seu WhatsApp';
                      }
                      String numeros = value.replaceAll(RegExp(r'[^\d]'), '');
                      if (numeros.length < 10) {
                        return 'WhatsApp deve ter pelo menos 10 dígitos';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        whatsapp = _formatarWhatsApp(value);
                      });
                    },
                    onSaved: (value) => whatsapp = value?.trim() ?? '',
                  ),
                  const SizedBox(height: 16),
                  // Campo Senha
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Mínimo 8 caracteres',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureSenha ? Icons.visibility : Icons.visibility_off,
                          color: colorScheme.tertiary,
                          semanticLabel: obscureSenha ? 'Mostrar senha' : 'Ocultar senha',
                        ),
                        onPressed: () {
                          setState(() {
                            obscureSenha = !obscureSenha;
                          });
                        },
                      ),
                    ),
                    obscureText: obscureSenha,
                    validator: _validarForcaSenha,
                    onChanged: (value) {
                      senha = value ?? '';
                    },
                    onSaved: (value) => senha = value ?? '',
                  ),
                  const SizedBox(height: 8),
                  // Dicas de senha
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sua senha deve conter:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Pelo menos 8 caracteres\n• Pelo menos 3 tipos: maiúscula, minúscula, número, especial',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo Confirmar Senha
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      hintText: 'Digite a senha novamente',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmarSenha ? Icons.visibility : Icons.visibility_off,
                          color: colorScheme.tertiary,
                          semanticLabel: obscureConfirmarSenha ? 'Mostrar senha' : 'Ocultar senha',
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmarSenha = !obscureConfirmarSenha;
                          });
                        },
                      ),
                    ),
                    obscureText: obscureConfirmarSenha,
                    onChanged: (value) {
                      confirmarSenha = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme sua senha';
                      }
                      if (value != senha) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                    onSaved: (value) => confirmarSenha = value ?? '',
                  ),
                  const SizedBox(height: 24),
                  // Botão Próximo
                  ElevatedButton(
                    onPressed: isLoading ? null : _proximoPasso,
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
                            'Próximo',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 