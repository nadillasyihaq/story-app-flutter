import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/common.dart';
import 'package:story_app_flutter/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
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
                        "Log In",
                        style: TextStyle(
                          fontFamily: "Pacifico",
                          fontSize: 30,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.loginSubTitle,
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.formEmailHint,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_rounded,
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
                          border: Border.all(width: .5, color: Colors.black38),
                        ),
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
                          _handleUserLogin(
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
                          child: context.watch<AuthProvider>().isLoadingLogin
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.logInText,
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
                              AppLocalizations.of(context)!.noAccount,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () => widget.onRegister(),
                              child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                child: Text(
                                  AppLocalizations.of(context)!.registerText,
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

  _handleUserLogin(String email, String password) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (email.isEmpty || password.isEmpty) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Center(
          child: Text(AppLocalizations.of(context)!.loginEmptyFieldMsg),
        ),
      ));
    } else {
      final authRead = context.read<AuthProvider>();
      final loginResult = await authRead.login(email, password);

      if (!mounted) return;

      if (loginResult) {
        widget.onLogin();

        scaffoldMessenger.showSnackBar(SnackBar(
          content: Center(
            child: Text(AppLocalizations.of(context)!.loginSuccess),
          ),
        ));
      } else {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Center(
            child: Text(AppLocalizations.of(context)!.loginFailed),
          ),
        ));
      }
    }
  }
}
