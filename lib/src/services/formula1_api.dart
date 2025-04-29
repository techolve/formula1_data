import 'package:dio/dio.dart';
import '../models/season.dart';
import '../models/circuit.dart';
import '../models/race.dart';
import '../models/constructor.dart';
import '../models/driver.dart';
import '../models/result.dart';
import '../models/sprint.dart';
import '../models/qualifying.dart';
import '../models/pitstop.dart';
import '../models/lap.dart';
import '../models/standing.dart';
import '../models/status.dart';

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

  Future<List<Constructor>?> getConstructors() async {
    try {
      final response = await dio.get('/constructors');
      if (response.statusCode == 200) {
        final data =
            response.data['MRData']['ConstructorTable']['Constructors'] as List;
        return data.map((json) => Constructor.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      dio.close();
    }
  }

  /// Get all drivers or drivers for a specific season
  Future<List<Driver>?> getDrivers({int? season}) async {
    try {
      final path = season != null ? '/drivers/$season' : '/drivers';
      final response = await dio.get(path);

      if (response.statusCode == 200) {
        final data = response.data['MRData']['DriverTable']['Drivers'] as List;
        return data.map((json) => Driver.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get race results for a specific race
  Future<List<RaceResult>?> getResults(
      {required int season, required int round}) async {
    try {
      final response = await dio.get('/$season/results/$round');
      if (response.statusCode == 200) {
        final races = response.data['MRData']['RaceTable']['Races'] as List;
        if (races.isEmpty) {
          return [];
        }
        final results = races.first['Results'] as List;
        return results.map((json) => RaceResult.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<SprintResult>> getSprint({
    required int year,
    int? round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      String path = '/$year/sprint';
      if (round != null) {
        path += '/$round';
      }
      final response = await dio.get(
        path,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        final results = <SprintResult>[];
        for (final race in data) {
          final sprintResults = race['SprintResults'] as List;
          for (final result in sprintResults) {
            results.add(SprintResult.fromJson(result));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<SprintResult>> getDriverSprint({
    required String driverId,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/drivers/$driverId/sprint',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        final results = <SprintResult>[];
        for (final race in data) {
          final sprintResults = race['SprintResults'] as List;
          for (final result in sprintResults) {
            results.add(SprintResult.fromJson(result));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<SprintResult>> getConstructorSprint({
    required String constructorId,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/constructors/$constructorId/sprint',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        final results = <SprintResult>[];
        for (final race in data) {
          final sprintResults = race['SprintResults'] as List;
          for (final result in sprintResults) {
            results.add(SprintResult.fromJson(result));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<SprintResult>> getSprintByRound({
    required int year,
    required int round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/$year/sprint/$round',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        final results = <SprintResult>[];
        for (final race in data) {
          final sprintResults = race['SprintResults'] as List;
          for (final result in sprintResults) {
            results.add(SprintResult.fromJson(result));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get qualifying results for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a list of [QualifyingResult] objects.
  /// Returns an empty list if the API call fails or no results are found.
  Future<List<QualifyingResult>> getQualifying({
    required int year,
    int? round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      String path = '/$year/qualifying';
      if (round != null) {
        path += '/$round';
      }
      final response = await dio.get(
        path,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        final results = <QualifyingResult>[];
        for (final race in data) {
          final qualifyingResults = race['QualifyingResults'] as List;
          for (final result in qualifyingResults) {
            results.add(QualifyingResult.fromJson(result));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get pit stop information for a specific race.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a list of [PitStop] objects.
  /// Returns an empty list if the API call fails or no results are found.
  Future<List<PitStop>> getPitStops({
    required int year,
    required int round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/$year/$round/pitstops',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        final results = <PitStop>[];
        for (final race in data) {
          final pitStops = race['PitStops'] as List;
          for (final stop in pitStops) {
            results.add(PitStop.fromJson(stop));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get lap times for a specific race.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a list of [LapTime] objects.
  /// Returns an empty list if the API call fails or no results are found.
  Future<List<LapTime>> getLapTimes({
    required int year,
    required int round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/$year/$round/laps',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['RaceTable']['Races'] as List;
        final results = <LapTime>[];
        for (final race in data) {
          final laps = race['Laps'] as List;
          for (final lap in laps) {
            final times = lap['Timings'] as List;
            for (final time in times) {
              results.add(LapTime.fromJson(time));
            }
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get driver standings for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a list of [DriverStanding] objects.
  /// Returns an empty list if the API call fails or no results are found.
  Future<List<DriverStanding>> getDriverStandings({
    required int year,
    int? round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      String path = '/$year/driverStandings';
      if (round != null) {
        path += '/$round';
      }
      final response = await dio.get(
        path,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data =
            response.data['MRData']['StandingsTable']['StandingsLists'] as List;
        final results = <DriverStanding>[];
        for (final standing in data) {
          final driverStandings = standing['DriverStandings'] as List;
          for (final driverStanding in driverStandings) {
            results.add(DriverStanding.fromJson(driverStanding));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get constructor standings for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a list of [ConstructorStanding] objects.
  /// Returns an empty list if the API call fails or no results are found.
  Future<List<ConstructorStanding>> getConstructorStandings({
    required int year,
    int? round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      String path = '/$year/constructorStandings';
      if (round != null) {
        path += '/$round';
      }
      final response = await dio.get(
        path,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data =
            response.data['MRData']['StandingsTable']['StandingsLists'] as List;
        final results = <ConstructorStanding>[];
        for (final standing in data) {
          final constructorStandings = standing['ConstructorStandings'] as List;
          for (final constructorStanding in constructorStandings) {
            results.add(ConstructorStanding.fromJson(constructorStanding));
          }
        }
        return results;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get race status information for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a list of [Status] objects.
  /// Returns an empty list if the API call fails or no results are found.
  Future<List<Status>> getStatus({
    required int year,
    int? round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      String path = '/$year/status';
      if (round != null) {
        path += '/$round';
      }
      final response = await dio.get(
        path,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['MRData']['StatusTable']['Status'] as List;
        return data.map((json) => Status.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
