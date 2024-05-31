import 'package:flutter/material.dart';
import 'dart:async';

// import 'package:smartfarm/models/feed_metadata.dart';
import 'package:smartfarm/networks/button_requester.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.icons,
    required this.destinationScreen,
  });

  final String title;
  final List<Icon> icons;
  final Widget destinationScreen;

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => destinationScreen));
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.all(20),
        fixedSize: Size.fromWidth(deviceSize.width * 0.7),
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.onBackground,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [...icons],
          ),
          // const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.fill,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 20,
                  ),
            ),
          ),
        ],
      ), // ),
    );
  }
}

class CustomSwitchButton extends StatefulWidget {
  const CustomSwitchButton({
    super.key,
    required this.deviceName,
    required this.feedKey,
  });

  final String deviceName;
  final String feedKey;

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return SizedBox(
      width: deviceSize.width * 0.45,
      height: deviceSize.height * 0.3,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RealTimeButton(feedKey: widget.feedKey),
          Text(
            widget.deviceName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class _RealTimeButton extends StatefulWidget {
  const _RealTimeButton({super.key, required this.feedKey});

  final String feedKey;

  @override
  State<StatefulWidget> createState() {
    return _RealTimeButtonState();
  }
}

class _RealTimeButtonState extends State<_RealTimeButton> {
  late ButtonRequester requester;
  late Stream<bool> stream;

  @override
  void initState() {
    super.initState();
    requester = ButtonRequester(widget.feedKey);
    stream = requester.stateStream(100);
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ToggleSwitch(
            minWidth: deviceSize.width * 0.2,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.red[800]!],
              [Colors.green[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: snapshot.data! ? 1 : 0,
            animate: true,
            animationDuration: 100,
            totalSwitches: 2,
            labels: const ['Tắt', 'Bật'],
            radiusStyle: true,
            onToggle: (index) {
              requester.updateButton();
            },
          );
        } else {
          return Container(
            width: deviceSize.width * 0.45,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow,
            ),
            child: const Center(
              child: Text('waiting'),
            ),
          );
        }
      },
    );
  }
} 


