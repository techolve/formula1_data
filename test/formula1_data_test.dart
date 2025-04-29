import 'package:flutter_test/flutter_test.dart';
import 'package:formula1_data/formula1_data.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

@GenerateMocks([Dio])
import 'formula1_data_test.mocks.dart';

void main() {
  final logger = Logger();

  group('Formula1Api - Seasons', () {
    late Formula1Api api;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      api = Formula1Api();
      api.dio = mockDio;
    });

    test('getSeasons returns list of seasons when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'SeasonTable': {
            'Seasons': [
              {'season': '2023', 'url': 'https://example.com/2023'},
              {'season': '2022', 'url': 'https://example.com/2022'},
            ]
          }
        }
      };

      when(mockDio.get('/seasons')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/seasons'),
          ));

      // Act
      final result = await api.getSeasons();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result[0].year, 2023);
      expect(result[0].url, 'https://example.com/2023');
      expect(result[1].year, 2022);
      expect(result[1].url, 'https://example.com/2022');

      // Log results
      logger.i('Seasons: ${result.map((s) => s.toString()).join(', ')}');
    });

    test('getSeasons returns null when API call fails', () async {
      // Arrange
      when(mockDio.get('/seasons')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/seasons'),
      ));

      // Act
      final result = await api.getSeasons();

      // Assert
      expect(result, isNull);
      logger.w('API call failed: No seasons data returned');
    });

    test('getSeasons returns null when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get('/seasons')).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/seasons'),
          ));

      // Act
      final result = await api.getSeasons();

      // Assert
      expect(result, isNull);
      logger.w('API returned status code 404: No seasons data found');
    });
  });

  group('Formula1Api - Circuits', () {
    late Formula1Api api;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      api = Formula1Api();
      api.dio = mockDio;
    });

    test('getCircuits returns list of circuits when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'CircuitTable': {
            'Circuits': [
              {
                'circuitId': 'monaco',
                'url': 'https://example.com/monaco',
                'circuitName': 'Circuit de Monaco',
                'Location': {
                  'lat': '43.7347',
                  'long': '7.42056',
                  'locality': 'Monte-Carlo',
                  'country': 'Monaco'
                }
              },
              {
                'circuitId': 'silverstone',
                'url': 'https://example.com/silverstone',
                'circuitName': 'Silverstone Circuit',
                'Location': {
                  'lat': '52.0786',
                  'long': '-1.01694',
                  'locality': 'Silverstone',
                  'country': 'UK'
                }
              }
            ]
          }
        }
      };

      when(mockDio.get('/circuits')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/circuits'),
          ));

      // Act
      final result = await api.getCircuits();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result[0].circuitId, 'monaco');
      expect(result[0].circuitName, 'Circuit de Monaco');
      expect(result[0].location.latitude, 43.7347);
      expect(result[0].location.country, 'Monaco');
      expect(result[1].circuitId, 'silverstone');
      expect(result[1].circuitName, 'Silverstone Circuit');
      expect(result[1].location.latitude, 52.0786);
      expect(result[1].location.country, 'UK');

      // Log results
      logger.i('Circuits: ${result.map((c) => c.toString()).join(', ')}');
    });

    test('getCircuits returns null when API call fails', () async {
      // Arrange
      when(mockDio.get('/circuits')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/circuits'),
      ));

      // Act
      final result = await api.getCircuits();

      // Assert
      expect(result, isNull);
      logger.w('API call failed: No circuits data returned');
    });

    test('getCircuits returns null when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get('/circuits')).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/circuits'),
          ));

      // Act
      final result = await api.getCircuits();

      // Assert
      expect(result, isNull);
      logger.w('API returned status code 404: No circuits data found');
    });
  });

  group('Formula1Api - Races', () {
    late Formula1Api api;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      api = Formula1Api();
      api.dio = mockDio;
    });

    test('getRaces returns list of races when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'RaceTable': {
            'Races': [
              {
                'season': '2023',
                'round': '1',
                'url': 'https://example.com/2023/1',
                'raceName': 'Bahrain Grand Prix',
                'Circuit': {
                  'circuitId': 'bahrain',
                  'url': 'https://example.com/bahrain',
                  'circuitName': 'Bahrain International Circuit',
                  'Location': {
                    'lat': '26.0325',
                    'long': '50.5106',
                    'locality': 'Sakhir',
                    'country': 'Bahrain'
                  }
                },
                'date': '2023-03-05',
                'time': '15:00:00Z'
              },
              {
                'season': '2023',
                'round': '2',
                'url': 'https://example.com/2023/2',
                'raceName': 'Saudi Arabian Grand Prix',
                'Circuit': {
                  'circuitId': 'jeddah',
                  'url': 'https://example.com/jeddah',
                  'circuitName': 'Jeddah Corniche Circuit',
                  'Location': {
                    'lat': '21.5433',
                    'long': '39.1728',
                    'locality': 'Jeddah',
                    'country': 'Saudi Arabia'
                  }
                },
                'date': '2023-03-19',
                'time': '17:00:00Z'
              }
            ]
          }
        }
      };

      when(mockDio.get('/races')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/races'),
          ));

      // Act
      final result = await api.getRaces();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result[0].season, 2023);
      expect(result[0].round, 1);
      expect(result[0].raceName, 'Bahrain Grand Prix');
      expect(result[0].circuit.circuitId, 'bahrain');
      expect(result[0].date, DateTime.parse('2023-03-05'));
      expect(result[0].time, '15:00:00Z');
      expect(result[1].season, 2023);
      expect(result[1].round, 2);
      expect(result[1].raceName, 'Saudi Arabian Grand Prix');
      expect(result[1].circuit.circuitId, 'jeddah');
      expect(result[1].date, DateTime.parse('2023-03-19'));
      expect(result[1].time, '17:00:00Z');

      // Log results
      logger.i('Races: ${result.map((r) => r.toString()).join(', ')}');
    });

    test('getRaces with season parameter returns filtered races', () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'RaceTable': {
            'Races': [
              {
                'season': '2023',
                'round': '1',
                'url': 'https://example.com/2023/1',
                'raceName': 'Bahrain Grand Prix',
                'Circuit': {
                  'circuitId': 'bahrain',
                  'url': 'https://example.com/bahrain',
                  'circuitName': 'Bahrain International Circuit',
                  'Location': {
                    'lat': '26.0325',
                    'long': '50.5106',
                    'locality': 'Sakhir',
                    'country': 'Bahrain'
                  }
                },
                'date': '2023-03-05',
                'time': '15:00:00Z'
              }
            ]
          }
        }
      };

      when(mockDio.get('/races/2023')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/races/2023'),
          ));

      // Act
      final result = await api.getRaces(season: 2023);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result[0].season, 2023);
      expect(result[0].round, 1);
      expect(result[0].raceName, 'Bahrain Grand Prix');

      // Log results
      logger.i('Races for 2023: ${result.map((r) => r.toString()).join(', ')}');
    });

    test('getRaces returns null when API call fails', () async {
      // Arrange
      when(mockDio.get('/races')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/races'),
      ));

      // Act
      final result = await api.getRaces();

      // Assert
      expect(result, isNull);
      logger.w('API call failed: No races data returned');
    });

    test('getRaces returns null when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get('/races')).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/races'),
          ));

      // Act
      final result = await api.getRaces();

      // Assert
      expect(result, isNull);
      logger.w('API returned status code 404: No races data found');
    });
  });
}
