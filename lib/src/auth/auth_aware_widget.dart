import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';
import 'package:rent_checklist/src/auth/auth_screen.dart';
import 'package:rent_checklist/src/auth/auth_state.dart';
import 'package:rent_checklist/src/common/widgets/load_utils.dart';

class AuthAwareWidget extends StatelessWidget {
  final Widget _child;

  const AuthAwareWidget({super.key, required child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, model, child) {
        doOnPostFrame(context, () {
          final navigator = Navigator.of(context);
          if (model.state is NotAuthorized) {
            navigator.popUntil((route) => route.isFirst);
            navigator.pop();
            navigator.push(
                MaterialPageRoute(builder: (context) => const AuthScreen())
            );
          }
        });

        return _child;
      }
    );
  }
}
