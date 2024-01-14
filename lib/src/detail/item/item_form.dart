import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/widgets/form_builder.dart';
import 'package:rent_checklist/src/common/widgets/snackbar.dart';
import 'package:rent_checklist/src/detail/flat_detail_view_model.dart';
import 'package:rent_checklist/src/detail/item/item_model.dart';
import 'package:rent_checklist/src/res/strings.dart';

class ItemForm extends StatefulWidget {
  final int groupId;

  const ItemForm({super.key, required this.groupId});

  @override
  State<StatefulWidget> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _titleController = TextEditingController();

  var _submitEnabled = true;

  @override
  void dispose() {
    final controllers = [
      _titleController,
    ];

    for (var controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(context)
        .title(Strings.itemFormTitle)
        .fields([
          InputField(
            name: Strings.itemFormFieldTitle,
            controller: _titleController,
            required: true,
          ),
        ])
        .onSubmit(() => _submitEnabled ? _submit : null)
        .build();
  }

  void _submit() async {
    final item = ItemModel(
      title: _titleController.text.trim(),
    );

    _setButtonEnabled(false);

    try {
      await Provider
          .of<FlatDetailViewModel>(context, listen: false)
          .createAndAddItem(widget.groupId, item);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Item add error: $e");
      }
    } finally {
      _setButtonEnabled(true);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _setButtonEnabled(bool value) {
    setState(() {
      _submitEnabled = value;
    });
  }
}
