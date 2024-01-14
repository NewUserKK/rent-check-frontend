import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:rent_checklist/src/flat/list/flats_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthModel _authModel = AuthModel();

  @override
  void initState() {
    super.initState();
    initializeHttpClient(authModel: _authModel);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authModel,
      child: const MaterialApp(
          home: FlatsScreen()
      ),
    );
  }
}
