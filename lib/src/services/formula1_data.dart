import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
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
import '../models/paginated_result.dart';

/// The default User-Agent identifying this package to the jolpica-f1 API,
/// as required by https://github.com/jolpica/jolpica-f1/blob/main/docs/README.md
const String _packageUserAgent =
    'formula1_data-dart/2.0.0 (+https://pub.dev/packages/formula1_data)';

class Formula1Data {
  Dio dio;
  final String _baseUrl = 'https://api.jolpi.ca/ergast/f1';

  /// Creates a new [Formula1Data] client.
  ///
  /// [userAgent] lets a consuming application identify itself to the
  /// jolpica-f1 API, which requires a custom User-Agent on every request.
  /// When provided, it is prefixed to this package's own User-Agent
  /// (e.g. `MyApp/1.0.0 formula1_data-dart/2.0.0`); otherwise only this
  /// package's User-Agent is sent.
  Formula1Data({String? userAgent}) : dio = Dio() {
    dio.options.baseUrl = _baseUrl;
    dio.options.headers['User-Agent'] =
        userAgent != null ? '$userAgent $_packageUserAgent' : _packageUserAgent;
  }

  /// Parses the `total`/`limit`/`offset` pagination fields out of an
  /// `MRData` envelope.
  ({int total, int limit, int offset}) _parsePagination(
    Map<String, dynamic> mrData,
  ) {
    return (
      total: int.parse(mrData['total'] as String),
      limit: int.parse(mrData['limit'] as String),
      offset: int.parse(mrData['offset'] as String),
    );
  }

