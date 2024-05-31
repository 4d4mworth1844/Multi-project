import 'package:flutter/material.dart';

class Banner_ extends StatelessWidget {
  const Banner_({super.key});

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child:
            Image.asset('assets/img/banner-cover image.png', fit: BoxFit.cover),
      ),
    );
  }
}
