import 'package:flutter/material.dart';

class BaseFormTextField extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final String emptyError;
  final BuildContext context;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final bool isNumber;
  final String? numberError;
  final String? negativeError;
  final bool baseFormState;
  BaseFormTextField({
    required this.label,
    required this.textController,
    required this.maxLength,
    required this.emptyError,
    required this.context,
    required this.focusNode,
    required this.baseFormState,
    this.minLines = 1,
    this.maxLines = 1,
    this.nextFocusNode,
    this.isNumber = false,
    this.numberError,
    this.negativeError,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        enabled: !baseFormState,
        controller: textController,
        focusNode: focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: isNumber
            ? TextInputType.numberWithOptions()
            : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) return emptyError;
          if (isNumber) {
            final numValue = double.tryParse(value);
            if (numValue == null) return numberError;
            if (numValue < 0) return negativeError;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }
}
