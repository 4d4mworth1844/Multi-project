import 'package:flutter/material.dart';
import 'package:smartfarm/widgets/custom_buttons.dart';
import 'package:smartfarm/widgets/radial_gauge.dart';

import 'package:smartfarm/models/feed_metadata.dart';
import 'package:smartfarm/networks/button_requester.dart';

class SystemInfoScreen extends StatefulWidget {
  const SystemInfoScreen({super.key});

  @override
  State<SystemInfoScreen> createState() => _SystemInfoScreenState();
}

class _SystemInfoScreenState extends State<SystemInfoScreen> {
  final ButtonRequester requester = const ButtonRequester.allFeed();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông số hệ thống',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          //! Các thang độ cảm biến
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(10.0),
              crossAxisCount: 2,
              children: const <NaturalGauge>[
                //! Thang đo nhiệt độ
                NaturalGauge(
                  title: 'Nhiệt độ',
                  type: GaugeType.temperture,
                  feedKey: 'sensor001',
                ),
                //! Thang đo độ ẩm
                NaturalGauge(
                  title: 'Độ ẩm',
                  type: GaugeType.humidity,
                  feedKey: 'sensor002',
                ),
                //! Thang đo cường độ sáng
                NaturalGauge(
                  title: 'Ánh sáng',
                  type: GaugeType.light,
                  feedKey: 'sensor003',
                ),
              ],
            ),
          ),

          //! Các thao tác với nút
          Container(
            child: Center(
              child: SizedBox(
                height: deviceSize.height * 0.4,
                width: deviceSize.width,
                child: FutureBuilder(
                  future: requester.fetchAllMetadata(),
                  builder: (context, snapshotAllMetadata) {
                    if (snapshotAllMetadata.hasData) {
                      var buttonsMetadata = snapshotAllMetadata.data!;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 2 / 1,
                          crossAxisCount: 2,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        itemCount: buttonsMetadata.length,
                        itemBuilder: (context, index) {

                          return CustomSwitchButton(
                            deviceName: buttonsMetadata[index]!.feedName!,
                            feedKey: buttonsMetadata[index]!.feedKey!,
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('Fetching devices...'));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
