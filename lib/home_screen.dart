import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';
import 'package:rent_checklist/src/auth/auth_screen.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';
import 'package:rent_checklist/src/flat/list/flats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<bool> _authRestoreJob;

  @override
  void initState() {
    super.initState();
    _authRestoreJob = Provider.of<AuthModel>(context, listen: false).restoreAuth();
  }

  @override
  Widget build(BuildContext context) {
    return renderOnLoad(
        _authRestoreJob,
        (restored) => restored ? const FlatsScreen() : const AuthScreen()
    );
  }
}
