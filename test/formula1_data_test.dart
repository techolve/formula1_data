import 'package:test/test.dart';
import 'package:formula1_data/formula1_data.dart';
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

  group('Formula1Data - User-Agent', () {
    test('sets a default User-Agent identifying the package', () {
      expect(
        formula1.dio.options.headers['User-Agent'],
        contains('formula1_data-dart'),
      );
    });

    test('prefixes a custom User-Agent when provided', () {
      final client = Formula1Data(userAgent: 'MyApp/1.0.0');
      expect(
        client.dio.options.headers['User-Agent'],
        startsWith('MyApp/1.0.0 formula1_data-dart'),
      );
    });
  });

  group('Formula1Data - Seasons', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test(
        'getSeasons returns a paginated result of seasons when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'total': '2',
          'limit': '30',
          'offset': '0',
          'SeasonTable': {
            'Seasons': [
              {'season': '2023', 'url': 'https://example.com/2023'},
              {'season': '2022', 'url': 'https://example.com/2022'},
            ]
          }
        }
      };

      when(mockDio.get(
        '/seasons',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/seasons'),
          ));

      // Act
      final result = await formula1.getSeasons();

      // Assert
      expect(result.items.length, 2);
      expect(result.total, 2);
      expect(result.items[0].year, 2023);
      expect(result.items[0].url, 'https://example.com/2023');
      expect(result.items[1].year, 2022);
      expect(result.items[1].url, 'https://example.com/2022');

      // Log results
      logger.i('Seasons: ${result.items.map((s) => s.toString()).join(', ')}');
    });

    test('getSeasons passes offset/limit through as query parameters',
        () async {
      final mockResponse = {
        'MRData': {
          'total': '80',
          'limit': '10',
          'offset': '30',
          'SeasonTable': {
            'Seasons': [
              {'season': '1980', 'url': 'https://example.com/1980'},
            ]
          }
        }
      };

      when(mockDio.get(
        '/seasons',
        queryParameters: {'offset': 30, 'limit': 10},
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/seasons'),
          ));

      final result = await formula1.getSeasons(offset: 30, limit: 10);

      expect(result.items.length, 1);
      expect(result.total, 80);
      expect(result.limit, 10);
      expect(result.offset, 30);

      verify(mockDio.get(
        '/seasons',
        queryParameters: {'offset': 30, 'limit': 10},
      )).called(1);
    });

    test('getSeasons returns an empty result when API call fails', () async {
      // Arrange
      when(mockDio.get(
        '/seasons',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/seasons'),
      ));

      // Act
      final result = await formula1.getSeasons();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API call failed: No seasons data returned');
    });

    test(
        'getSeasons returns an empty result when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get(
        '/seasons',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/seasons'),
          ));

      // Act
      final result = await formula1.getSeasons();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API returned status code 404: No seasons data found');
    });
  });

  group('Formula1Data - Circuits', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test(
        'getCircuits returns a paginated result of circuits when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'total': '2',
          'limit': '30',
          'offset': '0',
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

      when(mockDio.get(
        '/circuits',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/circuits'),
          ));

      // Act
      final result = await formula1.getCircuits();

      // Assert
      expect(result.items.length, 2);
      expect(result.total, 2);
      expect(result.items[0].circuitId, 'monaco');
      expect(result.items[0].circuitName, 'Circuit de Monaco');
      expect(result.items[0].location.latitude, 43.7347);
      expect(result.items[0].location.country, 'Monaco');
      expect(result.items[1].circuitId, 'silverstone');
      expect(result.items[1].circuitName, 'Silverstone Circuit');
      expect(result.items[1].location.latitude, 52.0786);
      expect(result.items[1].location.country, 'UK');

      // Log results
      logger.i('Circuits: ${result.items.map((c) => c.toString()).join(', ')}');
    });

    test('getCircuits returns an empty result when API call fails', () async {
      // Arrange
      when(mockDio.get(
        '/circuits',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/circuits'),
      ));

      // Act
      final result = await formula1.getCircuits();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API call failed: No circuits data returned');
    });

    test(
        'getCircuits returns an empty result when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get(
        '/circuits',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/circuits'),
          ));

      // Act
      final result = await formula1.getCircuits();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API returned status code 404: No circuits data found');
    });
  });

  group('Formula1Data - Races', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      formula1.dio = mockDio;
    });

    test(
        'getRaces returns a paginated result of races when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'total': '2',
          'limit': '30',
          'offset': '0',
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

      when(mockDio.get(
        '/races',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/races'),
          ));

      // Act
      final result = await formula1.getRaces();

      // Assert
      expect(result.items.length, 2);
      expect(result.total, 2);
      expect(result.items[0].season, 2023);
      expect(result.items[0].round, 1);
      expect(result.items[0].raceName, 'Bahrain Grand Prix');
      expect(result.items[0].circuit.circuitId, 'bahrain');
      expect(result.items[0].dateTime, DateTime.parse('2023-03-05 15:00:00Z'));
      expect(result.items[1].season, 2023);
      expect(result.items[1].round, 2);
      expect(result.items[1].raceName, 'Saudi Arabian Grand Prix');
      expect(result.items[1].circuit.circuitId, 'jeddah');
      expect(result.items[1].dateTime, DateTime.parse('2023-03-19 17:00:00Z'));

      // Log results
      logger.i('Races: ${result.items.map((r) => r.toString()).join(', ')}');
    });

    test('getRaces with season parameter returns filtered races', () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      when(mockDio.get(
        '/2023/races',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/races'),
          ));

      // Act
      final result = await formula1.getRaces(season: 2023);

      // Assert
      expect(result.items.length, 1);
      expect(result.items[0].season, 2023);
      expect(result.items[0].round, 1);
      expect(result.items[0].raceName, 'Bahrain Grand Prix');

      // Log results
      logger.i(
          'Races for 2023: ${result.items.map((r) => r.toString()).join(', ')}');
    });

    test('getRaces returns an empty result when API call fails', () async {
      // Arrange
      when(mockDio.get(
        '/races',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/races'),
      ));

      // Act
      final result = await formula1.getRaces();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API call failed: No races data returned');
    });

    test(
        'getRaces returns an empty result when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get(
        '/races',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/races'),
          ));

      // Act
      final result = await formula1.getRaces();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
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
        'getConstructors returns a paginated result of constructors when API call is successful',
        () async {
      // Arrange
      final mockResponse = {
        'MRData': {
          'total': '3',
          'limit': '30',
          'offset': '0',
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

      when(mockDio.get(
        '/constructors',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/constructors'),
          ));

      // Act
      final result = await formula1.getConstructors();

      // Assert
      expect(result.items.length, 3);
      expect(result.total, 3);
      expect(result.items[0].constructorId, 'mercedes');
      expect(result.items[0].name, 'Mercedes');
      expect(result.items[0].nationality, 'German');
      expect(result.items[1].constructorId, 'ferrari');
      expect(result.items[1].name, 'Ferrari');
      expect(result.items[1].nationality, 'Italian');
      expect(result.items[2].constructorId, 'red_bull');
      expect(result.items[2].name, 'Red Bull');
      expect(result.items[2].nationality, 'Austrian');

      // Log results
      logger.i(
          'Constructors: ${result.items.map((c) => c.toString()).join(', ')}');
    });

    test('getConstructors returns an empty result when API call fails',
        () async {
      // Arrange
      when(mockDio.get(
        '/constructors',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/constructors'),
      ));

      // Act
      final result = await formula1.getConstructors();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API call failed: No constructors data returned');
    });

    test(
        'getConstructors returns an empty result when response status code is not 200',
        () async {
      // Arrange
      when(mockDio.get(
        '/constructors',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/constructors'),
          ));

      // Act
      final result = await formula1.getConstructors();

      // Assert
      expect(result.items, isEmpty);
      expect(result.total, 0);
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
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      when(mockDio.get(
        '/drivers',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/drivers'),
          ));

      final result = await formula1.getDrivers();
      expect(result.items, isNotEmpty);
      expect(result.items.first, isA<Driver>());
      logger.i('Drivers: ${result.items.map((d) => d.toString()).join(', ')}');
    });

    test('Get drivers for specific season', () async {
      final mockResponse = {
        'MRData': {
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      when(mockDio.get(
        '/drivers/2023',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/drivers/2023'),
          ));

      final result = await formula1.getDrivers(season: 2023);
      expect(result.items, isNotEmpty);
      expect(result.items.first, isA<Driver>());
      logger.i(
          'Drivers for 2023: ${result.items.map((d) => d.toString()).join(', ')}');
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
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      when(mockDio.get(
        '/2023/1/results',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/2023/1/results'),
          ));

      final result = await formula1.getResults(season: 2023, round: 1);
      expect(result.items.length, 1);

      final raceResult = result.items.first;
      expect(raceResult.position, 1);
      expect(raceResult.points, 25);
      expect(raceResult.driver.driverId, 'max_verstappen');
      expect(raceResult.constructor.constructorId, 'red_bull');
      expect(raceResult.grid, 1);
      expect(raceResult.laps, 57);
      expect(raceResult.status, 'Finished');
      expect(raceResult.time?.time, '1:33:56.736');
      expect(raceResult.fastestLap?.rank, 1);
      expect(raceResult.fastestLap?.lap, 44);
      expect(raceResult.fastestLap?.time.time, '1:33.996');
      expect(raceResult.fastestLap?.averageSpeed.units, 'kph');
      expect(raceResult.fastestLap?.averageSpeed.speed, 207.235);

      logger.i(
          'Race Results: ${result.items.map((r) => r.toString()).join(', ')}');
    });

    test('Get race results returns an empty result when API call fails',
        () async {
      when(mockDio.get(
        '/2023/1/results',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/2023/1/results'),
      ));

      final result = await formula1.getResults(season: 2023, round: 1);
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API call failed: No results data returned');
    });

    test(
        'Get race results returns an empty result when response status code is not 200',
        () async {
      when(mockDio.get(
        '/2023/1/results',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/2023/1/results'),
          ));

      final result = await formula1.getResults(season: 2023, round: 1);
      expect(result.items, isEmpty);
      expect(result.total, 0);
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
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      final result = await formula1.getSprint(year: 2023);
      expect(result.items, isNotEmpty);
      expect(result.items.length, 1);

      final sprintResult = result.items.first;
      expect(sprintResult.position, 1);
      expect(sprintResult.points, 8);
      expect(sprintResult.driver.driverId, 'max_verstappen');
      expect(sprintResult.constructor.constructorId, 'red_bull');
      expect(sprintResult.grid, 1);
      expect(sprintResult.laps, 24);
      expect(sprintResult.status, 'Finished');
      expect(sprintResult.time?.time, '0:20:34.567');
      expect(sprintResult.fastestLap?.rank, 1);
      expect(sprintResult.fastestLap?.lap, 12);
      expect(sprintResult.fastestLap?.time.time, '1:33.996');

      logger.i(
          'Sprint Results: ${result.items.map((r) => r.toString()).join(', ')}');
    });

    test('Get sprint results returns an empty result when API call fails',
        () async {
      when(mockDio.get(
        '/2023/sprint',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/2023/sprint'),
      ));

      final result = await formula1.getSprint(year: 2023);
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API call failed: No sprint results returned');
    });

    test(
        'Get sprint results returns an empty result when response status code is not 200',
        () async {
      when(mockDio.get(
        '/2023/sprint',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/2023/sprint'),
          ));

      final result = await formula1.getSprint(year: 2023);
      expect(result.items, isEmpty);
      expect(result.total, 0);
      logger.w('API returned status code 404: No sprint results found');
    });

    test('Get sprint results with pagination', () async {
      final mockResponse = {
        'MRData': {
          'total': '1',
          'limit': '5',
          'offset': '10',
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

      final result = await formula1.getSprint(
        year: 2023,
        offset: 10,
        limit: 5,
      );
      expect(result.items, isNotEmpty);
      expect(result.items.length, 1);
      expect(result.total, 1);
      expect(result.limit, 5);
      expect(result.offset, 10);

      verify(mockDio.get(
        '/2023/sprint',
        queryParameters: {
          'offset': 10,
          'limit': 5,
        },
      )).called(1);

      logger.i(
          'Sprint Results with Pagination: ${result.items.map((r) => r.toString()).join(', ')}');
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
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      final result = await formula1.getQualifying(year: 2023);
      expect(result.items, isNotEmpty);
      expect(result.items.length, 1);

      final qualifyingResult = result.items.first;
      expect(qualifyingResult.position, 1);
      expect(qualifyingResult.driver.driverId, 'max_verstappen');
      expect(qualifyingResult.constructor.constructorId, 'red_bull');
      expect(qualifyingResult.q1, '1:30.000');
      expect(qualifyingResult.q2, '1:29.500');
      expect(qualifyingResult.q3, '1:29.000');

      logger.i(
          'Qualifying Results: ${result.items.map((r) => r.toString()).join(', ')}');
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
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      final result = await formula1.getPitStops(year: 2023, round: 1);
      expect(result.items, isNotEmpty);
      expect(result.items.length, 1);

      final pitStop = result.items.first;
      expect(pitStop.stop, 1);
      expect(pitStop.lap, 10);
      expect(pitStop.time, '15:20:00');
      expect(pitStop.duration, '2.5');
      expect(pitStop.driver.driverId, 'max_verstappen');
      expect(pitStop.constructor.constructorId, 'red_bull');

      logger
          .i('Pit Stops: ${result.items.map((r) => r.toString()).join(', ')}');
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
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      final result = await formula1.getLaps(year: 2023, round: 1);
      expect(result.items, isNotEmpty);
      expect(result.items.length, 1);

      final lapTime = result.items.first;
      expect(lapTime.driverId, 'norris');
      expect(lapTime.position, 1);
      expect(lapTime.time, '1:57.099');

      logger
          .i('Lap Times: ${result.items.map((r) => r.toString()).join(', ')}');
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
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      final result = await formula1.getDriverStandings(year: 2023);
      expect(result.items, isNotEmpty);
      expect(result.items.length, 1);

      final standing = result.items.first;
      expect(standing.position, 1);
      expect(standing.points, 25);
      expect(standing.wins, 1);
      expect(standing.driver.driverId, 'max_verstappen');
      expect(standing.constructors.first.constructorId, 'red_bull');

      logger.i(
          'Driver Standings: ${result.items.map((r) => r.toString()).join(', ')}');
    });

    test('Get constructor standings', () async {
      final mockResponse = {
        'MRData': {
          'total': '1',
          'limit': '30',
          'offset': '0',
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

      final result = await formula1.getConstructorStandings(year: 2023);
      expect(result.items, isNotEmpty);
      expect(result.items.length, 1);

      final standing = result.items.first;
      expect(standing.position, 1);
      expect(standing.points, 43);
      expect(standing.wins, 1);
      expect(standing.constructor.constructorId, 'red_bull');

      logger.i(
          'Constructor Standings: ${result.items.map((r) => r.toString()).join(', ')}');
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
          'total': '2',
          'limit': '30',
          'offset': '0',
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

      final result = await formula1.getStatus(year: 2023);
      expect(result.items, isNotEmpty);
      expect(result.items.length, 2);

      final status = result.items.first;
      expect(status.statusId, 1);
      expect(status.count, 20);
      expect(status.status, 'Finished');

      logger.i('Status: ${result.items.map((r) => r.toString()).join(', ')}');
    });
  });
}
