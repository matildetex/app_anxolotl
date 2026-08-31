import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});
  @override
  PreferredSizeWidget build(BuildContext context) {
    TextStyle? h2Style = Theme.of(context).textTheme.displayMedium;

    return AppBar(
        elevation: 0,
        title: AutoSizeText(
          title,
          maxLines: 1,
          minFontSize: 12,
          style: h2Style,
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
