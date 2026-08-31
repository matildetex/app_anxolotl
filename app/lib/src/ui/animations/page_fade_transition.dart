import 'package:flutter/cupertino.dart';

class PageFadeTransition extends CupertinoPageRoute {
  final Widget namedRoute;
  PageFadeTransition(this.namedRoute)
      : super(builder: (BuildContext context) => namedRoute);

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: namedRoute);
  }
}
