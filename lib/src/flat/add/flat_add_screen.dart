import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/widgets/app_bar.dart';
import 'package:rent_checklist/src/flat/add/flat_form.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatAddScreen extends StatefulWidget {
  const FlatAddScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FlatAddScreenState();
}

class _FlatAddScreenState extends State<FlatAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RentAppBar(title: Strings.flatAddToolbarTitle),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FlatForm(),
      ),
    );
  }
}
