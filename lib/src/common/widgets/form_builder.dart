import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rent_checklist/src/common/utils/extensions.dart';
import 'package:rent_checklist/src/common/widgets/function_utils.dart';
import 'package:rent_checklist/src/res/strings.dart';

part 'generated/form_builder.freezed.dart';

@freezed
class InputField with _$InputField {
  const factory InputField({
    /// Name of this field. Will be displayed as label.
    required String name,

    /// Controller for this field. Will be used to get field value.
    required TextEditingController controller,

    /// Type of keyboard that will be used for this field.
    @Default(TextInputType.text) TextInputType keyboardType,

    /// Whether this field should obscure text, useful for passwords.
    @Default(false) bool obscureText,

    /// Whether this field is required. Will display '*' next to field name
    /// and will be used for validation.
    @Default(false) bool required,

    /// Custom validator that will be called in addition to required validator.
    @Default(null) String? Function(String?)? customValidator,
  }) = _InputField;
}


@freezed
class SubmitButton with _$SubmitButton {
  const factory SubmitButton({
    /// Provider of function that will be called on button press.
    /// If provider returns null, button will be disabled, otherwise provided
    /// function will be called after form validation.
    required Provider<void Function()?> onSubmitProvider,

    /// Text on button. Can be used in conjunction with [icon].
    @Default("") String text,

    /// Icon on button. Can be used in conjunction with [text].
    @Default(null) Icon? icon,
  }) = _SubmitButton;
}


class FormBuilder {
  final BuildContext context;

  final GlobalKey<FormState> formKey;

  String? _title;

  final _fields = <InputField>[];
  final _submitButtons = <SubmitButton>[];

  FormBuilder(this.context, this.formKey);

  FormBuilder title(String title) {
    _title = title;
    return this;
  }

  FormBuilder fields(List<InputField> fields) {
    _fields.addAll(fields);
    return this;
  }

  FormBuilder submitButtons(List<SubmitButton> buttons) {
    _submitButtons.addAll(buttons);
    return this;
  }

  Form build() {
    return Form(
      key: formKey,
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
          Row(
            mainAxisAlignment: _submitButtons.length == 1
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
            children: _submitButtons.map((e) => _constructButton(e)).toList(),
          ),
        ].whereType<Widget>().toList(),
      ),
    );
  }

  TextFormField _inputField(InputField field) {
    return TextFormField(
        controller: field.controller,
        keyboardType: field.keyboardType,
        obscureText: field.obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: field.name + (field.required ? '*' : ''),
        ),
        validator: (value) {
          if (field.required && value?.trim().isEmpty == true) {
            return Strings.formFieldRequiredError;
          }

          final customValidator = field.customValidator;
          if (customValidator != null) {
            return customValidator(value);
          }

          return null;
        }
    );
  }

  Widget _constructButton(SubmitButton button) {
    final Widget buttonContent;
    if (button.text.isNotEmpty && button.icon != null) {
      buttonContent = Row(
        children: [
          Text(button.text),
          const SizedBox(width: 8.0),
          button.icon!,
        ],
      );
    } else if (button.text.isNotEmpty) {
      buttonContent = Text(button.text);
    } else if (button.icon != null) {
      buttonContent = button.icon!;
    } else {
      buttonContent = const Icon(Icons.check);
    }

    final onPressed = button.onSubmitProvider()?.let((submitFn) => () {
      if (!formKey.currentState!.validate()) {
        return;
      }

      submitFn();
    });

    return ElevatedButton(
      onPressed: onPressed,
      child: buttonContent
    );
  }
}
