import 'package:flutter/material.dart';

class RentAppBar extends AppBar {
  RentAppBar({required String title, Key? key})
      : super(
          key: key,
          title: Text(title),
        );
}
