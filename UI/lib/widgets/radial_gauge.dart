import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:smartfarm/networks/sensor_requester.dart';
import 'package:smartfarm/models/data.dart';

enum GaugeType { temperture, humidity, light }

class Range {
  final ranges;
  // Named constructor
  Range.temperture()
      : ranges = <GaugeRange>[
          GaugeRange(startValue: 0, endValue: 14, color: Colors.blue[400]),
          GaugeRange(startValue: 15, endValue: 40, color: Colors.green[400]),
          GaugeRange(startValue: 41, endValue: 70, color: Colors.orange[400]),
          GaugeRange(startValue: 71, endValue: 100, color: Colors.red[400]),
        ];

  Range.humidity()
      : ranges = <GaugeRange>[
          GaugeRange(startValue: 0, endValue: 20, color: Colors.blue[400]),
          GaugeRange(startValue: 21, endValue: 40, color: Colors.green[400]),
          GaugeRange(startValue: 41, endValue: 60, color: Colors.orange[400]),
          GaugeRange(startValue: 61, endValue: 80, color: Colors.yellow[400]),
          GaugeRange(startValue: 81, endValue: 100, color: Colors.red[400]),
        ];

  Range.light()
      : ranges = <GaugeRange>[
          GaugeRange(startValue: 0, endValue: 20, color: Colors.blue[400]),
          GaugeRange(startValue: 21, endValue: 40, color: Colors.green[400]),
          GaugeRange(startValue: 41, endValue: 60, color: Colors.orange[400]),
          GaugeRange(startValue: 61, endValue: 80, color: Colors.yellow[400]),
          GaugeRange(startValue: 81, endValue: 100, color: Colors.red[400]),
        ];
}

class NaturalGauge extends StatefulWidget {
  const NaturalGauge({
    super.key,
    required this.title,
    required this.type,
    required this.feedKey,
  });
  final String title;
  final GaugeType type;
  final String feedKey;

  @override
  State<NaturalGauge> createState() => _NaturalGaugeState();
}

class _NaturalGaugeState extends State<NaturalGauge> {
  @override
  Widget build(BuildContext context) {
    final SensorRequester sensorRequester =
        SensorRequester(feedKey: widget.feedKey);
    final Size deviceSize = MediaQuery.of(context).size;
    final double gaugeSize = deviceSize.width * 0.2;

    var currentValue = null;
    var ranges;
    var unit;
    var returnWidget;

    if (widget.type == GaugeType.temperture) {
      ranges = Range.temperture().ranges;
      unit = '\u2103';
    } else if (widget.type == GaugeType.humidity) {
      ranges = Range.humidity().ranges;
      unit = '%';
    } else {
      ranges = Range.light().ranges;
      unit = '';
    }

    return StreamBuilder<Data>(
        stream: sensorRequester.dataFeedStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //! If stream has data, just draw again
            currentValue = snapshot.data!.value;
            returnWidget = Container(
              width: gaugeSize,
              height: gaugeSize,
              child: SfRadialGauge(
                title: GaugeTitle(text: widget.title),
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    interval: 20,
                    ranges: ranges,
                    pointers: <GaugePointer>[
                      NeedlePointer(
                          value: double.parse(currentValue.toStringAsFixed(1)),
                          enableAnimation: true)
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Container(
                          child: Text(
                            currentValue.toStringAsFixed(1) + ' ' + unit,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        angle: 90,
                        positionFactor: 1,
                      )
                    ],
                  ),
                ],
                enableLoadingAnimation: true,
              ),
            );
          } else {
            //! If stream doesn't have data in stream, just print message to indicate waiting
            returnWidget = Container(
              width: gaugeSize,
              height: gaugeSize,
              child: Center(
                child: Text(
                  'Waiting...',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            );
          }
          return returnWidget;
        });
  }
}
