import 'package:flutter/material.dart';
import 'package:smartfarm/models/schedule_metadata.dart';
import 'package:smartfarm/networks/scheduler_requester.dart';
import 'package:smartfarm/widgets/new_schedule.dart';

import '../widgets/scheduler.dart';

class AutomaticSettings extends StatefulWidget {
  const AutomaticSettings({super.key});

  @override
  State<AutomaticSettings> createState() => _AutomaticSettingsState();
}

class _AutomaticSettingsState extends State<AutomaticSettings> {
  @override
  Widget build(BuildContext context) {
    const scheduler = SchedulerRequester.allFeed();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thiết lập lịch vận hành',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: <Widget>[
          IconButton(
            icon:
                Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
            tooltip: 'Add a new schele',
            focusColor: Theme.of(context).colorScheme.onPrimaryContainer,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const NewSchedule(),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<ScheduleMetadata>>(
        future: scheduler.fetchAllScheduleInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!
                    .map((feed) => Scheduler(
                          feedKey: feed.feedKey!,
                          feedName: feed.feedName!,
                          scheduleId: feed.id!,
                        ))
                    .toList(),
              ),
            );
          } else {
            return const Center(
              child: Text('waiting'),
            );
          }
        },
      ),
    );
  }
}
