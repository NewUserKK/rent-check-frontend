import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/widgets/form_builder.dart';
import 'package:rent_checklist/src/common/widgets/snackbar.dart';
import 'package:rent_checklist/src/detail/flat_detail_screen.dart';
import 'package:rent_checklist/src/flat/flats_view_model.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatForm extends StatefulWidget {
  const FlatForm({super.key});

  @override
  State<StatefulWidget> createState() => _FlatFormState();
}

class _FlatFormState extends State<FlatForm> {
  final formKey = GlobalKey<FormState>();

  final _addressController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  var _submitEnabled = true;

  @override
  void dispose() {
    final controllers = [
      _addressController,
      _titleController,
      _descriptionController
    ];

    for (var controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(context, formKey)
        .fields([
          InputField(
            name: Strings.flatFormFieldAddress,
            controller: _addressController,
            required: true,
          ),
          InputField(
            name: Strings.flatFormFieldTitle,
            controller: _titleController,
          ),
          InputField(
            name: Strings.flatFormFieldDescription,
            controller: _descriptionController,
          ),
        ])
        .submitButtons([
          SubmitButton(onSubmitProvider: () => _submitEnabled ? _submit : null),
        ])
        .build();
  }

  void _submit() async {
    final flat = FlatModel(
      address: _addressController.text.trim(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    _setButtonEnabled(false);

    try {
      final newFlat = await Provider
          .of<FlatsViewModel>(context, listen: false)
          .createFlat(flat);

      if (context.mounted) {
        Navigator.pop(context);
        _navigateToFlatDetail(context, newFlat);
      }
    } on NetworkError catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Flat add error: $e");
      }
    } finally {
      _setButtonEnabled(true);
    }
  }

  void _setButtonEnabled(bool value) {
    setState(() {
      _submitEnabled = value;
    });
  }

  void _navigateToFlatDetail(BuildContext context, FlatModel flat) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => FlatDetailScreen(flat: flat))
    );
  }
}
