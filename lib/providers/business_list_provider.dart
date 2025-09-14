import 'package:flutter/foundation.dart';
import 'package:geny_businesses/models/business.dart';
import 'package:geny_businesses/repositories/business_repository.dart';
import 'package:dio/dio.dart';

enum ViewState { idle, loading, loaded, empty, error }

class BusinessListProvider extends ChangeNotifier {
  final BusinessRepository repository;

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<Business> _items = [];
  List<Business> get items => List.unmodifiable(_items);

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _search = '';
  String get search => _search;

  BusinessListProvider({required this.repository});

  List<Business> get filteredItems {
    if (_search.trim().isEmpty) return items;
    final q = _search.toLowerCase();
    return items
        .where(
          (b) =>
              b.name.toLowerCase().contains(q) ||
              b.location.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  Future<void> load({bool forceNetwork = false}) async {
    _setState(ViewState.loading);
    try {
      final list = await repository.fetchBusinesses(forceNetwork: forceNetwork);
      _items = list;
      if (_items.isEmpty) {
        _setState(ViewState.empty);
      } else {
        _setState(ViewState.loaded);
      }
    } on DioException catch (e) {
      _errorMessage = e.error?.toString() ?? e.message ?? '';
      final cached = await repository.loadCached();
      if (cached.isNotEmpty) {
        _items = cached;
        _setState(ViewState.loaded);
      } else {
        _setState(ViewState.error);
      }
    } catch (e) {
      _errorMessage = e.toString();
      final cached = await repository.loadCached();
      if (cached.isNotEmpty) {
        _items = cached;
        _setState(ViewState.loaded);
      } else {
        _setState(ViewState.error);
      }
    }
  }

  void retry() {
    load(forceNetwork: true);
  }

  void setSearch(String s) {
    _search = s;
    notifyListeners();
  }

  @override
  void dispose() {
    repository.cancelActive();
    super.dispose();
  }

  void _setState(ViewState s) {
    _state = s;
    notifyListeners();
  }
}
