import 'package:flutter/material.dart';
import 'package:menu_core/core/exceptions/client_invalid_exception.dart';
import 'package:menu_core/core/exceptions/invalid_email_exception.dart';
import 'package:menu_core/core/exceptions/password_invalid_exception.dart';
import 'package:menu_core/core/exceptions/user_not_found_exception.dart';
import 'package:menu_core/core/model/UserModel.dart';
import 'package:menu_core/widgets/menu_loading.dart';
import 'package:menu_core/widgets/menu_logo.dart';
import 'package:menu_core/widgets/toasts/toast_utils.dart';
import 'package:my_place_admin/pages/cart/cart_controller.dart';
import 'package:my_place_admin/pages/home/home_page.dart';
import 'package:provider/provider.dart';

import '../sign_up/sign_up_page.dart';
import 'sign_in_controller.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = SignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
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
                            Icons.mail,
                            size: 24,
                          ),
                        ),
                        obscureText: true,
                        validator: (senha) =>
                            senha.isEmpty ? 'Campo Obrigatório' : null,
                        onSaved: _controller.setSenha,
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
                                final usuario = await _controller.fazLogin();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => Provider<UserModel>(
                                      create: (_) => usuario,
                                      child: Provider<CartController>( // *provider* resgata o carrinho em qualquer canto da aplicação
                                        create: (_) => CartController(usuario),
                                        child: HomePage(),
                                      ),
                                    ),
                                  ),
                                );
                              } on UserNotFoundException {
                                showWarningToast(
                                    'Usuário e/ou senha inválido.');
                              } on PasswordInvalidException {
                                showWarningToast(
                                    'Usuário e/ou senha inválido.');
                              } on InvalidEmailException {
                                showWarningToast('Email inválido');
                              } on ClientInvalidException {
                                showWarningToast('Este usuário não é cliente');
                              } on Exception {
                                showErrorToast('Ocorreu um erro inesperado.');
                              } finally {
                                setState(() {
                                  _controller.setIsLoading(false);
                                });
                              }
                            }
                          },
                          child: Text('Entrar'),
                        ),
                      ),
                      Container(
                        width: 120,
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text('Cadastrar'),
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
