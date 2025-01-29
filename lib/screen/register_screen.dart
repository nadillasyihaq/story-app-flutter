import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/common.dart';
import 'package:story_app_flutter/provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscure = true;

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pink],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 40.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontFamily: "Pacifico",
                          fontSize: 30,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.registerSubTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border:
                                Border.all(width: .5, color: Colors.black38)),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.formNameHint,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _nameController.clear(),
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 15.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border:
                                Border.all(width: .5, color: Colors.black38)),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.formEmailHint,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.mail,
                              color: Colors.blue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _emailController.clear(),
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 15.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border:
                                Border.all(width: .5, color: Colors.black38)),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordObscure,
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.formPasswordHint,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordObscure = !_isPasswordObscure;
                                });
                              },
                              icon: Icon(
                                _isPasswordObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 15.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      ElevatedButton(
                        onPressed: () async {
                          _handleUserRegister(
                            _nameController.text,
                            _emailController.text,
                            _passwordController.text,
                          );

                          FocusScope.of(context).unfocus();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 15.0)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: context.watch<AuthProvider>().isLoadingRegister
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.registerText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.haveAccount,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () => widget.onLogin(),
                              child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                child: Text(
                                  AppLocalizations.of(context)!.logInText,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleUserRegister(String name, String email, String password) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
            content: Center(
          child: Text(AppLocalizations.of(context)!.registerEmptyFieldMsg),
        )),
      );

      if (password.length < 8) {
        scaffoldMessenger.showSnackBar(SnackBar(
            content: Center(
          child: Text(AppLocalizations.of(context)!.passwordValidation),
        )));
      }
    } else {
      final authRead = context.read<AuthProvider>();
      final registerResult = await authRead.userRegister(name, email, password);

      if (!mounted) return;

      if (registerResult) {
        widget.onRegister();

        scaffoldMessenger.showSnackBar(SnackBar(
          content: Center(
            child: Text(AppLocalizations.of(context)!.registerSuccess),
          ),
        ));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Center(
            child: Text(AppLocalizations.of(context)!.registerFailed),
          ),
        ));
      }
    }
  }
}
