import 'package:flutter/material.dart';
import 'package:rent_checklist/src/common/network/api_utils.dart';
import 'package:rent_checklist/src/common/widgets/snackbar.dart';
import 'package:rent_checklist/src/flat/details/flat_detail_screen.dart';
import 'package:rent_checklist/src/flat/flat_api.dart';
import 'package:rent_checklist/src/flat/flat_model.dart';
import 'package:rent_checklist/src/res/strings.dart';

class FlatForm extends StatefulWidget {
  const FlatForm({super.key});

  @override
  State<StatefulWidget> createState() => _FlatFormState();
}

class _FlatFormState extends State<FlatForm> {
  final _formKey = GlobalKey<FormState>();

  final _addressController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _flatApi = FlatApiFactory.create();

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
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0,
        children: [
          _inputField(
            fieldName: Strings.flatFormFieldAddress,
            controller: _addressController,
            required: true,
          ),
          _inputField(
            fieldName: Strings.flatFormFieldTitle,
            controller: _titleController,
          ),
          _inputField(
            fieldName: Strings.flatFormFieldDescription,
            controller: _descriptionController,
          ),
          ElevatedButton(
            onPressed: _submitEnabled ? _submit : null,
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  TextFormField _inputField({
    required String fieldName,
    required TextEditingController controller,
    bool required = false,
  }) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: fieldName + (required ? '*' : ''),
        ),
        validator: (value) {
          if (required && value?.trim().isEmpty == true) {
            return Strings.flatFormFieldRequiredError;
          }

          return null;
        });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final flat = FlatModel(
      address: _addressController.text.trim(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    _setButtonEnabled(false);

    try {
      var addedFlat = await _flatApi.createFlat(flat);
      if (context.mounted) {
        SnackBarUtils.showSnackBar(context, "Flat added: $addedFlat");
        Navigator.pop(context);
        _navigateToFlatDetail(context, flat);
      }
    } on NetworkError catch (e) {
      if (context.mounted) {
        SnackBarUtils.showSnackBar(context, "Flat add error: $e");
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
