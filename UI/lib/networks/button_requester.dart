import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:smartfarm/models/feed_metadata.dart';
import 'package:smartfarm/models/adafruit_account_info.dart';

class ButtonRequester {
  const ButtonRequester(this.feedKey);

  final String feedKey;
  const ButtonRequester.allFeed() : feedKey = '';

  Future<FeedMetadata> fetchMetadata() async {
    final response = await http.get(
      // TODO: how to avoid not to hardcode IP address
      Uri.http('$HOST:$PORT', 'feeds/$feedKey'),
    );

    if (response.statusCode == 200) {
      final result = FeedMetadata.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
      return result;
    } else {
      throw Exception('Failed to fetch metadata from feed $feedKey');
    }
  }

  Future<List<FeedMetadata>> fetchAllMetadata() async {
    
    try {
      final response = await http.get(Uri.http('$HOST:$PORT', 'feeds/buttons'));
      if (response.statusCode == 200) {
       
        List objectList = json.decode(response.body);
        List<FeedMetadata> result =
            objectList.map((e) => FeedMetadata.fromJson(e)).toList();
        return result;
      } else {
        throw Exception('Failed to fetch all metadata');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> fetchMostRecentDataFromFeed() async {
    try {
      final response = await fetchMetadata();
      return response.status == 1;
    } catch (e) {
      throw Error();
    }
  }

  Future<http.Response> updateButton() {
    return http
        .get(
          // TODO: how to avoid not to hardcode IP address
          Uri.http('$HOST:$PORT', 'feeds/updateStatus/$feedKey'),
        )
        .catchError((e) {});
  }

  Stream<bool> stateStream([int timeRefresh = 500]) async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: timeRefresh));
      yield await fetchMostRecentDataFromFeed();
    }
  }
}
