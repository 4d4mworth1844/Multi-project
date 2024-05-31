import 'package:flutter/material.dart';
import 'package:smartfarm/screens/automatic_settings.dart';
import 'package:smartfarm/screens/diagnostic.dart';
import 'package:smartfarm/screens/system_infomation.dart';
import 'package:smartfarm/widgets/banner.dart';
import 'package:smartfarm/widgets/custom_buttons.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            children: [
              const Banner_(),
              SizedBox(height: deviceSize.height * 0.04),
              //! Display message say hello to user
              Text('Welcome, ${userName}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              // SizedBox(height: deviceSize.height * 0.04),

              // ! List of main feature was presented by buttons
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomElevatedButton(
                      title: 'Thông số hệ thống',
                      icons: [
                        Icon(Icons.thermostat),
                        Icon(Icons.water_drop),
                        Icon(Icons.light_mode_sharp)
                      ],
                      destinationScreen: SystemInfoScreen(),
                    ),
                    CustomElevatedButton(
                      title: 'Thiết lập lịch vận hành',
                      icons: [Icon(Icons.settings)],
                      destinationScreen: AutomaticSettings(),
                    ),
                    CustomElevatedButton(
                      title: 'Dự đoán sức khoẻ của cây',
                      icons: [Icon(Icons.health_and_safety)],
                      destinationScreen: DiagnosticScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
