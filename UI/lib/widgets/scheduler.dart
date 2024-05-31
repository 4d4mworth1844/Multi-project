import 'package:flutter/material.dart';
import 'package:smartfarm/networks/scheduler_requester.dart';
import 'package:smartfarm/widgets/result_scheduler.dart';
import 'package:intl/intl.dart';

class Scheduler extends StatefulWidget {
  const Scheduler({
    super.key,
    required this.feedKey,
    required this.feedName,
    required this.scheduleId,
  });

  final String feedKey;
  final String feedName;
  final int scheduleId;

  @override
  State<StatefulWidget> createState() {
    return _SchedulerState();
  }
}

class _SchedulerState extends State<Scheduler> {
  TimeOfDay turnOnTime = TimeOfDay.now();
  TimeOfDay turnOffTime = TimeOfDay.now();
  late SchedulerRequester schedulerRequester;

  @override
  void initState() {
    schedulerRequester = SchedulerRequester(widget.feedKey);
    super.initState();
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.Hms(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  void onDeleteSchedule() {
    schedulerRequester
        .deleteSchedule(widget.scheduleId)
        .then((value) => setState(() {
          print('reset state');
        }));
  }

  void onSubmitSchedule() {
    schedulerRequester
        .updateSchedule(
          widget.scheduleId,
          '${turnOnTime.format(context).toString()}:00',
          '${turnOffTime.format(context).toString()}:00',
        )
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final labelSize = deviceSize.width * 0.2;

    return FutureBuilder(
      future: schedulerRequester.getScheduleOf(widget.scheduleId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isOn = snapshot.data!.status == 1;
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: labelSize,
                        width: labelSize,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: isOn
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.error),
                        alignment: Alignment.center,
                        child: Text(widget.feedName,
                            style: TextStyle(
                                color: isOn
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                    : Theme.of(context).colorScheme.onError)),
                      ),
                      const SizedBox(width: 15),
                      //! set-up buttons
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! turn-on time setting
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                elevation: 4,
                              ),
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    // To make time picker allow user to select time as AM/PM style, not 24hour time
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                ).then((time) {
                                  turnOnTime = time!;
                                });
                              },
                              child: const Text('Thời điểm bật')),
                          //! turn-off time setting
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                elevation: 4,
                              ),
                              onPressed: () async {
                                return showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                ).then((time) {
                                  turnOffTime = time!;
                                });
                              },
                              child: const Text('Thời điểm tắt')),
                          //! submit time settings
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              elevation: 4,
                            ),
                            onPressed: onSubmitSchedule,
                            child: const Text('Lưu lịch'),
                          ),
                        ],
                      ),
                      // ! Remove schedule by id
                      IconButton.outlined(
                        onPressed: onDeleteSchedule,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  //! result after picking up time settings
                  const SizedBox(height: 10),
                  ResultScheduler(
                    firstTitle: 'Thời điểm bật',
                    firstResult: stringToTimeOfDay(snapshot.data!.timeOn!),
                    secondTitle: 'Thời điểm tắt',
                    secondResult: stringToTimeOfDay(snapshot.data!.timeOff!),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('Waiting'));
        }
      },
    );
  }
}
