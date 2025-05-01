import 'package:flutter_test/flutter_test.dart';
import 'package:formula1_data/formula1_data.dart';
import 'package:formula1_data/src/services/formula1_data.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

@GenerateMocks([Dio])
import 'formula1_data_test.mocks.dart';

void main() {
  final logger = Logger();
  late Formula1Data formula1;

  setUp(() {
    formula1 = Formula1Data();
  });

  group('Formula1Data - Seasons', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
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
      final result = await formula1.getSeasons();

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
      final result = await formula1.getSeasons();

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
      final result = await formula1.getSeasons();

      // Assert
      expect(result, isNull);
      logger.w('API returned status code 404: No seasons data found');
    });
  });

  group('Formula1Data - Circuits', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
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
      final result = await formula1.getCircuits();

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
      final result = await formula1.getCircuits();

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
      final result = await formula1.getCircuits();

      // Assert
      expect(result, isNull);
      logger.w('API returned status code 404: No circuits data found');
    });
  });

  group('Formula1Data - Races', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
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
      final result = await formula1.getRaces();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result[0].season, 2023);
      expect(result[0].round, 1);
      expect(result[0].raceName, 'Bahrain Grand Prix');
      expect(result[0].circuit.circuitId, 'bahrain');
      expect(result[0].dateTime, DateTime.parse('2023-03-05 15:00:00Z'));
      expect(result[1].season, 2023);
      expect(result[1].round, 2);
      expect(result[1].raceName, 'Saudi Arabian Grand Prix');
      expect(result[1].circuit.circuitId, 'jeddah');
      expect(result[1].dateTime, DateTime.parse('2023-03-19 17:00:00Z'));

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
      final result = await formula1.getRaces(season: 2023);

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
      final result = await formula1.getRaces();

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
      final result = await formula1.getRaces();

      // Assert
      expect(result, isNull);
      logger.w('API returned status code 404: No races data found');
    });
  });

  group('Formula1Data - Constructors', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test(
        'getConstructors returns list of constructors when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'ConstructorTable': {
            'Constructors': [
              {
                'constructorId': 'mercedes',
                'url': 'https://example.com/mercedes',
                'name': 'Mercedes',
                'nationality': 'German'
              },
              {
                'constructorId': 'ferrari',
                'url': 'https://example.com/ferrari',
                'name': 'Ferrari',
                'nationality': 'Italian'
              },
              {
                'constructorId': 'red_bull',
                'url': 'https://example.com/red_bull',
                'name': 'Red Bull',
                'nationality': 'Austrian'
              }
            ]
          }
        }
      };

      when(mockDio.get('/constructors')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/constructors'),
          ));

      // Act
      final result = await formula1.getConstructors();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 3);
      expect(result[0].constructorId, 'mercedes');
      expect(result[0].name, 'Mercedes');
      expect(result[0].nationality, 'German');
      expect(result[1].constructorId, 'ferrari');
      expect(result[1].name, 'Ferrari');
      expect(result[1].nationality, 'Italian');
      expect(result[2].constructorId, 'red_bull');
      expect(result[2].name, 'Red Bull');
      expect(result[2].nationality, 'Austrian');

      // Log results
      logger.i('Constructors: ${result.map((c) => c.toString()).join(', ')}');
    });

    test('getConstructors returns null when API call fails', () async {
      // Arrange
      when(mockDio.get('/constructors')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/constructors'),
      ));

      // Act
      final result = await formula1.getConstructors();

      // Assert
      expect(result, isNull);
      logger.w('API call failed: No constructors data returned');
    });

    test('getConstructors returns null when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get('/constructors')).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/constructors'),
          ));

      // Act
      final result = await formula1.getConstructors();

      // Assert
      expect(result, isNull);
      logger.w('API returned status code 404: No constructors data found');
    });
  });

  group('Driver Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get all drivers', () async {
      final mockResponse = {
        'MRData': {
          'DriverTable': {
            'Drivers': [
              {
                'driverId': 'max_verstappen',
                'url': 'https://example.com/max_verstappen',
                'givenName': 'Max',
                'familyName': 'Verstappen',
                'dateOfBirth': '1997-09-30',
                'nationality': 'Dutch'
              }
            ]
          }
        }
      };

      when(mockDio.get('/drivers')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/drivers'),
          ));

      final drivers = await formula1.getDrivers();
      expect(drivers, isNotNull);
      expect(drivers, isNotEmpty);
      expect(drivers!.first, isA<Driver>());
      logger.i('Drivers: ${drivers.map((d) => d.toString()).join(', ')}');
    });

    test('Get drivers for specific season', () async {
      final mockResponse = {
        'MRData': {
          'DriverTable': {
            'Drivers': [
              {
                'driverId': 'max_verstappen',
                'url': 'https://example.com/max_verstappen',
                'givenName': 'Max',
                'familyName': 'Verstappen',
                'dateOfBirth': '1997-09-30',
                'nationality': 'Dutch'
              }
            ]
          }
        }
      };

      when(mockDio.get('/drivers/2023')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/drivers/2023'),
          ));

      final drivers = await formula1.getDrivers(season: 2023);
      expect(drivers, isNotNull);
      expect(drivers, isNotEmpty);
      expect(drivers!.first, isA<Driver>());
      logger.i(
          'Drivers for 2023: ${drivers.map((d) => d.toString()).join(', ')}');
    });
  });

  group('Result Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get race results', () async {
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
                'time': '15:00:00Z',
                'Results': [
                  {
                    'number': '1',
                    'position': '1',
                    'positionText': '1',
                    'points': '25',
                    'Driver': {
                      'driverId': 'max_verstappen',
                      'url': 'https://example.com/max_verstappen',
                      'givenName': 'Max',
                      'familyName': 'Verstappen',
                      'dateOfBirth': '1997-09-30',
                      'nationality': 'Dutch'
                    },
                    'Constructor': {
                      'constructorId': 'red_bull',
                      'url': 'https://example.com/red_bull',
                      'name': 'Red Bull',
                      'nationality': 'Austrian'
                    },
                    'grid': '1',
                    'laps': '57',
                    'status': 'Finished',
                    'Time': {'millis': '5523897', 'time': '1:33:56.736'},
                    'FastestLap': {
                      'rank': '1',
                      'lap': '44',
                      'Time': {'time': '1:33.996'},
                      'AverageSpeed': {'units': 'kph', 'speed': '207.235'}
                    }
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get('/2023/1/results')).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/results/2023/1'),
          ));

      final results = await formula1.getResults(season: 2023, round: 1);
      expect(results, isNotNull);
      expect(results!.length, 1);

      final result = results.first;
      expect(result.position, 1);
      expect(result.points, 25);
      expect(result.driver.driverId, 'max_verstappen');
      expect(result.constructor.constructorId, 'red_bull');
      expect(result.grid, 1);
      expect(result.laps, 57);
      expect(result.status, 'Finished');
      expect(result.time?.time, '1:33:56.736');
      expect(result.fastestLap?.rank, 1);
      expect(result.fastestLap?.lap, 44);
      expect(result.fastestLap?.time.time, '1:33.996');
      expect(result.fastestLap?.averageSpeed.units, 'kph');
      expect(result.fastestLap?.averageSpeed.speed, 207.235);

      logger.i('Race Results: ${results.map((r) => r.toString()).join(', ')}');
    });

    test('Get race results returns null when API call fails', () async {
      when(mockDio.get('/results/2023/1')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/results/2023/1'),
      ));

      final results = await formula1.getResults(season: 2023, round: 1);
      expect(results, isNull);
      logger.w('API call failed: No results data returned');
    });

    test('Get race results returns null when response status code is not 200',
        () async {
      when(mockDio.get('/results/2023/1')).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/results/2023/1'),
          ));

      final results = await formula1.getResults(season: 2023, round: 1);
      expect(results, isNull);
      logger.w('API returned status code 404: No results data found');
    });
  });

  group('Sprint Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get sprint results for specific year', () async {
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
                'time': '15:00:00Z',
                'SprintResults': [
                  {
                    'number': '1',
                    'position': '1',
                    'positionText': '1',
                    'points': '8',
                    'Driver': {
                      'driverId': 'max_verstappen',
                      'url': 'https://example.com/max_verstappen',
                      'givenName': 'Max',
                      'familyName': 'Verstappen',
                      'dateOfBirth': '1997-09-30',
                      'nationality': 'Dutch'
                    },
                    'Constructor': {
                      'constructorId': 'red_bull',
                      'url': 'https://example.com/red_bull',
                      'name': 'Red Bull',
                      'nationality': 'Austrian'
                    },
                    'grid': '1',
                    'laps': '24',
                    'status': 'Finished',
                    'Time': {'millis': '1234567', 'time': '0:20:34.567'},
                    'FastestLap': {
                      'rank': '1',
                      'lap': '12',
                      'Time': {'time': '1:33.996'},
                      'AverageSpeed': {'units': 'kph', 'speed': '207.235'}
                    }
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/sprint',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/sprint'),
          ));

      final results = await formula1.getSprint(year: 2023);
      expect(results, isNotEmpty);
      expect(results.length, 1);

      final result = results.first;
      expect(result.position, 1);
      expect(result.points, 8);
      expect(result.driver.driverId, 'max_verstappen');
      expect(result.constructor.constructorId, 'red_bull');
      expect(result.grid, 1);
      expect(result.laps, 24);
      expect(result.status, 'Finished');
      expect(result.time?.time, '0:20:34.567');
      expect(result.fastestLap?.rank, 1);
      expect(result.fastestLap?.lap, 12);
      expect(result.fastestLap?.time.time, '1:33.996');

      logger
          .i('Sprint Results: ${results.map((r) => r.toString()).join(', ')}');
    });

    test('Get sprint results returns empty list when API call fails', () async {
      when(mockDio.get(
        '/sprint/2023',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/sprint/2023'),
      ));

      final results = await formula1.getSprint(year: 2023);
      expect(results, isEmpty);
      logger.w('API call failed: No sprint results returned');
    });

    test(
        'Get sprint results returns empty list when response status code is not 200',
        () async {
      when(mockDio.get(
        '/sprint/2023',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/sprint/2023'),
          ));

      final results = await formula1.getSprint(year: 2023);
      expect(results, isEmpty);
      logger.w('API returned status code 404: No sprint results found');
    });

    test('Get sprint results with pagination', () async {
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
                'time': '15:00:00Z',
                'SprintResults': [
                  {
                    'number': '1',
                    'position': '1',
                    'positionText': '1',
                    'points': '8',
                    'Driver': {
                      'driverId': 'max_verstappen',
                      'url': 'https://example.com/max_verstappen',
                      'givenName': 'Max',
                      'familyName': 'Verstappen',
                      'dateOfBirth': '1997-09-30',
                      'nationality': 'Dutch'
                    },
                    'Constructor': {
                      'constructorId': 'red_bull',
                      'url': 'https://example.com/red_bull',
                      'name': 'Red Bull',
                      'nationality': 'Austrian'
                    },
                    'grid': '1',
                    'laps': '24',
                    'status': 'Finished',
                    'Time': {'millis': '1234567', 'time': '0:20:34.567'},
                    'FastestLap': {
                      'rank': '1',
                      'lap': '12',
                      'Time': {'time': '1:33.996'},
                      'AverageSpeed': {'units': 'kph', 'speed': '207.235'}
                    }
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/sprint',
        queryParameters: {
          'offset': 10,
          'limit': 5,
        },
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/sprint'),
          ));

      final results = await formula1.getSprint(
        year: 2023,
        offset: 10,
        limit: 5,
      );
      expect(results, isNotEmpty);
      expect(results.length, 1);

      verify(mockDio.get(
        '/2023/sprint',
        queryParameters: {
          'offset': 10,
          'limit': 5,
        },
      )).called(1);

      logger.i(
          'Sprint Results with Pagination: ${results.map((r) => r.toString()).join(', ')}');
    });
  });

  group('Qualifying Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get qualifying results for specific year', () async {
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
                'time': '15:00:00Z',
                'QualifyingResults': [
                  {
                    'number': '1',
                    'position': '1',
                    'positionText': '1',
                    'Driver': {
                      'driverId': 'max_verstappen',
                      'url': 'https://example.com/max_verstappen',
                      'givenName': 'Max',
                      'familyName': 'Verstappen',
                      'dateOfBirth': '1997-09-30',
                      'nationality': 'Dutch'
                    },
                    'Constructor': {
                      'constructorId': 'red_bull',
                      'url': 'https://example.com/red_bull',
                      'name': 'Red Bull',
                      'nationality': 'Austrian'
                    },
                    'Q1': '1:30.000',
                    'Q2': '1:29.500',
                    'Q3': '1:29.000'
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/qualifying',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/qualifying'),
          ));

      final results = await formula1.getQualifying(year: 2023);
      expect(results, isNotEmpty);
      expect(results.length, 1);

      final result = results.first;
      expect(result.position, 1);
      expect(result.driver.driverId, 'max_verstappen');
      expect(result.constructor.constructorId, 'red_bull');
      expect(result.q1, '1:30.000');
      expect(result.q2, '1:29.500');
      expect(result.q3, '1:29.000');

      logger.i(
          'Qualifying Results: ${results.map((r) => r.toString()).join(', ')}');
    });
  });

  group('Pit Stop Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get pit stops for specific race', () async {
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
                'time': '15:00:00Z',
                'PitStops': [
                  {
                    'stop': '1',
                    'lap': '10',
                    'time': '15:20:00',
                    'duration': '2.5',
                    'Driver': {
                      'driverId': 'max_verstappen',
                      'url': 'https://example.com/max_verstappen',
                      'givenName': 'Max',
                      'familyName': 'Verstappen',
                      'dateOfBirth': '1997-09-30',
                      'nationality': 'Dutch'
                    },
                    'Constructor': {
                      'constructorId': 'red_bull',
                      'url': 'https://example.com/red_bull',
                      'name': 'Red Bull',
                      'nationality': 'Austrian'
                    }
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/1/pitstops',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/1/pitstops'),
          ));

      final results = await formula1.getPitStops(year: 2023, round: 1);
      expect(results, isNotEmpty);
      expect(results.length, 1);

      final result = results.first;
      expect(result.stop, 1);
      expect(result.lap, 10);
      expect(result.time, '15:20:00');
      expect(result.duration, '2.5');
      expect(result.driver.driverId, 'max_verstappen');
      expect(result.constructor.constructorId, 'red_bull');

      logger.i('Pit Stops: ${results.map((r) => r.toString()).join(', ')}');
    });
  });

  group('Lap Time Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get lap times for specific race', () async {
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
                'time': '15:00:00Z',
                'Laps': [
                  {
                    'number': '1',
                    'Timings': [
                      {
                        "driverId": "norris",
                        "position": "1",
                        "time": "1:57.099"
                      },
                    ]
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/1/laps',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/1/laps'),
          ));

      final results = await formula1.getLaps(year: 2023, round: 1);
      expect(results, isNotEmpty);
      expect(results.length, 1);

      final result = results.first;
      expect(result.driverId, 'norris');
      expect(result.position, 1);
      expect(result.time, '1:57.099');

      logger.i('Lap Times: ${results.map((r) => r.toString()).join(', ')}');
    });
  });

  group('Standings Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get driver standings', () async {
      final mockResponse = {
        'MRData': {
          'StandingsTable': {
            'StandingsLists': [
              {
                'season': '2023',
                'round': '1',
                'DriverStandings': [
                  {
                    'position': '1',
                    'positionText': '1',
                    'points': '25',
                    'wins': '1',
                    'Driver': {
                      'driverId': 'max_verstappen',
                      'url': 'https://example.com/max_verstappen',
                      'givenName': 'Max',
                      'familyName': 'Verstappen',
                      'dateOfBirth': '1997-09-30',
                      'nationality': 'Dutch'
                    },
                    'Constructors': [
                      {
                        'constructorId': 'red_bull',
                        'url': 'https://example.com/red_bull',
                        'name': 'Red Bull',
                        'nationality': 'Austrian'
                      }
                    ]
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/driverStandings',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/driverStandings'),
          ));

      final results = await formula1.getDriverStandings(year: 2023);
      expect(results, isNotEmpty);
      expect(results.length, 1);

      final result = results.first;
      expect(result.position, 1);
      expect(result.points, 25);
      expect(result.wins, 1);
      expect(result.driver.driverId, 'max_verstappen');
      expect(result.constructors.first.constructorId, 'red_bull');

      logger.i(
          'Driver Standings: ${results.map((r) => r.toString()).join(', ')}');
    });

    test('Get constructor standings', () async {
      final mockResponse = {
        'MRData': {
          'StandingsTable': {
            'StandingsLists': [
              {
                'season': '2023',
                'round': '1',
                'ConstructorStandings': [
                  {
                    'position': '1',
                    'positionText': '1',
                    'points': '43',
                    'wins': '1',
                    'Constructor': {
                      'constructorId': 'red_bull',
                      'url': 'https://example.com/red_bull',
                      'name': 'Red Bull',
                      'nationality': 'Austrian'
                    }
                  }
                ]
              }
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/constructorStandings',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/constructorStandings'),
          ));

      final results = await formula1.getConstructorStandings(year: 2023);
      expect(results, isNotEmpty);
      expect(results.length, 1);

      final result = results.first;
      expect(result.position, 1);
      expect(result.points, 43);
      expect(result.wins, 1);
      expect(result.constructor.constructorId, 'red_bull');

      logger.i(
          'Constructor Standings: ${results.map((r) => r.toString()).join(', ')}');
    });
  });

  group('Status Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test('Get status', () async {
      final mockResponse = {
        'MRData': {
          'StatusTable': {
            'Status': [
              {'statusId': '1', 'count': '20', 'status': 'Finished'},
              {'statusId': '2', 'count': '2', 'status': 'Accident'}
            ]
          }
        }
      };

      when(mockDio.get(
        '/2023/status',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/status'),
          ));

      final results = await formula1.getStatus(year: 2023);
      expect(results, isNotEmpty);
      expect(results.length, 2);

      final result = results.first;
      expect(result.statusId, 1);
      expect(result.count, 20);
      expect(result.status, 'Finished');

      logger.i('Status: ${results.map((r) => r.toString()).join(', ')}');
    });
  });
}
