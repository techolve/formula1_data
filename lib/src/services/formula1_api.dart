import 'package:dio/dio.dart';
import '../models/season.dart';
import '../models/circuit.dart';
import '../models/race.dart';

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

  Future<List<Circuit>?> getCircuits() async {
    try {
      final response = await dio.get('/circuits');
      if (response.statusCode == 200) {
        final data =
            response.data['MRData']['CircuitTable']['Circuits'] as List;
        return data.map((json) => Circuit.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      dio.close();
    }
  }

  Future<List<Race>?> getRaces({int? season, int? round}) async {
    try {
      String path = '/races';
      if (season != null) {
        path += '/$season';
        if (round != null) {
          path += '/$round';
        }
      }
      final response = await dio.get(path);
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        return data.map((json) => Race.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      dio.close();
    }
  }
}