  Future<PaginatedResult<Season>> getSeasons({
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/seasons',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['SeasonTable']['Seasons'] as List;
        final pagination = _parsePagination(mrData);
        return PaginatedResult<Season>(
          items: data.map((json) => Season.fromJson(json)).toList(),
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<Season>.empty(limit: limit, offset: offset);
    } catch (e) {
      return PaginatedResult<Season>.empty(limit: limit, offset: offset);
    }
  }

  Future<PaginatedResult<Circuit>> getCircuits({
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/circuits',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['CircuitTable']['Circuits'] as List;
        final pagination = _parsePagination(mrData);
        return PaginatedResult<Circuit>(
          items: data.map((json) => Circuit.fromJson(json)).toList(),
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<Circuit>.empty(limit: limit, offset: offset);
    } catch (e) {
      return PaginatedResult<Circuit>.empty(limit: limit, offset: offset);
    }
  }

  Future<PaginatedResult<Race>> getRaces({
    int? season,
    int? round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      String path = '';
      if (season != null) {
        path += '/$season';
        if (round != null) {
          path += '/$round';
        }
      }
      path += '/races';
      final logger = Logger();
      logger.i('Requesting races from path: $path');
      final response = await dio.get(
        path,
        queryParameters: {'offset': offset, 'limit': limit},
      );
      logger.i('Response status code: ${response.statusCode}');
      logger.i('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['RaceTable']['Races'] as List;
        logger.i('Parsed races data: $data');
        final pagination = _parsePagination(mrData);
        return PaginatedResult<Race>(
          items: data.map((json) => Race.fromJson(json)).toList(),
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<Race>.empty(limit: limit, offset: offset);
    } catch (e) {
      final logger = Logger();
      logger.e('Error in getRaces: $e');
      return PaginatedResult<Race>.empty(limit: limit, offset: offset);
    }
  }

  Future<PaginatedResult<Constructor>> getConstructors({
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/constructors',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['ConstructorTable']['Constructors'] as List;
        final pagination = _parsePagination(mrData);
        return PaginatedResult<Constructor>(
          items: data.map((json) => Constructor.fromJson(json)).toList(),
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<Constructor>.empty(limit: limit, offset: offset);
    } catch (e) {
      return PaginatedResult<Constructor>.empty(limit: limit, offset: offset);
    }
  }

  /// Get all drivers or drivers for a specific season
  Future<PaginatedResult<Driver>> getDrivers({
    int? season,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final path = season != null ? '/drivers/$season' : '/drivers';
      final response = await dio.get(
        path,
        queryParameters: {'offset': offset, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['DriverTable']['Drivers'] as List;
        final pagination = _parsePagination(mrData);
        return PaginatedResult<Driver>(
          items: data.map((json) => Driver.fromJson(json)).toList(),
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<Driver>.empty(limit: limit, offset: offset);
    } catch (e) {
      return PaginatedResult<Driver>.empty(limit: limit, offset: offset);
    }
  }

  /// Get race results for a specific race
  Future<PaginatedResult<RaceResult>> getResults({
    required int season,
    required int round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      final response = await dio.get(
        '/$season/$round/results',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final races = mrData['RaceTable']['Races'] as List;
        final pagination = _parsePagination(mrData);
        if (races.isEmpty) {
          return PaginatedResult<RaceResult>(
            items: const [],
            total: pagination.total,
            limit: pagination.limit,
            offset: pagination.offset,
          );
        }
        final results = races.first['Results'] as List;
        return PaginatedResult<RaceResult>(
          items: results.map((json) => RaceResult.fromJson(json)).toList(),
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<RaceResult>.empty(limit: limit, offset: offset);
    } catch (e) {
      final logger = Logger();
      logger.e('Error in getResults: $e');
      return PaginatedResult<RaceResult>.empty(limit: limit, offset: offset);
    }
  }

  Future<PaginatedResult<SprintResult>> getSprint({
    required int year,
    int? round,
    int offset = 0,
    int limit = 30,
  }) async {
    try {
      String path = '/$year';
      if (round != null) {
        path += '/$round';
      }
      path += '/sprint';

      final response = await dio.get(
        path,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['RaceTable']['Races'] as List;
        final pagination = _parsePagination(mrData);
        final results = <SprintResult>[];
        for (final race in data) {
          final sprintResults = race['SprintResults'] as List;
          for (final result in sprintResults) {
            results.add(SprintResult.fromJson(result));
          }
        }
        return PaginatedResult<SprintResult>(
          items: results,
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<SprintResult>.empty(limit: limit, offset: offset);
    } catch (e) {
      final logger = Logger();
      logger.e('Error in getSprint: $e');
      return PaginatedResult<SprintResult>.empty(limit: limit, offset: offset);
    }
  }

  /// Get qualifying results for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a [PaginatedResult] of [QualifyingResult] objects.
  /// Returns an empty result if the API call fails or no results are found.
  Future<PaginatedResult<QualifyingResult>> getQualifying({
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
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['RaceTable']['Races'] as List;
        final pagination = _parsePagination(mrData);
        final results = <QualifyingResult>[];
        for (final race in data) {
          final qualifyingResults = race['QualifyingResults'] as List;
          for (final result in qualifyingResults) {
            results.add(QualifyingResult.fromJson(result));
          }
        }
        return PaginatedResult<QualifyingResult>(
          items: results,
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<QualifyingResult>.empty(
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      return PaginatedResult<QualifyingResult>.empty(
        limit: limit,
        offset: offset,
      );
    }
  }

  /// Get pit stop information for a specific race.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a [PaginatedResult] of [PitStop] objects.
  /// Returns an empty result if the API call fails or no results are found.
  Future<PaginatedResult<PitStop>> getPitStops({
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
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['RaceTable']['Races'] as List;
        final pagination = _parsePagination(mrData);
        final results = <PitStop>[];
        for (final race in data) {
          final pitStops = race['PitStops'] as List;
          for (final stop in pitStops) {
            results.add(PitStop.fromJson(stop));
          }
        }
        return PaginatedResult<PitStop>(
          items: results,
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<PitStop>.empty(limit: limit, offset: offset);
    } catch (e) {
      return PaginatedResult<PitStop>.empty(limit: limit, offset: offset);
    }
  }

  /// Get lap times for a specific race.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a [PaginatedResult] of [LapTime] objects.
  /// Returns an empty result if the API call fails or no results are found.
  Future<PaginatedResult<LapTime>> getLaps({
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
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['RaceTable']['Races'] as List;
        final pagination = _parsePagination(mrData);
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
        return PaginatedResult<LapTime>(
          items: results,
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<LapTime>.empty(limit: limit, offset: offset);
    } catch (e) {
      final logger = Logger();
      logger.e('Error in getLaps: $e');
      return PaginatedResult<LapTime>.empty(limit: limit, offset: offset);
    }
  }

  /// Get driver standings for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a [PaginatedResult] of [DriverStanding] objects.
  /// Returns an empty result if the API call fails or no results are found.
  Future<PaginatedResult<DriverStanding>> getDriverStandings({
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
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['StandingsTable']['StandingsLists'] as List;
        final pagination = _parsePagination(mrData);
        final results = <DriverStanding>[];
        for (final standing in data) {
          final driverStandings = standing['DriverStandings'] as List;
          for (final driverStanding in driverStandings) {
            results.add(DriverStanding.fromJson(driverStanding));
          }
        }
        return PaginatedResult<DriverStanding>(
          items: results,
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<DriverStanding>.empty(
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      return PaginatedResult<DriverStanding>.empty(
        limit: limit,
        offset: offset,
      );
    }
  }

  /// Get constructor standings for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a [PaginatedResult] of [ConstructorStanding] objects.
  /// Returns an empty result if the API call fails or no results are found.
  Future<PaginatedResult<ConstructorStanding>> getConstructorStandings({
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
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['StandingsTable']['StandingsLists'] as List;
        final pagination = _parsePagination(mrData);
        final results = <ConstructorStanding>[];
        for (final standing in data) {
          final constructorStandings = standing['ConstructorStandings'] as List;
          for (final constructorStanding in constructorStandings) {
            results.add(ConstructorStanding.fromJson(constructorStanding));
          }
        }
        return PaginatedResult<ConstructorStanding>(
          items: results,
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<ConstructorStanding>.empty(
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      return PaginatedResult<ConstructorStanding>.empty(
        limit: limit,
        offset: offset,
      );
    }
  }

  /// Get race status information for a specific year and optionally a specific round.
  ///
  /// [year] is the season year (e.g., 2023).
  /// [round] is optional and specifies the race round number.
  /// [offset] is the number of results to skip (default: 0).
  /// [limit] is the maximum number of results to return (default: 30).
  ///
  /// Returns a [PaginatedResult] of [Status] objects.
  /// Returns an empty result if the API call fails or no results are found.
  Future<PaginatedResult<Status>> getStatus({
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
        final mrData = response.data['MRData'] as Map<String, dynamic>;
        final data = mrData['StatusTable']['Status'] as List;
        final pagination = _parsePagination(mrData);
        return PaginatedResult<Status>(
          items: data.map((json) => Status.fromJson(json)).toList(),
          total: pagination.total,
          limit: pagination.limit,
          offset: pagination.offset,
        );
      }
      return PaginatedResult<Status>.empty(limit: limit, offset: offset);
    } catch (e) {
      return PaginatedResult<Status>.empty(limit: limit, offset: offset);
    }
  }
}
