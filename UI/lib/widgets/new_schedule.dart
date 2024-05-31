import 'package:flutter/material.dart';
import 'package:smartfarm/models/feed_metadata.dart';
import 'package:smartfarm/networks/button_requester.dart';
import 'package:smartfarm/networks/scheduler_requester.dart';
import 'package:smartfarm/widgets/result_scheduler.dart';
import 'package:intl/intl.dart';

var feedKey = '';

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.Hms(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}

class NewSchedule extends StatelessWidget {
  const NewSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          // ! Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DropdownFeeds(),
              SetupButtons(),
            ],
          ),
        ],
      ),
    );
  }
}

class SetupButtons extends StatefulWidget {
  const SetupButtons({
    super.key,
  });

  @override
  State<SetupButtons> createState() => _SetupButtonsState();
}

class _SetupButtonsState extends State<SetupButtons> {
  late SchedulerRequester scheduler;
  var turnOnTime = TimeOfDay.now();
  var turnOffTime = TimeOfDay.now();

  @override
  void initState() {
    scheduler = SchedulerRequester(feedKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
            elevation: 4,
          ),
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            ).then((time) {
              // After time is picked, return that time to turnOnTime
              setState(() {
                turnOnTime = time!;
              });
            });
          },
          child: const Text('Thời điểm bật'),
        ),
        //! turn-off time setting
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
            elevation: 4,
          ),
          onPressed: () async {
            return showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            ).then((time) {
              // After time is picked, return that time to turnOffTime
              setState(() {
                turnOffTime = time!;
              });
            });
          },
          child: const Text('Thời điểm tắt'),
        ),
        const SizedBox(height: 10),
        ResultScheduler(
          firstTitle: 'Thời điểm bật',
          firstResult: turnOnTime,
          secondTitle: 'Thời điểm tắt',
          secondResult: turnOffTime,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red)),
              child: const Text('Huỷ'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                scheduler.createSchedule(
                  '${turnOnTime.format(context).toString()}:00',
                  '${turnOffTime.format(context).toString()}:00',
                );

                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.primaryContainer)),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DropdownFeeds extends StatelessWidget {
  const _DropdownFeeds({super.key});

  final ButtonRequester requester = const ButtonRequester.allFeed();

  @override
  Widget build(BuildContext context) {
    FeedMetadata dropDownValue;

    return FutureBuilder(
      future: requester.fetchAllMetadata(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final feeds = snapshot.data!;
          dropDownValue = feeds.first;
          feedKey = dropDownValue.feedKey!;

          return DropdownMenu<FeedMetadata>(
            initialSelection: dropDownValue,
            onSelected: (FeedMetadata? value) {
              dropDownValue = value!;
              feedKey = dropDownValue.feedKey!;
            },
            dropdownMenuEntries: feeds
                .map<DropdownMenuEntry<FeedMetadata>>((feed) =>
                    DropdownMenuEntry(value: feed!, label: feed.feedName!))
                .toList(),
          );
        } else {
          return const Text('Waiting');
        }
      },
    );
  }
}
