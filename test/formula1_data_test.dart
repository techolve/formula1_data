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

  group('Formula1Api', () {
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
}
