import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_checklist/src/common/widgets/form_builder.dart';
import 'package:rent_checklist/src/common/widgets/snackbar.dart';
import 'package:rent_checklist/src/details/flat_detail_view_model.dart';
import 'package:rent_checklist/src/details/group/group_model.dart';
import 'package:rent_checklist/src/res/strings.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({super.key});

  @override
  State<StatefulWidget> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
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
        .title(Strings.groupFormTitle)
        .fields([
          InputField(
            name: Strings.groupFormFieldTitle,
            controller: _titleController,
            required: true,
          ),
        ])
        .onSubmit(() => _submitEnabled ? _submit : null)
        .build();
  }

  void _submit() async {
    final group = GroupModel(
      title: _titleController.text.trim(),
    );

    _setButtonEnabled(false);

    try {
      await Provider
          .of<FlatDetailViewModel>(context, listen: false)
          .createAndAddGroup(group);
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Group add error: $e");
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
