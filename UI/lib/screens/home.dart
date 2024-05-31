import 'package:flutter/material.dart';
import 'package:smartfarm/widgets/banner.dart';
import 'package:smartfarm/widgets/login_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Column(
            children: [
              const Banner_(),
              const SizedBox(height: 30),
              Text(
                'Welcome to iSmartFarm!',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 30),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
