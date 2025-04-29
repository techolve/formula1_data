import 'package:dio/dio.dart';
import '../models/season.dart';

class Formula1Api {
  Dio dio;
  final String _baseUrl = 'https://api.jolpi.ca/ergast/f1';

  Formula1Api() : dio = Dio() {
    dio.options.baseUrl = _baseUrl;
  }

  Future<List<Season>?> getSeasons() async {
    try {
      final response = await dio.get('/seasons');
      if (response.statusCode == 200) {
        final data = response.data['MRData']['SeasonTable']['Seasons'] as List;
        return data.map((json) => Season.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      dio.close();
    }
  }
}
