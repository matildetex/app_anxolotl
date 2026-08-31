import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:flutter/material.dart';

class ProfileTextField extends StatefulWidget {
  const ProfileTextField(
      {super.key,
      required this.textFieldWidth,
      required this.textFieldLabel,
      required this.onTap,
      this.textData = "",
      this.raisesEmptyError = false});
  final double textFieldWidth;
  final String textFieldLabel;
  final String textData;
  final void Function() onTap;
  final bool raisesEmptyError;

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    textController.text = widget.textData;
    Color? outline = Theme.of(context).colorScheme.outline;

    return SizedBox(
      width: widget.textFieldWidth,
      child: TextField(
        readOnly: true,
        controller: textController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: outline,
            ),
            suffixStyle: TextStyle(color: outline),
            labelText: widget.textFieldLabel,
            labelStyle: TextStyle(color: outline),
            errorText: getErrorText(textController)),
        onTap: widget.onTap,
      ),
    );
  }

  String? getErrorText(TextEditingController textController) {
    final text = textController.value.text;

    if (text.isEmpty && widget.raisesEmptyError) {
      return LocalizationsUtil.l10n(context).pleaseInsertValue;
    }
    return null;
  }
}
