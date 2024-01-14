import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/auth/auth_model.dart';

class RentAppBar extends AppBar {
  RentAppBar(
      BuildContext context, {
        required String title,
        Key? key,
      }
  ) : super(
    key: key,
    title: Text(title),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () => Provider.of<AuthModel>(context, listen: false).logout(),
      ),
    ]
  );
}
