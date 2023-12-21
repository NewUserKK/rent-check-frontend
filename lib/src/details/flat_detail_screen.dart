import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/widgets/app_bar.dart';
import 'package:rent_checklist/src/details/flat_detail_list.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';

class FlatDetailScreen extends StatelessWidget {
  final FlatModel flat;

  const FlatDetailScreen({super.key, required this.flat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RentAppBar(title: flat.address),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FlatDetailList(flat: flat),
      ),
    );
  }
}
