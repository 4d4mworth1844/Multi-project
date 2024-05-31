import 'package:flutter/material.dart';
import 'package:smartfarm/screens/mainpage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // initially password is obscure
  bool _obscureText = true;
  FocusNode textSecondFocusNode = FocusNode();

  void _onTogglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showFailedMessage(context) {
    SnackBar snackBar = SnackBar(
      content: Text('Username/Password is worng!',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onError)),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _usernameField() {
    return TextFormField(
      controller: _usernameController,
      validator: (username) {
        if (username == null || username.isEmpty) {
          return 'Please enter your valid username';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Username',
        icon: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Icon(Icons.account_circle),
        ),
      ),
      onSaved: (value) => setState(() {
        _usernameController.text = value!;
      }),
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(textSecondFocusNode);
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      validator: (password) {
        if (password == null || password.isEmpty || password.length < 8) {
          return 'Please enter valid password';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Password',
        icon: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Icon(Icons.lock),
        ),
      ),
      obscureText: _obscureText,
      onSaved: (value) => setState(() {
        _passwordController.text = value!;
      }),
      focusNode: textSecondFocusNode,
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        final isValid = _formKey.currentState!.validate();
        _formKey.currentState!.save();
        if (isValid) {
          // TODO: check database for identifying user
          bool isCorrect = true;
          if (isCorrect) {
            // TODO: navigate to next page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) =>
                    const MainPageScreen(userName: 'Tri Mai-Quoc'),
              ),
            );
          } else {
            setState(() {
              _usernameController.clear();
              _passwordController.clear();
            });
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary),
        foregroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.onPrimary),
      ),
      child: const Text('Login'),
    );
  }

  @override
  void initState() {
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 250,
      child: Stack(
        children: [
          SizedBox(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    _usernameField(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: _passwordField()),
                        IconButton(
                          onPressed: () {
                            _onTogglePassword();
                          },
                          icon: const Icon(Icons.remove_red_eye_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _submitButton(),
          ),
        ],
      ),
    );
  }
}

//
