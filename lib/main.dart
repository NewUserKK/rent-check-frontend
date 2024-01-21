import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/home_screen.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';
import 'package:rent_checklist/src/common/network/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SharedPreferences.getInstance();
  } on MissingPluginException catch (_) {
    if (kDebugMode) {
      print('Initialize shared prefs with empty value');
    }
    // see https://stackoverflow.com/questions/74093954/how-to-fix-no-implementation-found-for-method-getall-on-channel-plugins-flutter
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  }

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
          home: HomeScreen()
      ),
    );
  }
}
