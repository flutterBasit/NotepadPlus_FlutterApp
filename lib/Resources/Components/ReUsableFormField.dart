import 'package:flutter/material.dart';

class ReUsableTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String HintName;
  final int? MinLines;
  final TextStyle HintTextStyle;
  final Icon? prefixicon;

  ReUsableTextFormField(
      {super.key,
      required this.controller,
      required this.HintName,
      required this.HintTextStyle,
      this.MinLines,
      this.prefixicon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(color: Colors.white24, width: 2.5)),
          hintText: HintName,
          hintStyle: HintTextStyle,
          prefixIcon: prefixicon),
      validator: (value) {
        if (value!.isEmpty) {
          return "Can't be empty!";
        }
        return null;
      },
      maxLines: null,
      minLines: MinLines,
    );
  }
}
