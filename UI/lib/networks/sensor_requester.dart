import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:smartfarm/models/data.dart';
import 'package:smartfarm/models/adafruit_account_info.dart';

class SensorRequester {
  SensorRequester({required this.feedKey});
  final String feedKey;

  Future<Data> _fetchRecentDataFromFeed() async {

    final response = await http.get(
      Uri.http('$HOST:$PORT',
          'data/$feedKey'), // TODO: how to avoid not to hardcode IP address
    );

    if (response.statusCode == 200) {
      var result =
          Data.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      return result;
    } else {
      throw Exception('Failed to load data from feed $feedKey');
    }
  }

  Stream<Data> dataFeedStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      Data data = await _fetchRecentDataFromFeed();
      yield data;
    }
  }
}
