import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/common/widgets/function_utils.dart';
import 'package:rent_checklist/src/common/widgets/nullability_utils.dart';
import 'package:rent_checklist/src/res/strings.dart';

part 'generated/form_builder.freezed.dart';

@freezed
class InputField with _$InputField {
  const factory InputField({
    required String name,
    required TextEditingController controller,
    @Default(false) bool required,
  }) = _InputField;
}


class FormBuilder {
  final BuildContext context;

  final _formKey = GlobalKey<FormState>();

  String? _title;
  Provider<void Function()?>? _submitProvider;

  final _fields = <InputField>[];

  FormBuilder(this.context);

  FormBuilder title(String title) {
    _title = title;
    return this;
  }

  FormBuilder fields(List<InputField> fields) {
    _fields.addAll(fields);
    return this;
  }

  FormBuilder onSubmit(Provider<void Function()?> submit) {
    _submitProvider = submit;
    return this;
  }

  Form build() {
    requireNotNull(_submitProvider, name: 'onSubmit');

    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0,
        alignment: WrapAlignment.end,
        children: [
          _title?.let((title) => Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            )
          ),
          ..._fields.map((e) => _inputField(e)),
          ElevatedButton(
            onPressed: _submitProvider!()?.let((submitFn) => () {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              submitFn();
            }),
            child: const Icon(Icons.check),
          ),
        ].whereType<Widget>().toList(),
      ),
    );
  }

  TextFormField _inputField(InputField field) {
    return TextFormField(
        controller: field.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: field.name + (field.required ? '*' : ''),
        ),
        validator: (value) {
          if (field.required && value?.trim().isEmpty == true) {
            return Strings.formFieldRequiredError;
          }

          return null;
        }
    );
  }
}
