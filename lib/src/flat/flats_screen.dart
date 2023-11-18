import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/app_bar.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatsScreen extends StatelessWidget {
  const FlatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RentAppBar(
        title: Strings.flatsToolbarTitle,
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
