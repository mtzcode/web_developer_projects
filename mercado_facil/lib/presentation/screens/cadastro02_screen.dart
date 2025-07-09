import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants.dart';

class Cadastro02Screen extends StatefulWidget {
  const Cadastro02Screen({super.key});

  @override
  State<Cadastro02Screen> createState() => _Cadastro02ScreenState();
}

class _Cadastro02ScreenState extends State<Cadastro02Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController ufController = TextEditingController();

  bool isLoading = false;
  String lastCepSearched = '';

  Future<void> buscarEndereco(String cep) async {
    setState(() { isLoading = true; });
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['erro'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP não encontrado!')),
        );
      } else {
        enderecoController.text = data['logradouro'] ?? '';
        bairroController.text = data['bairro'] ?? '';
        ufController.text = data['uf'] ?? '';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao buscar CEP!')),
      );
    }
    setState(() { isLoading = false; });
  }

  @override
  void initState() {
    super.initState();
    cepController.addListener(_onCepChanged);
  }

  void _onCepChanged() {
    final cep = cepController.text;
    if (cep.length == 8 && cep != lastCepSearched) {
      lastCepSearched = cep;
      buscarEndereco(cep);
    }
  }

  @override
  void dispose() {
    cepController.removeListener(_onCepChanged);
    cepController.dispose();
    enderecoController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    complementoController.dispose();
    ufController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(appName),
          centerTitle: true,
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
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
                    'Passo 02 de 02',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.tertiary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: cepController,
                    decoration: InputDecoration(
                      labelText: 'CEP',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o CEP';
                      }
                      if (value.length != 8) {
                        return 'CEP deve ter 8 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: enderecoController,
                          decoration: InputDecoration(
                            labelText: 'Endereço',
                            labelStyle: TextStyle(color: colorScheme.tertiary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite o endereço';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: numeroController,
                          decoration: InputDecoration(
                            labelText: 'Número',
                            labelStyle: TextStyle(color: colorScheme.tertiary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nº';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bairroController,
                    decoration: InputDecoration(
                      labelText: 'Bairro',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o bairro';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: complementoController,
                    decoration: InputDecoration(
                      labelText: 'Complemento (opcional)',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ufController,
                    decoration: InputDecoration(
                      labelText: 'UF',
                      labelStyle: TextStyle(color: colorScheme.tertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o UF';
                      }
                      if (value.length != 2) {
                        return 'UF deve ter 2 letras';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Após finalizar, navegar para a splash de produtos
                        Navigator.pushReplacementNamed(context, '/splash_produtos');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Finalizar',
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