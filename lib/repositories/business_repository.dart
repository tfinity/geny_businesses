import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geny_businesses/models/business.dart';

class BusinessRepository {
  final Dio dio;
  CancelToken? _activeCancelToken;

  BusinessRepository({required this.dio});

  static const _cacheKey = 'cached_businesses_v1';
  static const int _maxRetries = 3;
  static const int _baseDelayMs = 300;

  Future<List<Business>> fetchBusinesses({bool forceNetwork = false}) async {
    // Cancel previous if active
    _activeCancelToken?.cancel('new request started');
    final cancelToken = CancelToken();
    _activeCancelToken = cancelToken;

    // Try network with retries and exponential backoff
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        final response = await dio.get(
          '/api/businesses',
          cancelToken: cancelToken,
        );
        if (cancelToken.isCancelled) {
          throw DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Cancelled',
          );
        }

        final List<dynamic> raw = (response.data as List<dynamic>);
        final List<Business> list = Business.listFromMessyJson(raw);

        // store cache
        final prefs = await SharedPreferences.getInstance();
        final encoded = jsonEncode(list.map((b) => b.toJson()).toList());
        await prefs.setString(_cacheKey, encoded);

        return list;
      } on DioException catch (e) {
        if (cancelToken.isCancelled) rethrow;
        // classify transient vs permanent
        final status = e.response?.statusCode ?? 0;
        final isTransient =
            (status >= 500 && status < 600) ||
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.unknown;

        if (!isTransient || attempt >= _maxRetries) {
          // Either permanent or no retries left -> try to return cache or rethrow
          final cached = await _loadFromCache();
          if (cached.isNotEmpty) return cached;
          rethrow;
        }

        // wait with exponential backoff
        final waitMs = _baseDelayMs * pow(2, attempt - 1).toInt();
        await Future.delayed(Duration(milliseconds: waitMs));
        continue;
      } catch (e) {
        // Any other error: fall back to cache if available
        final cached = await _loadFromCache();
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    }
  }

  Future<List<Business>> loadCached() async {
    return _loadFromCache();
  }

  Future<List<Business>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return [];
    try {
      final list = (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map((m) => Business.fromJson(m))
          .toList(growable: false);
      return list;
    } catch (_) {
      return [];
    }
  }

  void cancelActive() {
    _activeCancelToken?.cancel('cancelled by caller');
  }
}
