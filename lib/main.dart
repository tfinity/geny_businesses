import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geny_businesses/providers/business_list_provider.dart';
import 'package:geny_businesses/network/dio_client.dart';
import 'package:geny_businesses/repositories/business_repository.dart';
import 'package:geny_businesses/screens/list_screen.dart';

void main() {
  // debugPrintRebuildDirtyWidgets = true; // uncomment during dev to detect unnecessary rebuilds
  final dio = createDioClient();
  final repo = BusinessRepository(dio: dio);

  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  final BusinessRepository repository;
  const MyApp({required this.repository, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BusinessListProvider(repository: repository),
        ),
      ],
      child: MaterialApp(
        title: 'Businesses',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: const ListScreen(),
      ),
    );
  }
}
