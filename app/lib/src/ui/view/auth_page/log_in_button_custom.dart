import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';

class SignInButtonCustom extends StatelessWidget {
  const SignInButtonCustom(
      {super.key, required this.buttonType,
      required this.buttonText,
      required this.buttonAction});
  final ButtonType buttonType;
  final String buttonText;
  final void Function() buttonAction;

  @override
  Widget build(BuildContext context) {
    return SignInButton(
        buttonType: buttonType,
        //[buttonSize] You can also use this in combination with [width]. Increases the font and icon size of the button.
        buttonSize: ButtonSize.medium,
        btnTextColor: Colors.black,
        btnColor: Colors.white,
        elevation: 0,
        padding: 8,
        width: 240,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignTheme.roundedCornersRadius),
            side: BorderSide(
                color: Theme.of(context).colorScheme.outline, width: 2)),
        //width: 140,
        //[width] Use if you change the text value.
        btnText: buttonText,
        onPressed: () => buttonAction());
  }
}
