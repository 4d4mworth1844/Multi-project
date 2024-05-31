import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartfarm/models/adafruit_account_info.dart';

import 'package:smartfarm/models/result_after_modified.dart';
import 'package:smartfarm/models/schedule_metadata.dart';

class SchedulerRequester {
  const SchedulerRequester(this.feedKey);
  final String feedKey;
  static const url = '$HOST:$PORT';
  const SchedulerRequester.allFeed() : feedKey = '';

  Future<List<ScheduleMetadata>> fetchAllScheduleInfo() async {
    try {
      const path = 'schedule';
      final response = await http.get(Uri.http(url, path));

      if (response.statusCode == 200) {
        final schedules = json.decode(response.body) as List;

        final result = schedules
            .map((schedule) => ScheduleMetadata.fromJson(schedule))
            .toList();
        return result;
      } else {
        throw Exception('Failed to fetch all metadata for scheduler');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ScheduleMetadata> getScheduleOf(int id) async {
    try {
      final path = 'schedule/$feedKey/$id';
      final response = await http.get(Uri.http(url, path));

      if (response.statusCode == 200) {
        return ScheduleMetadata.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Can not get schedule of feed $feedKey and $id');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> updateSchedule(int id, String timeOn, String timeOff) async {
    try {
      final path = 'schedule/$feedKey/$id';

      final response = await http.put(
        Uri.http(url, path),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "time_on": timeOn,
          "time_off": timeOff,
        }),
      );

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 200) {
        final result = ResultAfterModified.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return result.message;
      } else {
        throw Exception('Can not update');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> createSchedule(String time_on, String time_off) async {
    try {
      final path = 'schedule/$feedKey/createSchedule';
      final response = await http.post(
        Uri.http(url, path),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "time_on": time_on,
          "time_off": time_off,
        }),
      );

      print(response.statusCode);

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        final result = ResultAfterModified.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return result.message;
      } else {
        throw Exception('Can not create schedule of feed $feedKey');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> deleteSchedule(int scheduleId) async {
    try {
      print(scheduleId);
      final path = 'schedule/deleteSchedule/$scheduleId';
      final response = await http.delete(Uri.http(url, path));
      print(response.statusCode);

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 200) {
        final result = ResultAfterModified.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return result.message;
      } else {
        throw Exception('Can not delete schedule of feed $feedKey');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
