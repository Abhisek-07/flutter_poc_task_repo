import 'dart:convert';

import 'package:music_app/models/music_data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<MusicData>> getAllMusicData() async {
    const url = 'https://storage.googleapis.com/uamp/catalog.json';
    Uri uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      // if (response.statusCode == 200) {
      final data = response.body;
      final json = jsonDecode(data);
      final result = json["music"] as List<dynamic>;
      final musicList = result.map((e) => MusicData.fromJson(e)).toList();

      return musicList;
      // } else {
      //   return throw ("Data fetch failed");
      // }
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }
}
