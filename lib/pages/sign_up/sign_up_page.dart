import 'package:flutter/material.dart';
import 'package:menu_core/core/exceptions/email_already_registered.dart';
import 'package:menu_core/core/exceptions/invalid_email_exception.dart';
import 'package:menu_core/core/exceptions/weak_password_exception.dart';
import 'package:menu_core/widgets/menu_loading.dart';
import 'package:menu_core/widgets/menu_logo.dart';
import 'package:menu_core/widgets/toasts/toast_utils.dart';
import 'package:my_place_admin/pages/sign_up/sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignUpController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: _controller.isLoading
                ? Center(
                    child: MenuLoading(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuLogo(),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nome',
                            prefixIcon: Icon(
                              Icons.person,
                              size: 24,
                            ),
                          ),
                          validator: (nome) =>
                              nome.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: _controller.setNome,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(
                              Icons.mail,
                              size: 24,
                            ),
                          ),
                          validator: (email) =>
                              email.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: _controller.setEmail,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 24,
                            ),
                          ),
                          obscureText: true,
                          onChanged: _controller.setSenha,
                          validator: (senha) =>
                              senha.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: _controller.setSenha,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Repita a Senha',
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 24,
                            ),
                          ),
                          obscureText: true,
                          validator: _controller.validaSenhaRepetida,
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: 120,
                          child: OutlineButton(
                            onPressed: () async {
                              final form = _formKey.currentState;
                              if (form.validate()) {
                                form.save();

                                setState(() {
                                  _controller.setIsLoading(true);
                                });
                                try {
                                  await _controller.criaUsuario();
                                  showSuccessToast('Usuário criado com sucesso!');
                                  Navigator.of(context).pop();
                                } on InvalidEmailException {
                                  showWarningToast(
                                      'O formato do e-mail é inválido.');
                                } on WeakPasswordException {
                                  showWarningToast(
                                      'A senha escolhida deve ter no mínimo 6 caracteres.');
                                } on EmailAlreadyRegistered {
                                  showWarningToast(
                                      'Email já está em uso! Por favor escolha outro.');
                                } on Exception {
                                  showErrorToast('Ocorreu um erro inesperado.');
                                } finally {
                                  setState(() {
                                    _controller.setIsLoading(false);
                                  });
                                }
                              }
                            },
                            child: Text('Confirmar'),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: OutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Voltar'),
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
