import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';
import 'package:rent_checklist/src/common/widgets/form_builder.dart';
import 'package:rent_checklist/src/flat/list/flats_screen.dart';
import 'package:rent_checklist/src/res/strings.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _submitEnabled = true;

  @override
  void dispose() {
    super.dispose();
    _loginController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(context)
        .title(Strings.authTitle)
        .fields([
          InputField(
            name: Strings.authFormFieldLogin,
            controller: _loginController,
            required: true,
          ),
          InputField(
            name: Strings.authFormFieldPassword,
            controller: _passwordController,
            required: true,
          ),
        ])
        .submitButtons([
          SubmitButton(
              text: Strings.authFormRegisterButton,
              onSubmitProvider: () => _submitEnabled ? _register : null
          ),
          SubmitButton(
              text: Strings.authFormLoginButton,
              onSubmitProvider: () => _submitEnabled ? _login : null
          ),
        ])
        .build();
  }

  void _register() async {
    _setButtonsEnabled(false);

    await Provider
        .of<AuthModel>(context, listen: false)
        .register(_loginController.text, _passwordController.text);

    _setButtonsEnabled(true);
  }

  void _login() async {
    _setButtonsEnabled(false);

    await Provider
        .of<AuthModel>(context, listen: false)
        .login(_loginController.text, _passwordController.text);

    if (context.mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const FlatsScreen())
      );
    }

    _setButtonsEnabled(true);
  }

  void _setButtonsEnabled(bool value) {
    setState(() {
      _submitEnabled = value;
    });
  }
}
